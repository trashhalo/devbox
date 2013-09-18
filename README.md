#devbox

puppet files for my personal dev box.

##Setup
`./boostrap.sh`

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
