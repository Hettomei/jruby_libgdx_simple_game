include Java

Dir["libs/\*.jar"].each { |jar| require jar }

java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration

java_import com.badlogic.gdx.ApplicationListener
java_import com.badlogic.gdx.Gdx

java_import com.badlogic.gdx.graphics.Texture
java_import com.badlogic.gdx.graphics.OrthographicCamera
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch
java_import com.badlogic.gdx.graphics.GL10

java_import com.badlogic.gdx.math.Rectangle
java_import com.badlogic.gdx.math.Vector3
java_import com.badlogic.gdx.math.MathUtils;

java_import com.badlogic.gdx.utils.TimeUtils

java_import com.badlogic.gdx.Input::Keys

class Drop
  include ApplicationListener

  def create
    # load the images for the droplet and the bucket, 64x64 pixels each
    @drop_image = Texture.new(Gdx.files.internal("gfx/droplet.png"))
    @bucket_image = Texture.new(Gdx.files.internal("gfx/bucket.png"))

    # load the drop sound effect and the rain background "music"
    @drop_sound = Gdx.audio.new_sound Gdx.files.internal("sfx/drop.wav")
    @rain_music = Gdx.audio.new_music Gdx.files.internal("sfx/rain.mp3")

    # start the playback of the background music immediately
    @rain_music.set_looping true
    @rain_music.play

    @camera = OrthographicCamera.new
    @camera.set_to_ortho(false, 800, 480)
    @batch = SpriteBatch.new

    @bucket = Rectangle.new
    @bucket.x = 800 / 2 - 64 / 2
    @bucket.y = 20
    @bucket.width = 64
    @bucket.height = 64

    @raindrops = []
    @last_drop_time = 0
    spawn_raindrop
  end

  def spawn_raindrop
    raindrop = Rectangle.new
    raindrop.x = com.badlogic.gdx.math::MathUtils.random(0, 800-64)
    raindrop.y = 480
    raindrop.width = 64
    raindrop.height = 64
    @raindrops << raindrop
    @last_drop_time = TimeUtils.nano_time
  end

  def render
    Gdx.gl.gl_clear_color(0, 0, 0.2, 1)
    Gdx.gl.gl_clear(GL10.GL_COLOR_BUFFER_BIT)

    @camera.update

    @batch.set_projection_matrix(@camera.combined)

    @batch.begin
    @batch.draw(@bucket_image, @bucket.x, @bucket.y)
    @raindrops.each do |r|
      @batch.draw(@drop_image, r.x, r.y)
    end
    @batch.end

    if Gdx.input.touched?
      touch_pos = Vector3.new
      touch_pos.set(Gdx.input.get_x, Gdx.input.get_y, 0)
      @camera.unproject(touch_pos)
      @bucket.x = touch_pos.x - 64 / 2
    end

    @bucket.x -= 200 * Gdx.graphics.get_delta_time() if Gdx.input.is_key_pressed(Keys::LEFT)
    @bucket.x += 200 * Gdx.graphics.get_delta_time() if Gdx.input.is_key_pressed(Keys::RIGHT)

    @bucket.x = 0 if @bucket.x < 0
    @bucket.x = 800 - 64 if @bucket.x > 800 - 64

    spawn_raindrop if(TimeUtils.nano_time - @last_drop_time > 1000000000)

    to_delete = []
    @raindrops.each do |raindrop|
      raindrop.y -= 200 * Gdx.graphics.get_delta_time
      if(raindrop.y + 64 < 0)
        to_delete << raindrop
      end
      if raindrop.overlaps(@bucket)
        @drop_sound.play
        to_delete << raindrop
      end
    end
    @raindrops = @raindrops - to_delete
  end


  def resize width, height
  end

  def pause

  end

  def resume

  end

  def dispose
    @drop_image.dispose
    @bucket_image.dispose
    @batch.dispose
  end

end

cfg = LwjglApplicationConfiguration.new
cfg.title = "Drop"
cfg.width = 800
cfg.height = 480
LwjglApplication.new(Drop.new, cfg)
