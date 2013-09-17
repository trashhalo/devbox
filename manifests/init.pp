$username = "trashhalo"
$fullname = "Stephen Solka"
$email = "stephen@mindjunk.org"

package{'vim':
 ensure => 'latest'
}
package{'git-core':
 ensure => 'latest'
}
exec{'git-user':
 command=>"/bin/su --command='git config --global user.name \"$fullname\"' $username",
 require=> Package['git-core'],
}
exec{'git-email':
 command=>"/bin/su --command='git config --global user.email \"$email\"' $username",
 require=> Package['git-core'],
}
exec{'add-sublime-ppa':
 command=>'/usr/bin/add-apt-repository ppa:webupd8team/sublime-text-2 && apt-get update',
 creates=>'/etc/apt/sources.list.d/webupd8team-sublime-text-2-raring.list'
}
package{'sublime-text':
 ensure => 'latest',
 require => Exec['add-sublime-ppa']
}
package{'virtualbox':
 ensure => 'latest'
}
package{'curl':
 ensure => 'latest'
}
exec{'download-vagrant':
 command=>'/usr/bin/curl -o /tmp/vagrant.deb http://files.vagrantup.com/packages/b12c7e8814171c1295ef82416ffe51e8a168a244/vagrant_1.3.1_x86_64.deb',
 creates=>'/tmp/vagrant.deb',
 require=>Package['curl']
}
exec{'install-vagrant':
 command=>'/usr/bin/dpkg -i /tmp/vagrant.deb',
 require=>Exec['download-vagrant'],
 creates=>'/usr/bin/vagrant'
}
exec{'add-ubuntu-vagrant-box':
 command=>"/bin/su --command='/usr/bin/vagrant box add precise64 http://files.vagrantup.com/precise64.box' $username",
 require=>Exec['install-vagrant'],
 creates=>"/home/$username/.vagrant.d/boxes/precise64"
}
exec{'add-vagrant-plugin-list':
 command=>"/bin/su --command='/usr/bin/vagrant plugin install vagrant-list' $username",
 require=>Exec['install-vagrant']
}
file{"/home/$username/dev":
 ensure=>'directory',
 owner=>$username
}
file{"/home/$username/dev/src":
 ensure=>'directory',
 owner=>$username
}
file{"/home/$username/dev/tools":
 ensure=>'directory',
 owner=>$username
}
exec{'add-chrome-key':
 command=>'/usr/bin/wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -',
 unless=>'/usr/bin/strings /etc/apt/trusted.gpg|grep google 2>/dev/null'
}
file{'/etc/apt/sources.list.d/google.list':
 ensure=>"present",
 content=>"deb http://dl.google.com/linux/chrome/deb/ stable main",
 require=>Exec['add-chrome-key']
}
exec{'apt-update-google':
 command=>"/usr/bin/apt-get update",
 require=>File['/etc/apt/sources.list.d/google.list'],
 creates=>'/usr/bin/google-chrome'
}
package{"google-chrome-stable":
 ensure=>"latest",
 require=>Exec["apt-update-google"]
}
exec{'create-ssh-key':
 command=>"/bin/su --command='ssh-keygen -f /home/$username/.ssh/id_rsa -N \"\"' $username",
 creates=>"/home/$username/.ssh/id_rsa"
}
file{"/home/$username/.ssh/id_rsa":
 require=>Exec['create-ssh-key'],
 mode=>"0600"
}
package{'zsh':
 ensure=>'latest'
}