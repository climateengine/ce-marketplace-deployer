FROM ubuntu:20.04

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

ARG TERRAFORM_VERSION=1.0.3

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        curl \
        software-properties-common \
        python3 \
        unzip \
        wget \
    && rm -rf /var/lib/apt/lists/*


################################
# Install Terraform
################################

# Download terraform for linux
RUN wget --progress=dot:mega https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN \
	# Unzip
	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	# Move to local bin
	mv terraform /usr/local/bin/ && \
	# Make it executable
	chmod +x /usr/local/bin/terraform && \
	# Check that it's installed
	terraform --version


############################
# Install gcloud
############################

RUN curl -sSL https://sdk.cloud.google.com | bash


############################
# Install kubectl
############################
RUN gcloud components install kubectl

############################
# Copy entrypoint.sh
############################

CMD mkdir -p /ce-deployment
WORKDIR /ce-deployment
COPY ce-deployment/ .
COPY entrypoint.sh .

CMD entrypoint.sh