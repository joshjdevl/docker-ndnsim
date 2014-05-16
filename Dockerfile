FROM ubuntu:precise
MAINTAINER joshjdevl < joshjdevl [at] gmail {dot} com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install python-software-properties software-properties-common

RUN apt-get -y install wget
RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN /usr/sbin/sshd
RUN echo "root:josh" | chpasswd

RUN apt-get -y install libboost1.48-all-dev
RUN apt-get -y install python-dev python-pygraphviz python-kiwi
RUN apt-get -y install fakeroot
RUN fakeroot apt-get -y install python-pygoocanvas python-gnome2
RUN apt-get -y install python-gnomedesktop python-rsvg ipython
RUN apt-get -y install git

RUN mkdir /ndnSIM
RUN cd /ndnSIM && git clone git://github.com/cawka/ns-3-dev-ndnSIM.git ns-3
RUN cd /ndnSIM && git clone git://github.com/cawka/pybindgen.git pybindgen
RUN cd /ndnSIM && git clone git://github.com/NDN-Routing/ndnSIM.git ns-3/src/ndnSIM

RUN cd /ndnSIM/ns-3 && ./waf configure --enable-examples && ./waf
RUN cd /ndnSIM/ns-3 && ./waf --run=ndn-simple && ./waf --run=ndn-grid
RUN cd /ndnSIM/ns-3 && ./waf --run=ndn-simple --vis && ./waf --run=ndn-grid --vis

RUN apt-get -y install vim
RUN cd /tmp && git clone https://github.com/joshjdevl/icn-cache-privacy
RUN cd /tmp/icn-cache-privacy/ && ./ndnsim.sh
#CMD /usr/sbin/sshd
