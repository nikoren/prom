
### Prometheus queries

- Memory

```go
# HELP process_virtual_memory_bytes Virtual memory size in bytes.
# TYPE process_virtual_memory_bytes gauge
100*(avg by (mode)(irate(node_cpu{job="node"}[5m])))
```

- CPU

```
# HELP node_cpu Seconds the cpus spent in each mode.
# TYPE node_cpu counter
100*(avg by (mode)(irate(node_cpu{job="node"}[5m])))

100 - (avg by (instance) (irate(node_cpu{job="node",mode="idle"}[2m])) * 100)
```

- Network

```
# HELP node_network_transmit_bytes Network device statistic transmit_bytes.
# TYPE node_network_transmit_bytes gauge
rate(node_network_transmit_bytes{device="eth0"}[1m])
```

- IO

```
# HELP node_disk_io_now The number of I/Os currently in progress.
# TYPE node_disk_io_now gauge
node_disk_io_now{device="sda"}

# HELP node_disk_io_time_ms Total Milliseconds spent doing I/Os.
# TYPE node_disk_io_time_ms counter
irate(node_disk_io_time_ms{device="sda"}[1m])
```

- Gmail authentication

- in order to be able to send emails GMAIL_ACCOUNT AND and GMAIL_PASSWORD should
  be set as environment vars , the result is ignored by git so it won't accidently be saved
```bash

export GMAIL_ACCOUNT=${YOUR_ACCOUNT}
export GMAIL_PASS=${YOUR_PASS}
export GMAIL_TO='${SOMEONE}'
cd alertmanager
ansible  'localhost,' -m template -a "src=alertmanager.yml.j2 dest=./alertmanager.yml" -e alertmanager_auth_username=$GMAIL_ACCOUNT -e "alertmanager_auth_pass='$(echo $GMAIL_PASS)'" -ealertmanager_to=${GMAIL_TO}
cd -
```
