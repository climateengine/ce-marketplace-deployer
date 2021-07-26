FROM gcr.io/cloud-marketplace/google/ubuntu1804:latest

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
        apt-transport-https \
        ca-certificates \
        gnupg \
    && rm -rf /var/lib/apt/lists/*


################################
# Install Terraform
################################

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update -y && \
    apt-get install terraform -y && \
    terraform --version


############################
# Install gcloud
############################

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && \
    apt-get install google-cloud-sdk -y && \
    gcloud --version


############################
# Install kubectl
############################
RUN apt-get install kubectl -y && \
    kubectl version --client

############################
# Copy entrypoint.sh
############################

CMD mkdir -p /ce-deployment
WORKDIR /ce-deployment
COPY ce-deployment/ .
COPY entrypoint.sh .

CMD entrypoint.sh