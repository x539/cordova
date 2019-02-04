FROM alpine:latest AS unzip
RUN apk add --no-cache curl
RUN curl --silent --output /tmp/sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN mkdir -p /opt/android-sdk/
RUN unzip /tmp/sdk.zip -d /opt/android-sdk/

FROM debian:stable-slim
LABEL maintainer="Andreas Freimuth <andreas.freimuth@united-bits.de>"

ARG DEBIAN_FRONTEND=noninteractive

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/android-sdk/tools/bin

RUN apt-get update && apt-get install --yes curl gnupg && apt-get clean
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN mkdir -p /usr/share/man/man1
RUN apt-get install --yes nodejs openjdk-8-jdk-headless gradle

RUN npm install -g cordova

COPY --from=unzip /opt/android-sdk /opt/android-sdk

RUN yes | sdkmanager --install platform-tools 'build-tools;28.0.2' 'extras;android;m2repository'

WORKDIR /app
