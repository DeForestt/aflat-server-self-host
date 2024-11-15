# Base stage to install Aflat as a dependency
FROM ubuntu:20.04 AS aflat-install

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.aflat/aflat/bin:${PATH}"

# Install necessary dependencies for building Aflat
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    cmake \
    build-essential \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone the Aflat repository into the container
RUN git clone https://github.com/DeForestt/aflat.git /root/.aflat/aflat

# Build Aflat from source
WORKDIR /root/.aflat/aflat
RUN mkdir -p bin && make

# Build any required libraries for Aflat
RUN bash rebuild-libs.sh

# Production stage to build and run a separate Aflat project
FROM ubuntu:20.04

# Install runtime dependencies for Aflat, like Boost if needed
RUN apt-get update && \
    apt-get install -y \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the Aflat installation from the build stage
COPY --from=aflat-install /root/.aflat /root/.aflat

# Set PATH for Aflat binary location
ENV PATH="/root/.aflat/aflat/bin:${PATH}"

# Set the working directory for the separate Aflat project
WORKDIR /app

# Copy the separate Aflat project files into the container
# (Alternatively, mount a volume for more flexibility at runtime)
COPY . /app

# Build the separate Aflat project using the pre-installed Aflat
RUN aflat build

# Expose port 8080 for the server
EXPOSE 8080

# Set the default command to run the compiled server binary directly
CMD ["./bin/a.out"]
