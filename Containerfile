ENV NSPAWN_BOOTSTRAP_IMAGE_SIZE=10GB
FROM ubuntu:xenial

# set unlimited bash history
# nspawn needs resolv.conf to be set up for internet to work
# password gets changeed so we can login later
RUN echo "export HISTFILESIZE=" >> .bashrc && \
  echo "export HISTSIZE=" >> .bashrc && \
  rm -f /etc/resolv.conf && echo '8.8.8.8' > /etc/resolv.conf && \
  echo "root:root" | chpasswd
 
# install apt + npm dependencies
RUN apt-get install software-properties-common apt-transport-https curl -y && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
  add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/' && \
  apt-get update && \
  apt-get install r-base -y && \
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
  apt-get install -y nodejs && \
  npm i dat -g

# install hoffman software
RUN cd /root && \
  dat clone <KEY1> hoffman-deps && \
  tar xzvf hoffman-deps/fastx_toolkit.tar.gz && \
  echo "export PATH=/root/apps/fastx_toolkit/0.0.13.2/gcc-4.4.6/bin/:\$PATH" >> .bashrc && \
  tar xzvf hoffman-deps/libgtextutils.tar.gz && \
  echo "/root/apps/libgtextutils/0.6.1/gcc-4.4.6/lib/" > /etc/ld.so.conf.d/libgtextutils.conf && \
  ldconfig && \
  tar xzvf hoffman-deps/python-2.7.13.tar.gz && \
  echo "export PATH=/root/apps/python/2.7.13/bin:\$PATH" >> .bashrc && \
  tar xzvf hoffman-deps/bowtie2-2.2.9.tar.gz && \
  echo "export PATH=/root/apps/bowtie2/2.2.9:\$PATH" >> .bashrc

# download research data
RUN cd /root && dat clone <KEY2> Anacapa_db