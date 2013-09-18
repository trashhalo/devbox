DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sudo puppet apply --verbose --debug --modulepath=$DIR/modules ~/devbox/manifests/init.pp
