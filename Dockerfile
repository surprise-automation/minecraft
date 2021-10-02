FROM centos/systemd

ENV MC_MAX_RAM="1G"
ENV MC_MIN_RAM="1G"
ENV MCGID="1000"
ENV MCUID="1000"
ENV MC_SERVER_DL_URL="https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar"
ENV MC_JAVA_DL_URL="https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-x64_bin.tar.gz"
ENV MC_SPIGOT_DL_URL="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"

VOLUME /data/

EXPOSE 25565

RUN yum -y update
RUN yum -y install git wget
RUN yum clean all
RUN mkdir /jar/
RUN mkdir -p /usr/lib/jvm
RUN mkdir -p /tmp/java       && cd /tmp/java       && wget ${MC_JAVA_DL_URL}   && tar xvfs openjdk-16.0.2_linux-x64_bin.tar.gz   && rsync -av /tmp/java/jdk-16.0.2/ /usr/lib/jvm/jdk-16.0.2/
RUN PATH=$PATH:/usr/lib/jvm/jdk-16.0.2/bin
RUN JAVA_HOME="/usr/lib/jvm/jdk-16.0.2"
RUN echo "PATH=${PATH}" >> /etc/environment
RUN echo "JAVA_HOME=${JAVA_HOME}" >> /etc/environment
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-16.0.2/bin/java" 0
RUN update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-16.0.2/bin/javac" 0
RUN update-alternatives --set java /usr/lib/jvm/jdk-16.0.2/bin/java
RUN update-alternatives --set javac /usr/lib/jvm/jdk-16.0.2/bin/javac
RUN mkdir -p /tmp/BuildTools && cd /tmp/BuildTools && wget ${MC_SPIGOT_DL_URL} && java -jar BuildTools.jar --rev 1.17.1         && mv spigot-1.17.1.jar /jar/
RUN groupadd -g ${MCGID} mc
RUN adduser -s /bin/bash -u ${MCUID} -g ${MCGID} -d /home/mc mc
RUN chown -R mc:mc /data/

WORKDIR /data/
ENTRYPOINT java -Xms${MX_MIN_RAM} -Xmx${MC_MAX_RAM} -XX:+UseG1GC -jar /jar/spigot-1.17.1.jar nogui