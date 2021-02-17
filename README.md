# Overview

This is based on the work of [@rhodesman](https://github.com/rhodesman) and his [teslaPowerDash](https://github.com/rhodesman/teslaPowerDash) repo, but hopefully enables easier ramp up to start obtaining and trending Powerwall 2 API data.

# Preview

<a href="https://i.imgur.com/GtP725k.png" ><img src="https://i.imgur.com/GtP725k.png" alt="Grafana Dashboard Preview" width="50%"/></a>

# Usage

If you're still using docker rather than podman, simply replace all `podman` calls with `docker`.

- Pull the container image:

```
podman pull liveaverage/powerwall-dashboard
```


- Start the container, replacing `POWERWALL_IP` with the assigned IP address of your Powerwall and `LOCAL_INFLUXDB_PATH` with an appropriate destination to store trend data.  Due to recent API changes authentication is required update `TSLAPASS` and `TSLAUSER` with the email and password you would login locally to the powerwall ip with:

```
export POWERWALL_IP=192.168.1.92
export LOCAL_INFLUXDB_PATH=/tmp/influxdata
export LOCAL_GRAFANA_PATH=/tmp/grafana
export GRAFANA_WEATHER_LOCATION="lat=36.2452052&lon=-80.7292593"
export TSLAPASS="pa$$word"
export TSLAUSER="yourmail@outlook.com"
export GRAFANA_DASHBOARD_URL="https://raw.githubusercontent.com/liveaverage/docker-powerwall-dashboard/master/graf_dash.json"

podman run --add-host teslapw:${POWERWALL_IP} -p 3000:3000 \
        -e "GRAFANA_DASHBOARD_URL=${GRAFANA_DASHBOARD_URL}" \
        -e "POWERWALL_LOCATION=${GRAFANA_WEATHER_LOCATION}" \
        -e "TSLAPASS=${TSLAPASS}" \
        -e "TSLAUSER=${TSLAUSER}" \
	-v ${LOCAL_INFLUXDB_PATH}:/var/lib/influxdb:z \
	-v ${LOCAL_GRAFANA_PATH}:/var/lib/grafana:z \
	liveaverage/powerwall-dashboard
 
```
- Or on Windows you may want to create a startup.cmd file like below and also update `POWERWALL_IP`, `LOCAL_INFLUXDB_PATH`, `TSLAPASS` and `TSLAUSER` as well as the `/host_mnt/c` paths. If port 3000 is in use on your Windows host you may need to remap to `3023`:

```
set POWERWALL_IP=192.168.1.92
set LOCAL_INFLUXDB_PATH=/host_mnt/c/Docker/powerwalldash/influxdata
set LOCAL_GRAFANA_PATH=/host_mnt/c/Docker/powerwalldash/grafana
set GRAFANA_WEATHER_LOCATION="lat=36.2452052^&lon=-80.7292593"
set TSLAUSER="yourmail@outlook.com"
set TSLAPASS="pa$$word"
set GRAFANA_DASHBOARD_URL="https://raw.githubusercontent.com/liveaverage/docker-powerwall-dashboard/master/graf_dash.json"

docker run --init --add-host teslapw:%POWERWALL_IP% -d -p 3023:3000 --name powerwalldash -e "GRAFANA_DASHBOARD_URL=%GRAFANA_DASHBOARD_URL%" -e "GRAFANA_WEATHER_LOCATION=%GRAFANA_WEATHER_LOCATION%" -e "POWERWALL_LOCATION=%GRAFANA_WEATHER_LOCATION%" -v %LOCAL_INFLUXDB_PATH%:/var/lib/influxdb -v %LOCAL_GRAFANA_PATH%:/var/lib/grafana -e "TSLAPASS=%TSLAPASS%" -e "TSLAUSER=%TSLAUSER%" --restart=unless-stopped liveaverage:latest
 
```
- Access the Grafana dashboard from your container host IP, which may require firewall exceptions for TCP3000: http://localhost:3000
  - Default credentials are "admin" for username/password
