## 1. 关于ping模块

master节点对workers节点执行ping操作，

```shell
$ ansible all -m ping
```



## 2. 关于setup模块

master节点获取workers节点的所有主机信息，

```shell
$ ansible all -m setup
```

master节点获取workers节点的过滤后的内存信息，

```shell
$ ansible all -m setup -a 'filter=ansible_memory_mb'
```




## 3. 关于file模块

创建一个文件位于/home/t716/joe下，如下，

```shell
$ ansible all -m file -a "path=/home/t716/joe/ansfile state=touch"
```

创建一个目录位于/home/t716/joe下，如下，

```shell
$ ansible all -m file -a "path=/home/t716/joe/ansdir state=directory"
```

删除目录/home/t716/joe下的一个文件，如下，

```shell
$ ansible all -m file -a "path=/home/t716/joe/ansfile state=absent"
```

删除目录/home/t716/joe下的一个目录，如下，

```shell
$ ansible all -m file -a "path=/home/t716/joe/ansdir state=absent"
```


## 4. 关于copy模块

拷贝一个文件到其他机器上去，

```shell
$ ansible all -m copy -a "src=/home/t716/joe/testfile dest=/home/t716/joe mode=0644"
```

拷贝一个目录到其他机器上去，

```shell
$ ansible all -m copy -a "src=/home/t716/joe/copydir dest=/home/t716/joe mode=0775"
```

或者读写无执行权限如下，

```shell
$ ansible all -m copy -a "src=/home/t716/joe/copydir dest=/home/t716/joe mode=0644"
```


## 5. 关于service模块

关闭集群的nginx服务

```shell
$ ansible all -m service -a "name=nginx state=stopped"
```

启动集群的nginx服务

```shell
$ ansible all -m service -a "name=nginx state=started"
```

10秒后重启集群的nginx服务

```shell
$ ansible all -m service -a "name=nginx state=restarted sleep 10"
```

重启eth0网卡

```shell
$ ansible all -m service -a "name=network state=restarted args=eth0"
```



## 6. 关于cron模块

创建一个任务，每次重启的时候执行一次

```shell
$ ansible all -m cron -a "name='running a job when reboot' special_time=reboot job=/opt/aaa.sh"
```


## 7. 关于yum模块

安装nginx软件包

```shell
$ ansible all -m yum -a "name=nginx state=latest"
```


## 8. 关于get_url模块

