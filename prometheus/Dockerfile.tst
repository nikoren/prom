FROM centos:7
RUN yum  install -y -q epel-release && yum update -y -q && yum install -y -q wget tar

RUN useradd prometheus
RUN mkdir -p /etc/prometheus/

RUN cd /tmp && wget -nv https://github.com/prometheus/prometheus/releases/download/v2.2.0/prometheus-2.2.0.linux-amd64.tar.gz
RUN cd /tmp && tar xvf /tmp/prometheus-2.2.0.linux-amd64.tar.gz && rm /tmp/prometheus-2.2.0.linux-amd64.tar.gz
RUN mv /tmp/prometheus-2.2.0.linux-amd64/prometheus /etc/prometheus/ # && # rm -rf /tmp/prometheus-2.2.0.linux-amd64

ADD prometheus.yml /etc/prometheus/
ADD alert.rules.yml /etc/prometheus/
RUN chmod +x /etc/prometheus/prometheus
RUN chown -R prometheus:prometheus /etc/prometheus
USER prometheus
#ENTRYPOINT ["/usr/local/bin/prometheus"]



