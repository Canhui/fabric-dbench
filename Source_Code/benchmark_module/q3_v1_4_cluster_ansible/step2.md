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




