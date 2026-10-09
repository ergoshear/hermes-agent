FROM fedora:44

# Install required system dependencies
RUN dnf update -y && \
    dnf install -y \
        python3 \
        python3-pip \
        nodejs \
        npm \
        git \
        curl \
        ca-certificates && \
    dnf clean all

# Set the working directory
WORKDIR /app

# Install the current Hermes source release with its complete supported extras.
RUN pip install --no-cache-dir \
    'hermes-agent[all] @ git+https://github.com/NousResearch/hermes-agent.git@v0.21.6'

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
