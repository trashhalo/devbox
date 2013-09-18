#devbox

puppet files for my personal dev box.

##Setup
1. Take a look at [init.pp](manifests/init.pp) for configurable variables
2. Execute `./boostrap.sh`

##What does it install?

Packages:  
* vim
* git
* zsh
* virtualbox
* curl
* sublime-text
* google-chrome
* spotify
* vagrant

Apt-Reps:  
* ppa:webupd8team/sublime-text-2 
* http://dl.google.com/linux/chrome/deb/
* http://repository.spotify.com

Configure:
* git user.name
* git user.email
* git push.default
* creates ~/dev/src and ~/dev/tools directories
* generates ssh private key
* adds precise64 vagrant box
* installs vagrant-list plugin
* installs oh-my-zsh and changes shell to zsh
