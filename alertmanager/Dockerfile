#https://github.com/prometheus/alertmanager/releases/download/v0.15.0-rc.0/alertmanager-0.15.0-rc.0.linux-amd64.tar.gz
FROM centos:7
RUN useradd alertmanager
RUN yum install -y -q epel-release && yum update -y -q && yum install -y -q wget tar
RUN cd /tmp && wget -nv https://github.com/prometheus/alertmanager/releases/download/v0.15.0-rc.0/alertmanager-0.15.0-rc.0.linux-amd64.tar.gz
RUN tar xvf /tmp/alertmanager-0.15.0-rc.0.linux-amd64.tar.gz
RUN mv alertmanager-0.15.0-rc.0.linux-amd64/alertmanager /usr/local/bin/.
RUN mkdir -p /etc/alertmanager/data
RUN rm -rf  /tmp/alertmanager-0.15.0-rc.0.linux-amd64.tar.gz
ADD alertmanager.yml /etc/alertmanager/

RUN chown -R alertmanager:alertmanager /usr/local/bin/alertmanager  /etc/alertmanager
RUN chmod +x /usr/local/bin/alertmanager
USER alertmanager
ENTRYPOINT ["/usr/local/bin/alertmanager"]
CMD ["--config.file=/etc/alertmanager/alertmanager.yml", \
     "--storage.path=/etc/alertmanager/data"]

# docker build -t alertmanager:latest .
# docker run -it alertmanager:latest