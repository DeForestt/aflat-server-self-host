# Use the latest Ubuntu image
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    g++ \
    cmake \
    git \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone the Aflat repository
RUN git clone http://www.github.com/DeForestt/aflat.git

# Set up and build Aflat
WORKDIR /aflat
RUN mkdir build bin && make
RUN bash rebuild-libs.sh

# Prepare the project directory
RUN mkdir /project
WORKDIR /project

# Copy project files
COPY . .

# Expose port 8080 for the Aflat server
EXPOSE 8080

# Run aflat build
RUN /aflat/bin/aflat build

# Set the entry point to run the Aflat project
ENTRYPOINT ["./bin/a.out"]
