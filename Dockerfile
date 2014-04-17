FROM ubuntu:quantal
MAINTAINER joshjdevl < joshjdevl [at] gmail {dot} com>

RUN apt-get update && apt-get -y install python-software-properties software-properties-common

RUN apt-get -y install wget
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN /usr/sbin/sshd
RUN echo "root:josh" | chpasswd

RUN apt-get install libboost1.48-all-dev
RUN apt-get install python-dev python-pygraphviz python-kiwi
RUN apt-get install python-pygoocanvas python-gnome2
RUN apt-get install python-gnomedesktop python-rsvg ipython

RUN mkdir /ndnSIM
RUN cd /ndnSIM && git clone git://github.com/cawka/ns-3-dev-ndnSIM.git ns-3
RUN cd /ndnSIM && git clone git://github.com/cawka/pybindgen.git pybindgen
RUN cd /ndnSIM && git clone git://github.com/NDN-Routing/ndnSIM.git ns-3/src/ndnSIM

RUN cd /ndnSIM/ns-3 && ./waf configure --enable-examples && ./waf
RUN cd /ndnSIM/ns-3 && ./waf --run=ndn-simple && ./waf --run=ndn-grid
RUN cd /ndnSIM/ns-3 && ./waf --run=ndn-simple --vis && ./waf --run=ndn-grid --vis