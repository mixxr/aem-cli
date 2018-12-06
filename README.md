# AEM CLI
Adobe Experience Manager Administration CLI 

## Tested with
- AEM 6.4

## Usage
- populate the farm configuration file (e.g. file.txt) with your farm addresses and identifications
- execute the farm-exec shaell script
```bash
./farm-exec.sh file.txt <command> [<parameters>]
```
- read the output

## Examples
```bash
./farm-exec.sh file.txt purge audit
```
executes the maintenance audit task.

```bash
./farm-exec.sh file.txt users changepwd replication-receiver my-new-secret
```
changes the replication-receiver's password = my-new-secret.

## Farm Configuration File
```
NOTGOOD LINE 222
-- START
server1:4502 admin:admin
server2:4522 admin:admin
server3:4512 admin:pwd 
-- END
NOTGOOD LINE
```
The CLI executes only the lines between the `-- START` and `-- END`. During a command execution it could fail with one or more servers, so in place of writing a different file you can adjust the `-- START` and the `-- END` lines in order to complete the command.

## Report
The farm-exec executes and writes the output line by line as defined in the farm configuration file.
```
=======
AEM CLI
=======
reading farm configuration from file.txt
-->
server1:4502 admin:admin 200
server2:4522 admin:admin 200
server3:4512 admin:pwd 401
<--
```


## How To Contribute
You can add scripts in the cmds folder by using your own scripting language (bash, ruby, ...)

- write your own script 
  - has to accept at least 2 parameters, that is the host:port and usrid:pwd at least
  - can accept more parameters to use in the script
  - finally, print a string to be used as Report
- save your script in the folder cmds

### Example
```
#!/usr/bin/env bash
# usage: info.sh host:port user:pwd
curl -i -k -u $2 http://$1/system/console/status-productinfo.json 2>/dev/null | grep Manager
```

produces an output like the following:
```
=======
AEM CLI
=======
reading farm configuration from file.txt
-->
localhost:4502 admin:admin " Adobe Experience Manager (6.4.0)",
localhost:4522 admin:admin " Product : Adobe Experience Manager (6.0.0.SNAPSHOT)", " Adobe Experience Manager (6.2.0)",
<--
```
