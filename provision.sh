DIR="$( pwd )"
sudo puppet apply --verbose --debug --modulepath=$DIR/modules ~/devbox/manifests/init.pp
