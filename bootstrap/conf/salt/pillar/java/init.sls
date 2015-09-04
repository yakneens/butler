java_home: /usr/share/java
java:
  source_url: http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.tar.gz
  jce_url: http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip
  version_name: jdk1.8.0_51
  prefix: /usr/lib/jvm/

# java:version_name is the name of the top-level directory inside the tarball
# java:prefix is where the tarball is unpacked into - prefix/version_name being
#             the location of the jdk
# java:dl_opts - cli args to cURL
