$username = "trashhalo"
$fullname = "Stephen Solka"
$email = "stephen@mindjunk.org"

###### Helper Types

package{'curl':
	ensure => 'present'
}

define remote-package($packagename=$title,$url,$creates){
	exec{"download-$packagename":
 		command=>"/usr/bin/curl -o /tmp/$packagename.deb $url",
 		creates=>$creates,
 		require=>Package['curl']
 	}

	package{"$packagename":
		ensure=>"present",
 		require=>Exec["download-$packagename"],
 		source=>"/tmp/$packagename.deb",
 		provider=>"dpkg"
	}
}

define apt-update-single($repofile=$title,$source){
	file{"/etc/apt/sources.list.d/${repofile}.list":
		ensure=>'present',
		content=>$source,
	}

	exec{"apt-get-update-$repofile":
		command=>"/usr/bin/apt-get update -o Dir::Etc::sourcelist=\"sources.list.d/${repofile}.list\" -o Dir::Etc::sourceparts=\"-\" -o APT::Get::List-Cleanup=\"0\"",
		require=>File["/etc/apt/sources.list.d/${repofile}.list"],
		unless=>"/bin/ls /var/lib/apt/lists/|grep $repofile 2>/dev/null"
	}
}

###### Global Packages

package{'vim':
 ensure => 'present'
}
package{'git-core':
 ensure => 'present'
}
package{'zsh':
 ensure=>'present'
}
package{'virtualbox':
 ensure => 'present'
}
package{'keepassx':
 ensure => 'present'
}

remote-package{'google-talkplugin':
	url=>"https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb",
	creates=>'/opt/google/talkplugin/'
}

remote-package{'vagrant':
	url=>"http://files.vagrantup.com/packages/b12c7e8814171c1295ef82416ffe51e8a168a244/vagrant_1.3.1_x86_64.deb",
	creates=>'/usr/bin/vagrant'
}

remote-package{'google-chrome-stable':
	url=>"https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb",
	creates=>'/usr/bin/google-chrome'
}

####### Development Folders

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

####### Git Config

exec{'git-user':
 command=>"/bin/su --command='git config --global user.name \"$fullname\"' $username",
 require=> Package['git-core'],
}
exec{'git-email':
 command=>"/bin/su --command='git config --global user.email \"$email\"' $username",
 require=> Package['git-core'],
}
exec{'git-push-style':
 command=>"/bin/su --command='git config --global push.default simple' $username",
 require=> Package['git-core'],
}

###### Sublime Text

apt-update-single{'sublime':
	source=>'deb http://ppa.launchpad.net/webupd8team/sublime-text-2/ubuntu raring main'
}

package{'sublime-text':
 ensure => 'present',
 require => Apt-update-single['sublime']
}

###### Vagrant Setup

exec{'add-ubuntu-vagrant-box':
 command=>"/bin/su --command='/usr/bin/vagrant box add precise64 http://files.vagrantup.com/precise64.box' $username",
 require=>Remote-package['vagrant'],
 creates=>"/home/$username/.vagrant.d/boxes/precise64"
}
exec{'add-vagrant-plugin-list':
 command=>"/bin/su --command='/usr/bin/vagrant plugin install vagrant-list' $username",
 require=>Remote-package['vagrant'],
 unless=>"/bin/cat /home/$username/.vagrant.d/plugins.json|grep vagrant-list 2>/dev/null"
}

###### Ssh Setup

exec{'create-ssh-key':
 command=>"/bin/su --command='ssh-keygen -f /home/$username/.ssh/id_rsa -N \"\"' $username",
 creates=>"/home/$username/.ssh/id_rsa"
}

file{"/home/$username/.ssh/id_rsa":
 require=>Exec['create-ssh-key'],
 mode=>"0600"
}


###### Spotify

exec{'add-spotify-key':
 command=>'/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59',
 unless=>'/usr/bin/strings /etc/apt/trusted.gpg|grep spotify 2>/dev/null'
}

apt-update-single{'spotify':
	source=>'deb http://repository.spotify.com stable non-free',
	require=>Exec['add-spotify-key']
}

package{'spotify-client':
 ensure=>'present',
 require=>Apt-update-single['spotify']
}

###### Oh My ZSH
exec{'oh-my':
 command=> "/bin/su -l --command=\"curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh\" $username",
 require=>[Package['zsh'],Package['curl']],
 creates=>"/home/$username/.oh-my-zsh"
}

user { "$username":
  ensure => present,
  shell  => "/bin/zsh",
}

##### Remove the dots drawn on login
# TODO doesn't seem to work
exec{'remove-lightdm-dots':
 command=>'/bin/su -s /bin/bash --command="gsettings set com.canonical.unity-greeter draw-grid false" lightdm'
}