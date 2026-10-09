FROM fedora:44

# Install required system dependencies
RUN dnf update -y && \
    dnf install -y \
        python3 \
        python3-pip \
        git \
        curl \
        ca-certificates && \
    dnf clean all

# Set the working directory
WORKDIR /app

# Install Hermes Agent via PyPI
RUN pip install --no-cache-dir hermes-agent

# Run the messaging gateway in the foreground as the container process.
CMD ["hermes", "gateway", "run"]
