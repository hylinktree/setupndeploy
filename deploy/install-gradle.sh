# install OpenJDK11U-jdk_x64_linux_openj9_11.0.11_9_openj9-0.26.0.tar.gz 
VERSION=6.5.1
wget https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip -P /tmp
unzip -d /opt/gradle /tmp/gradle-${VERSION}-bin.zip
ln -s /opt/gradle/gradle-${VERSION} /opt/gradle/latest
# /etc/profile.d/gradle.sh
# export GRADLE_HOME=/opt/gradle/latest
# export PATH=${GRADLE_HOME}/bin:${PATH}
