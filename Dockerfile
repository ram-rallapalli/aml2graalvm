FROM amazonlinux:2

RUN yum -y update \
    && yum install -y tar gzip bzip2-devel ed gcc gcc-c++ gcc-gfortran less libcurl-devel openssl openssl-devel readline-devel xz-devel zlib-devel \
    && yum install -y glibc-static libcxx libcxx-devel llvm-toolset-7 zlib-static \
    && rm -rf /var/cache/yum

# Configure GRAAL Version and File names for future updates
ENV GRAAL_VERSION 19.2.1
ENV GRAAL_FILENAME graalvm-ce-linux-amd64-${GRAAL_VERSION}.tar.gz

# Install and Configure Graal VM
RUN curl -4 -L https://github.com/oracle/graal/releases/download/vm-${GRAAL_VERSION}/${GRAAL_FILENAME} -o /tmp/${GRAAL_FILENAME}

RUN tar -zxvf /tmp/${GRAAL_FILENAME} -C /tmp

RUN mv /tmp/graalvm-ce-${GRAAL_VERSION} /usr/lib/graalvm

ENV JAVA_HOME /usr/lib/graalvm
ENV JRE_HOME /usr/lib/graalvm/jre

# Install and Configure Maven
ENV MAVEN_VERSION 3.6.2
ENV MAVEN_FILENAME apache-maven-${MAVEN_VERSION}-bin.tar.gz

RUN curl -4 -L https://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_FILENAME} -o /tmp/${MAVEN_FILENAME}

RUN tar -zxvf /tmp/${MAVEN_FILENAME} -C /tmp

RUN mv /tmp/apache-maven-${MAVEN_VERSION} /usr/lib/maven

RUN export PATH=$PATH:/usr/lib/graalvm/bin:/usr/lib/maven/bin

VOLUME /projects
WORKDIR /projects

RUN /usr/lib/graalvm/bin/gu install native-image

CMD [ "/bin/bash" ]