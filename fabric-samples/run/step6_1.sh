echo "------------------------------------------------------------"
echo "Remove zookeeper cluster configuration file at the master node"
echo "------------------------------------------------------------"
ansible all -m shell -a "echo [T716rrs722] | sudo rm -rf /tmp/zookeeper"
ansible all -m shell -a "echo [T716rrs722] | sudo rm -rf /home/t716/joe/kafka_2.12-2.3.0/config/zookeeper-*.properties"


echo "------------------------------------------------------------"
echo "Remove kafka cluster configuration file at the master node"
echo "------------------------------------------------------------"
ansible all -m shell -a "echo [T716rrs722] | sudo rm -rf /tmp/kafka*"
ansible all -m shell -a "echo [T716rrs722] | sudo rm -rf /tmp/hsperfdata*"
ansible peer -m shell -a "echo [T716rrs722] | sudo rm -rf /home/t716/joe/kafka_2.12-2.3.0"
ansible all -m shell -a "echo [T716rrs722] | sudo rm -rf /home/t716/joe/kafka_2.12-2.3.0/config/server-*.properties"
