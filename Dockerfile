# Start from the Debian 10.8 image
FROM debian:10.8

# Install basic packages and LaTeX components
RUN apt-get update && \
    apt-get install -y wget git curl build-essential libssl-dev texlive-full biber

# Install Node.js and NPM
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs

# Install fonts
RUN apt-get install -y fonts-lato fonts-roboto-slab

# Use an official TeXLive as a parent image
FROM texlive/texlive:latest

# Install required system dependencies
RUN apt-get update && apt-get install -y git fontforge lcdf-typetools nodejs npm

# Set the working directory in the container to /workspace
WORKDIR /workspace

# Clone the simple-icons-latex repository
RUN git clone https://github.com/ineshbose/simple-icons-latex.git

# Change to the simple-icons-latex directory
WORKDIR /workspace/simple-icons-latex

# Install package.json dependencies
RUN npm install

# Run the script bindings.js using Node.js
RUN node bindings.js

# Copy the necessary file to the LaTeX packages directory
RUN mkdir -p $(kpsewhich -var-value TEXMFHOME)/tex/latex/ && \
    cp simpleicons.sty $(kpsewhich -var-value TEXMFHOME)/tex/latex/

# Return to the /workspace directory
WORKDIR /workspace

# Copy the current directory contents into the container at /workspace
COPY ./レスメ /workspace
# Default command
CMD ["bash", "-c", "pdflatex sample.tex && rm -f sample.log"]