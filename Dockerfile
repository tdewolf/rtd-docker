FROM dregistry.amplidata.com:5000/jenkins-slave-documentation
MAINTAINER Koen De Keyser

RUN apt-get update -q && apt-get install -y \
  vim-gnome \
  gcc \
  curl \
  graphviz \
  locales \
  git \
  git-doc \
  git-man \
  tig \
  bash-completion \
  evince \
  tree \
  lsof \
  quilt \
  rpl \
  python-pip \
  meld \
  firefox \
  man-db \
  scons \
  automake \
  libssl-dev \
  && apt-get clean

RUN pip install vim_bridge


RUN git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ADD vimrc_base /root/.vimrc

RUN vim +PluginInstall +qall

RUN apt-get update -q && apt-get install -y \
  python-setuptools \
  build-essential \
  python-dev \
  libevent-dev

RUN pip install sphinx


RUN apt-get update -q && apt-get install -y \
  libxml2-dev \
  libxslt1-dev \
  openjdk-7-jre

RUN apt-get install -y \
  redis-server

ADD https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.6.0.deb /root/

RUN apt-get install -y \
  dpkg

RUN dpkg -i /root/elasticsearch-1.6.0.deb
RUN /usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-analysis-icu/2.5.0

RUN mkdir -p /root/.ssh

ADD id_rsa_jenkins /root/.ssh/id_rsa
ADD id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 700 /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa.pub
RUN echo "IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config
RUN echo "Host gitlab.amplidata.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

RUN mkdir /root/checkouts && cd /root/checkouts && git clone -b elasticsearch_default_4 git@gitlab.amplidata.com:dekeysek/readthedocs.org.git

RUN cd /root/checkouts/readthedocs.org && pip install -r requirements.txt

ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

ADD install_rtd.sh /root/checkouts/readthedocs.org/
ADD elasticsearch_setup.py /root/checkouts/readthedocs.org/

RUN service elasticsearch start && service redis-server start && cd /root/checkouts/readthedocs.org && ./install_rtd.sh

ADD start_servers.sh /root/checkouts/readthedocs.org/

ADD http://files.amplidata.com/dss/containers/plantuml.jar /opt/plantuml/plantuml.jar
ADD http://files.amplidata.com/dss/containers/sdedit-4.01.jar /opt/sdedit/sdedit-4.01.jar

ADD verification_sent.html /usr/local/lib/python2.7/dist-packages/allauth/templates/account/verification_sent.html
ADD email_confirmation_sent.txt /usr/local/lib/python2.7/dist-packages/allauth/templates/account/messages/email_confirmation_sent.txt
