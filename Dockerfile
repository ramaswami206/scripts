FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y curl unzip \
    && curl -fsSL https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm -f terraform.zip \
    && apt-get clean
USER jenkins
