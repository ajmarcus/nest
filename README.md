Nest
======

A demo of hive's capabilities.

###Sample EMR cli commands

1. List active jobflows
```sh
./elastic-mapreduce --list --active
```

2. SSH to master node of jobflow
```sh
./elastic-mapreduce --ssh [JOBFLOW_ID]
```

3. SSH to master node and forward JobTracker port
```sh
ssh -i /path/to/keyfile.pem -L 9100:localhost:9100 -l hadoop [HOSTNAME]
```

3. Add spot instances to running jobflow
```sh
./elastic-mapreduce -j [JOBFLOW_ID] \
    --add-instance-group task \
    --instance-type m1.xlarge \
    --instance-count 3 \
    --bid-price 0.60
```

For a handy utility with the EMR cli see Chris Wensel's [bash-emr|https://github.com/cwensel/bash-emr].