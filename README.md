
### Introduction

- This project consist of 3 docker images:
    - `node`: service that generates cpu/io/memory/network loading and extracts metrics via HTTP
    - `prometheus`:   monitoring service that scrapes `node` service and saves results as time series
    - `alertmanager`:  manages and sends alerts when one of measured values meets some condition (per rules)

### Pre-requisites
- To run this project you should have following software installed on your computer

    - [Ansible](https://www.ansible.com/)
    - [Vagrant](https://www.vagrantup.com/)
    - [docker engine](https://www.docker.com/) [Optional, for local testing]
    - [docker-compose](https://docs.docker.com/compose/) [Optional, for local testing]

### Running on your machine(mac/linux):

- Clone this repo:
   
```bash
git clone git@github.com:nikoren/prom.git
cd prom
```

- Export variables to be able to send alerts with GMAIL account

```bash
export GMAIL_TO='some_destination_address@gmail.com'
export GMAIL_PASS='your_password' # Nice article if you need help to generate one: https://www.lifewire.com/get-a-password-to-access-gmail-by-pop-imap-2-1171882                      
export GMAIL_ACCOUNT='your_gmail_account_username@gmail.com'

```

- Generate local alertmanager config

```bash
cd alertmanager
ansible  'localhost,' -m template -a "src=alertmanager.yml.j2 dest=./alertmanager.yml" -e alertmanager_auth_username=$GMAIL_ACCOUNT -e "alertmanager_auth_pass='$(echo $GMAIL_PASS)'" -ealertmanager_to=${GMAIL_TO}
cd -

```

- Build the images

```bash
docker-compose build
```

- Start containers

```bash
docker-compose up
```

### Deployment

- Basically deployment is automated with ansible and vagrant
- just make sure the same environment variables for GMAIL access  are exported in your enviroment, 
- Vagrantfile is configured to pick those variables and present them to ansible-playbook as  extra variables

```bash
git clone git@github.com:nikoren/prom.git
cd prom
export GMAIL_TO=take-home-test@league.pagerduty.com 
export GMAIL_PASS='your_password' # Nice article if you need help to generate one: https://www.lifewire.com/get-a-password-to-access-gmail-by-pop-imap-2-1171882                      
export GMAIL_ACCOUNT='your_gmail_account_username@gmail.com'
vagrant up 
# Zzz...you done
```

### Ports 

- Vagrant configured to redirect ports to your local environment, just be sure you 
  are not running local and vagrant at the same time to avoid port collisions anc confusion
    - node: 9100
    - prometheus: 9090
    - alertmanager: 9093

### Metrics

- In order to access the metrics Prometheus provides `promQL` language , 
- following metrics are availble and can be viewed [here](http://localhost:9090/graph)

- [CPU](http://localhost:9090/graph?g0.range_input=1h&g0.expr=100%20-%20(avg%20by%20(instance)%20(irate(node_cpu_seconds_total%7Bjob%3D%22node%22%2Cmode%3D%22idle%22%7D%5B3m%5D))%20*%20100)&g0.tab=0)

```
# HELP node_cpu Seconds the cpus spent in each mode.
# TYPE node_cpu counter
100 - (avg by (instance) (irate(node_cpu_seconds_total{job="node",mode="idle"}[3m])) * 100)
```

- [Network](http://localhost:9090/graph?g0.range_input=1h&g0.expr=rate(node_network_transmit_bytes_total%7Bdevice%3D%22eth0%22%7D%5B1m%5D)&g0.tab=0)

```
# HELP node_network_transmit_bytes Network device statistic transmit_bytes.
# TYPE node_network_transmit_bytes gauge
rate(node_network_transmit_bytes_total{device="eth0"}[1m])
```

- [IO](http://localhost:9090/graph?g0.range_input=1h&g0.expr=irate(node_disk_io_time_seconds_total%7Bdevice%3D%22sda%22%7D%5B10s%5D)&g0.tab=0)

```
# HELP node_disk_io_time_seconds_total Total seconds spent doing I/Os.
# TYPE node_disk_io_time_seconds_total counter
irate(node_disk_io_time_seconds_total{device="sda"}[10s])
```


### Alerts
- Prometheus provides alerting mechanism with `alertmanager`
- Load alert is configured to send alert when `node` has load is higher than 5 for  1m
- More rules can be configured [here](https://github.com/nikoren/prom/blob/master/prometheus/alert.rules.yml)