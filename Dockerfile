FROM ubuntu:precise
MAINTAINER joshjdevl < joshjdevl [at] gmail {dot} com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install python-software-properties software-properties-common

RUN add-apt-repository ppa:apt-fast/stable
RUN apt-get update
RUN apt-get -y install apt-fast

RUN apt-fast -y install wget
RUN apt-fast update
RUN apt-fast install -y openssh-server
RUN mkdir /var/run/sshd
RUN /usr/sbin/sshd
RUN echo "root:josh" | chpasswd

RUN apt-fast -y install libboost1.48-all-dev
RUN apt-fast -y install python-dev python-pygraphviz python-kiwi
RUN apt-fast -y install fakeroot
RUN fakeroot apt-get -y install python-pygoocanvas python-gnome2
RUN apt-fast -y install python-gnomedesktop python-rsvg ipython git vim python-dev python-pip

RUN mkdir /ndnSIM
RUN cd /ndnSIM && git clone git://github.com/cawka/ns-3-dev-ndnSIM.git ns-3
RUN cd /ndnSIM && git clone git://github.com/cawka/pybindgen.git pybindgen
RUN cd /ndnSIM && git clone git://github.com/NDN-Routing/ndnSIM.git ns-3/src/ndnSIM

RUN cd /ndnSIM/ns-3 && ./waf configure --enable-examples && ./waf
RUN cd /ndnSIM/ns-3 && ./waf --run=ndn-simple && ./waf --run=ndn-grid
RUN cd /ndnSIM/ns-3 && ./waf --run=ndn-simple --vis && ./waf --run=ndn-grid --vis

RUN cd /tmp && git clone https://github.com/joshjdevl/icn-cache-privacy
RUN cd /tmp/icn-cache-privacy/ && ./ndnsim.sh

RUN pip install jinja2
#CMD /usr/sbin/sshd

RUN apt-fast -y install gdb valgrind
RUN cd /tmp/icn-cache-privacy && git pull && ./ndnsim.sh && echo 'hi'
RUN cd /ndnSIM/ns-3 && ./run.sh
