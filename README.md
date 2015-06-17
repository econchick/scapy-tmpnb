# IPython Notebook + Scapy tutorial

Me playing with notebook + scapy using docker with [tmpnb](https://github.com/jupyter/tmpnb).

## Setup:

### Docker image

Instead of the default `jupyter/demo` from [tmpnb](https://github.com/jupyter/tmpnb), I created a new Docker image which contains the following installed:
* IPython notebook (to be run with `sudo`, and its dependencies
* Scapy, and its dependencies
* nmap, and python-nmap
* Sample CAP/PCAP files

And I exposed port 8888 (the HTTP proxy port).

### AWS

1. Spin up an Amazon EC2 instance (t2.micro should be enough for ~20 people, but I went with t2.medium to be super-safe) with the following:
    1. Ubuntu 14.04
    2. within VPC
    3. public IP
    4. tcp ports 22, 80 (not sure if required?), and 8000 (or whatever port that tmpnb is listening on)
2. ssh into ubuntu machine, and:
    1. `sudo apt-get update -y`
    2. `wget -qO- https://get.docker.com/ | sh`  - install `wget` if needed
    3. `sudo usermod -a -G docker ubuntu`
    4. exit out of ssh, and ssh back in (for `usermod` to take effect)
    5. test that docker works with `docker info`
3. Setup docker images:
    1. `docker pull jupyter/tmpnb`
    2. `docker pull roguelynn/scapy-tmpnb`  - the docker image I made (described below)
    3. `export TOKEN=$( head -c 30 /dev/urandom | xxd -p )`
    4. `docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN --name=proxy jupyter/configurable-http-proxy --default-target http://127.0.0.1:9999`
4. Run tmpnb! (and yes, leave `{port}` and `{base_url}` as is, *with* brackets)
    5. `docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN -v /var/run/docker.sock:/docker.sock jupyter/tmpnb python orchestrate.py --image='roguelynn/scapy-tmpnb' --command="sudo ipython notebook --no-browser --NotebookApp.base_url={base_path} --ip=0.0.0.0 --port {port}" --pool_size=45 --cull_timeout=21600 --max_dock_workers=4`
5. On your AWS console, you should be able to find the public DNS of your amazon instance.  If none is given, then go back to the basic console, navigate to "VPC", then "Your VPCs". Check your VPC instance then click "Actions", then "Edit DNS hostnames" and select "Yes".  This should set up the Public DNS hostname, but you may need to restart your instance if it doesn't show up back in the instance console.
