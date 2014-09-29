class jdk::params {
	$version = "8"
	$distribution = "oracle"

	case $::osfamily {
    	default: { fail("unsupported platform ${::osfamily}") }
	    'Debian': {
	      	
	      	case $::lsbdistcodename {
		        default: { fail("unsupported release ${::lsbdistcodename}") }
		        'wheezy', 'jessie', 'precise','quantal','raring','saucy', 'trusty': {
		          	
		          	case $version {
		          		default: { fail("unsupported jdk version ${::lsbdistcodename}") }
		          		'8': { 
				          $java = {
				              'distribution' => $distribution,
				              'version' => $version,
				              'file_name' => 'jdk-8u20-linux-x64.gz',
				              'tarball' => 'puppet:///modules/jdk/oracle/jdk8/jdk-8u20-linux-x64.gz',
				              'extract' => '/usr/lib/jvm/jdk1.8.0_20/',
				            }
				      	}
		      		}

		        }
		    }

		}
    }
}