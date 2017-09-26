FROM openjdk:alpine
MAINTAINER Jeremy T. Bouse <Jeremy.Bouse@UnderGrid.net>

USER root

ARG JENKINS_REMOTING_VERSION=3.5

COPY jenkins-slave /usr/local/bin/jenkins-slave

RUN addgroup -g 497 -S docker \
  && apk add --no-cache nodejs nodejs-npm docker maven python2 py2-pip jq curl sudo xvfb apache-ant \
  && pip install awscli --upgrade \
  && ln -sf /usr/bin/jq /usr/bin/jq-linux64 

RUN adduser jenkins -s /bin/sh -D \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar \
  && chmod +x /opt/bin/entry_point.sh \
  && chmod +x /opt/bin/functions.sh \
  && chmod +x /usr/local/bin/jenkins-slave \
  && chmod a+rwx /home/jenkins

WORKDIR /home/jenkins
USER jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
# EXPOSE 4444