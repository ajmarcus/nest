Nest
======

A demo of hive's capabilities.

### Configuration ###

Put the following variables in your kettle.properties file:
LAPPY_AWS_PUB_KEY=$PUBLIC KEY
LAPPY_AWS_PRV_KEY=$PRIVATE KEY


Download 

### Sample EMR cli commands ###

1. List active jobflows
```bash
./elastic-mapreduce --list --active
```

2. SSH to master node of jobflow
```bash
./elastic-mapreduce --ssh $JOBFLOW_ID
```

3. SSH to master node and forward JobTracker port
```bash
ssh -i /path/to/keyfile.pem -L 9100:localhost:9100 -l hadoop $HOSTNAME
```

3. Add spot instances to running jobflow
```bash
./elastic-mapreduce -j [JOBFLOW_ID] \
    --add-instance-group task \
    --instance-type m1.xlarge \
    --instance-count 3 \
    --bid-price 0.60
```

For a handy utility with the EMR cli see Chris Wensel's [bash-emr](https://github.com/cwensel/bash-emr).

### Issues ###

1. PDI uses [old version](http://jira.pentaho.com/browse/PDI-9163) of Hive from 2011

2. PDI does not [fail](http://jira.pentaho.com/browse/PDI-9162) gracefully when JobFlow fails
