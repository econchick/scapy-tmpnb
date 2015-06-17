FROM ubuntu:14.04
MAINTAINER Lynn Root <lynn@lynnroot.com>

RUN apt-get update && apt-get upgrade -y && apt-get install python-pip python python-dev libcurl4-openssl-dev -y
RUN pip install --upgrade pip

RUN apt-get install nmap tcpdump graphviz imagemagick python-crypto libpcap0.8-dev libdnet -y
RUN pip install ipython pyzmq jinja2 tornado mistune jsonschema pygments terminado functools32 scapy python-nmap pypcap pygeoip geojson

RUN mkdir -p /tutorial/data
WORKDIR /tutorial/
ADD data/ data/

EXPOSE 8888
EXPOSE 80
EXPOSE 20
EXPOSE 53
EXPOSE 22
EXPOSE 443
