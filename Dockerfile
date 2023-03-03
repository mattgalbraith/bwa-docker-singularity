################# BASE IMAGE ######################
FROM --platform=linux/amd64 ubuntu:20.04 as build

################## INSTALLATION ######################
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGES tar wget ca-certificates zlib1g-dev build-essential

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and extract bwa
RUN wget https://github.com/lh3/bwa/archive/refs/tags/v0.7.17.tar.gz
RUN tar -xzvf v0.7.17.tar.gz
RUN cd bwa-0.7.17 && make


################# 2ND STAGE ######################
FROM --platform=linux/amd64 ubuntu:20.04

################## METADATA ######################
LABEL base_image="ubuntu:20.04"
LABEL version="1.0.0"
LABEL software="bwa"
LABEL software.version="0.7.17"
LABEL about.summary="BWA is a software package for mapping DNA sequences against a large reference genome, such as the human genome."
LABEL about.home="http://bio-bwa.sourceforge.net/"
LABEL about.documentation="https://bio-bwa.sourceforge.net/bwa.shtml"
LABEL about.license_file="https://github.com/lh3/bwa/blob/master/COPYING"
LABEL about.license="GPLv3"
LABEL extra.identifiers.biotools="bwa"
LABEL about.tags="Genomics"
LABEL extra.binaries="bwa"

################## MAINTAINER ######################
MAINTAINER Matthew Galbraith <matthew.galbraith@cuanschutz.edu>

################## INSTALLATION ######################
ENV DEBIAN_FRONTEND noninteractive

# Copy compiled bwa binary from build stage
COPY --from=build /bwa-0.7.17/bwa /usr/bin/


