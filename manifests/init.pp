include stdlib

class jdk(
	$java = $jdk::params::java
	) inherits jdk::params {

  $merged_java = merge($jdk::params::java, $java)

  anchor { 'jdk::begin:': }
  ->
  file { ['/usr/lib/jvm/',
  		 $merged_java['extract']]:
    ensure => directory,
  }
  ->
  file { "/usr/lib/jvm/${merged_java['file_name']}":
    ensure  => present,
    source  => $merged_java['tarball'],
  }
  ->
  exec { 'unpack-java':
    command     => "tar -xzf /usr/lib/jvm/${merged_java['file_name']} -C /usr/lib/jvm",
    path        => '/bin',
    creates     => "${merged_java['extract']}/bin",
  }
  ->
  file { '/usr/lib/jvm/jdk':
  	ensure => link,
  	target => $merged_java['extract'],
  }
  ->
  exec { 'update-alternatives':
    command     => "update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk/bin/java 1; update-alternatives --install /user/bin/javaws javaws /user/lib/jvm/jdk/bin/javaws 1; update-alternatives --set java /usr/lib/jvm/jdk/bin/java; update-alternatives --install /usr/bin/jps jps /usr/lib/jvm/jdk/bin/jps 1; touch /usr/local/java_alt_updated",
    cwd         => '/',
    path        => '/bin:/usr/bin',
    creates     => '/usr/local/java_alt_updated',
  }
  ->
  file { '/etc/profile.d/java.sh':
  	content => "export JAVA_HOME=/usr/lib/jvm/jdk/\nexport PATH=\$PATH:\$JAVA_HOME/bin/\n",
  }
  ->
  file_line { 'java_bashrc':
  	path => '/etc/bash.bashrc',
  	line => 'source /etc/profile.d/java.sh',
  }
  ->
  anchor { 'jdk::end:': }
}
