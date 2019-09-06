# SaltyZeek
SaltyZeek is a salt-state geared towards deploying Zeek on an instance.  
## Installation
Salt-Stack will need to be installed with the following `file_roots` and `pillar_roots` populated:
```bash
zeek:
  /location/of/zeek/folder
```
An example pillar sls for Zeek:
```bash
zeek:
  critical_stack_api_key: "1234"
  interface: "eth1"
  prom_port: "True"
```
## Usage
```bash
salt 'zeek-server' state.apply
```
Note: When building from source, this can take 15-30 minutes.
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
