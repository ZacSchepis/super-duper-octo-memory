# Base image
FROM ubuntu:20.04

# Links to the repo for xv6 that we used for those projects...
# and a link to the diff for my lotto scheduler
ARG XV6_REPO_URL=https://github.com/mit-pdos/xv6-public.git
ARG SCHEPIS_LOTTO_SCHED_DIFF=https://raw.githubusercontent.com/ZacSchepis/super-duper-octo-memory/main/schepis_solution
# thing to name my diff file when it is downloaded
ARG DIFF_NAME=schepis_solution
ENV DEBIAN_FRONTEND=noninteractive

# Installing things needed for this
RUN apt-get update && \
        apt-get install -q -y \
        gdb \
        git \
        curl \
        gcc \
        libc6-dev \
        make \
        qemu-system-i386
# Clone the repo into a directory named src
# then download my diff into that repo named with the above name from
# a repo I made just to hold that diff
# then change to that directory just to patch that diff
RUN git clone $XV6_REPO_URL ./src && \
        curl -o ./src/$DIFF_NAME $SCHEPIS_LOTTO_SCHED_DIFF && \
        cd ./src && patch -i $DIFF_NAME

# change into that directory for the container...
WORKDIR ./src

# And then run my make command that I added to the Makefile before
# which will make qemu-nox and then immediately run schedtest
CMD ["make", "lazy"]
