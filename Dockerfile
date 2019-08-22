FROM ubuntu

RUN apt-get update \
  && apt-get -y --no-install-suggests --no-install-recommends install \
     ca-certificates \
     curl \
     gcc \
     g++ \
     git \
     libffi-dev \
     libpq-dev \
     libsnappy-dev \
     libssl-dev \
     make \
     python3 \
     python3-setuptools \
     python3-dev \
     vim \
     rsync \
     s3fs \
     htop \
  && curl -sSL https://bootstrap.pypa.io/get-pip.py | python3

RUN  pip3 install awscli \
  && pip3 install --upgrade pip setuptools 

#   git+https://github.com/aiven/pghoard.git@${PGHOARD_VERSION} \
RUN apt-get -y remove gcc python2.7 
RUN apt-get -y autoremove 
RUN apt-get clean 

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/bin/bash", "-c", "./docker-entrypoint.sh"]
