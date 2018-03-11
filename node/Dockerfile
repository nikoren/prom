FROM centos:7
RUN yum  install -y -q epel-release && yum update -y -q && yum install -y -q stress wget tar


# Nodexporter
RUN useradd nodexporter
RUN cd /tmp && wget -nv "https://github.com/prometheus/node_exporter/releases/download/v0.16.0-rc.0/node_exporter-0.16.0-rc.0.linux-amd64.tar.gz"
RUN tar xvf /tmp/node_exporter-0.16.0-rc.0.linux-amd64.tar.gz
RUN mv /node_exporter-0.16.0-rc.0.linux-amd64/node_exporter /usr/local/bin/
RUN chmod +x /usr/local/bin/node_exporter
RUN chown -R nodexporter:nodexporter /usr/local/bin/node_exporter
RUN rm -rf /tmp/nodexporter-0.16.0-rc.0.linux-amd64.tar.gz /tmp/node_exporter-0.16.0-rc.0.linux-amd64

# load generator
ADD services_wrapper.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/services_wrapper.sh
RUN chown nodexporter:nodexporter /usr/local/bin/services_wrapper.sh

USER nodexporter
CMD ["--io", "10","--vm", "1", "--vm-bytes", "256M"]
ENTRYPOINT ["/usr/local/bin/services_wrapper.sh"]



# docker build -t monitored/app:latest .
# docker run -it monitored/app