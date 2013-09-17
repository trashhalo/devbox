wget -N http://apt.puppetlabs.com/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb
sudo apt-get update
sudo apt-get install puppet
sudo puppet apply --verbose --debug --modulepath=~/devbox/modules ~/devbox/manifests/init.pp
