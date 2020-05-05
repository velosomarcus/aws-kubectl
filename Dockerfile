FROM python:alpine

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN apk --no-cache add curl
ADD run.sh /run.sh

# Install kubectl according the target platform
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/$(echo $TARGETPLATFORM | cut -d'/' -f2)/kubectl \
	&& mv kubectl /usr/local/bin \
	&& chmod +x /usr/local/bin/kubectl

RUN adduser -S user
USER user
WORKDIR /home/user
ENV PATH /usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/user/.local/bin

# Install awscli
RUN pip install awscli --upgrade --user
