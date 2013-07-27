It s a port from the tutorial https://code.google.com/p/libgdx/wiki/SimpleApp#A_Simple_Game
in Jruby http://jruby.org/

How to install JRuby ?

Unix system :
I recommand rbenv : https://github.com/sstephenson/rbenv/
or chruby https://github.com/postmodern/chruby

for rbenv, after doing https://github.com/sstephenson/rbenv/#installation, install jruby
```
rbenv install jruby-1.7.3
```
Windows:
I can't halp you, maybe http://www.iowaosum.com/install-jruby do the job

How to play ?

it the root of the project, their is a .ruby-version file, it tells
rbenv to run it with jruby 1.7

then open your terminal, cd my app and type
```
ruby game.rb
```
or
```
jruby game.rb
```
