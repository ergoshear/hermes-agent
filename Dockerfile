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

# Set environment variables to listen on all interfaces and port 80
ENV HOST=0.0.0.0
ENV PORT=80

# Expose HTTP port
EXPOSE 80

# Run Hermes Agent gateway listening on port 80
CMD ["hermes", "gateway", "run", "--host", "0.0.0.0", "--port", "80"]
