ZKS=3
KAFKAS=3


echo "------------------------------------------------------------"
echo "Build the zookeeper configuration files"
echo "------------------------------------------------------------"
for ((i=1;i<=$ZKS;i++))
do
    cp /home/t716/fabric-dbench/kafka_2.12-2.3.0/config/zookeeper.properties /home/t716/fabric-dbench/kafka_2.12-2.3.0/config/zookeeper-$i.properties
done


for ((i=1;i<=$ZKS;i++))
do
	echo "tickTime=2000">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/zookeeper-$i.properties
	echo "initLimit=5">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/zookeeper-$i.properties
	echo "syncLimit=2">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/zookeeper-$i.properties
done


for ((i=1;i<=$ZKS;i++))
do
	for ((j=1;j<=$ZKS;j++))
	do
		echo "server.$j=zookeeper$j:2666:3666">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/zookeeper-$i.properties
	done
done


echo "------------------------------------------------------------"
echo "Build directory of myid"
echo "------------------------------------------------------------"
ansible all -m shell -a "mkdir /tmp/zookeeper"
ansible all -m shell -a "touch /tmp/zookeeper/myid"
for ((i=1;i<=$KAFKAS;i++))
do
    echo "$i" | ssh t716@zookeeper$i "cat > /tmp/zookeeper/myid"
done


echo "------------------------------------------------------------"
echo "Build the kafka configuration files"
echo "------------------------------------------------------------"
for ((i=1;i<=$KAFKAS;i++))
do
    touch /home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
done


for ((i=1;i<=$KAFKAS;i++))
do
    echo "broker.id=$i">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "listeners=PLAINTEXT://broker$i:9092">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "num.network.threads=3">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "num.io.threads=8">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "socket.send.buffer.bytes=102400">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "socket.receive.buffer.bytes=102400">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "socket.request.max.bytes=104857600">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "log.dirs=/tmp/kafka-logs-$i">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "num.partitions=1">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "num.recovery.threads.per.data.dir=1">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "transaction.state.log.replication.factor=1">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "transaction.state.log.min.isr=1">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "log.retention.hours=168">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "log.segment.bytes=1073741824">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "log.retention.check.interval.ms=300000">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "log.retention.check.interval.ms=300000">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo -ne "zookeeper.connect=zookeeper1:2181">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties

    if (($KAFKAS > 1)); then
        for ((j=2;j<=$KAFKAS;j++))
        do
            echo -ne ",zookeeper$j:2181">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
        done
    fi

    echo "">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "zookeeper.connection.timeout.ms=6000">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "group.initial.rebalance.delay.ms=0">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    
    echo "########### kafka configuration for Hyperledger ###############">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "unclean.leader.election.enable = false">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "min.insync.replicas = 1">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "default.replication.factor = 1">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "message.max.bytes = 10000120">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "replica.fetch.max.bytes = 10485760">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
    echo "log.retention.ms = -1">>/home/t716/fabric-dbench/kafka_2.12-2.3.0/config/server-$i.properties
done
