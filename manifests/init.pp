package{'vim':
 ensure => 'latest'
}
package{'git-core':
 ensure => 'latest'
}
exec{'git-user':
 command=>'/bin/su --command="git config --global user.name \"Stephen Solka\"" trashhalo',
 require=> Package['git-core'],
}
exec{'git-email':
 command=>'/bin/su --command="git config --global user.email \"stephen@mindjunk.org\"" trashhalo',
 require=> Package['git-core'],
}
