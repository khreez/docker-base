FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

# Install base dependencies
RUN apt-get install -y software-properties-common
RUN apt-get install -y wget
RUN apt-get install -y vim
RUN apt-get install -y curl

# Installing Oracle java 8 and set it as default
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
# auto accept Oracle license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN apt-get install -y oracle-java8-set-default

# Installing maven 3.3.3
RUN wget --no-verbose -O /tmp/apache-maven-3.3.3.tar.gz http://archive.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
RUN tar xzf /tmp/apache-maven-3.3.3.tar.gz -C /opt/
RUN rm -f /tmp/apache-maven-3.3.3.tar.gz
RUN ln -s /opt/apache-maven-3.3.3 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
ENV MAVEN_HOME /opt/maven

# Installing Node.js v0.12
RUN curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
RUN sudo apt-get install -y nodejs

# Installing Postgresql 9.4
RUN groupadd -r postgres && useradd -r -g postgres postgres
ENV LANG en_US.utf8
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN apt-get install -y postgresql-common
RUN apt-get install -y postgresql-9.4
RUN apt-get install -y postgresql-contrib-9.4

# cleanup downloaded files
RUN apt-get clean
