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

# Install Hermes Agent via PyPI
RUN pip install --no-cache-dir 'hermes-agent[web]'

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
