This repo contains a golang wrapper for nmap that performs the scan before sending results to the associated webserver. 
# Prerequisites
Instructions for downloading and installing golang for linux can be found on the golang website here: https://go.dev/doc/install.

Once go is installed, the next step is to build the webserver. 
1. Use  `git clone` to copy the repos into `/opt`
2. Chown directory ownership to a non-root user
3. The application can then be compiled using `go build`

```shell
cd /opt
https://github.com/MNCCDC-RedTeam/nmap-agent-go.git
sudo chown <user>:<user_group> -R nmap-agent-go/
cd nmap-agent-go
go build
```

At this point there should be an executable in the project folder. 

If nmap is not installed on your system, install it now.
# Nmap Scanner
The scanner here is nmap with a go wrapper which gets jobs from the server and submits results back to the server to be shown to the red team. The scanner uses a `.env` file to define some of the variables needed to execute. There are 3 required parameters and 1 optional parameter. The required parameters are:
- `API_USER` = The username created earlier in setup
- `API_PASS` = The password created earlier in setup
- `API_URL_BASE` = The URL that points to the webserver
The optional parameter is:
- `SCAN_TIMEOUT` = The time in minutes the scan is allowed to run before being killed by the go wrapper. The default value is 5 minutes.

When completed, `.env` should look like this:
```.env
API_USER=scanner
API_PASS=<redacted>
API_URL_BASE=https://<sub>.<domain>.<tld>
SCAN_TIMEOUT=15 
```

Once `.env` is created, then all that remains is to run it as root, as it uses nmap's SYN scan.
```shell
sudo ./nmap-wrapper-go
```

At this point, the executable will pull the next job down, execute it, then returning the results to the webserver before ending the process. With that in mind, during the competition it should probably be wrapped in a bash runner to keep it working without manual intervention. Once results are sent to the webserver, `/main.html` should update the results for the most recently completed job.

A secondary wrapper to ensure the scanner continues indefinitely. This is meant to be run in the same directory as the nmap agent. 
```bash
while true
do
	sudo ./nmap-agent-go
done
```
