## 1. 手动下载安装Golang

#### 1.1. 手动安装Golang

下载文件到本地
```shell
$ cd /home/t716/joe
$ wget https://dl.google.com/go/go1.9.7.linux-amd64.tar.gz
```

解压文件到本地
```shell
$ tar -xzf go1.9.7.linux-amd64.tar.gz
```

移动文件到指定目录
```shell
$ sudo mv go /usr/local
```

配置系统的环境变量
```shell
$ sudo vi ~/.bashrc
```

添加下面一行
```shell
export PATH=$PATH:/usr/local/go/bin
```

配置立即生效
```shell
$ source ~/.bashrc
```

#### 1.2. 手动配置工作路径

创建Golang的工作路径，作为go get等命令的默认工作路径，如下，
```shell
$ cd $HOME/joe
$ mkdir go
$ cd go
$ mkdir bin
```

配置工作路径，如下，
```shell
$ sudo vi ~/.bashrc
```

末尾追加下面两行
```shell
export GOPATH=$HOME/joe/go
export PATH=$PATH:$HOME/joe/go/bin
```

配置立即生效
```shell
$ source ~/.bashrc
```


## 2. Ansible下载安装Golang[test]

#### 2.1. Ansible安装Golang[test]

下载文件到指定目录[test]
```shell
$ ansible test -m get_url -a "url=https://dl.google.com/go/go1.9.7.linux-amd64.tar.gz dest=/home/t716/joe mode=0440 force=yes"
```

解压文件到指定目录[test]
```shell
$ ansible test -m unarchive -a "src=/home/t716/joe/go1.9.7.linux-amd64.tar.gz dest=/home/t716/joe mode=0755 copy=no"
```

移动文件到指定目录[test]

```shell
$ ansible test -m shell -a "echo [T716rrs722] | sudo mv /home/t716/joe/go /usr/local"
```

创建工作路径[test]

```shell
$ ansible test -m shell -a "mkdir /home/t716/joe"
$ ansible test -m shell -a "mkdir /home/t716/joe/go"
$ ansible test -m shell -a "mkdir /home/t716/joe/go/bin"
```

写入配置信息[test]
```shell
$ ansible test -m shell -a "echo '' >>~/.bashrc"
$ ansible test -m shell -a "echo '# -----------------------------------------------------------' >>~/.bashrc"
$ ansible test -m shell -a "echo '# Hyperledger Cluster Configuration - chwang@comp.hkbu.edu.hk' >>~/.bashrc"
$ ansible test -m shell -a "echo '# -----------------------------------------------------------' >>~/.bashrc"

$ ansible test -m shell -a "echo 'export PATH=\$PATH:/usr/local/go/bin' >>~/.bashrc"
$ ansible test -m shell -a "echo 'export GOPATH=\$HOME/joe/go' >>~/.bashrc"
$ ansible test -m shell -a "echo 'export PATH=\$PATH:$HOME/joe/go/bin' >>~/.bashrc"
```


配置立即生效[手动]
```shell
$ source ~/.bashrc
```

查看golang的版本信息，go_install.yaml文件如下[手动]，

```shell
$ ansible test -m shell -a "/usr/local/go/bin/go version"
```



## 3. Ansible下载安装Golang[peer]

#### 3.1. Ansible安装Golang[peer]

创建工作路径[peer]

```shell
$ ansible peer -m shell -a "rm -rf /home/t716/Joe"
$ ansible peer -m shell -a "mkdir /home/t716/joe"
$ ansible peer -m shell -a "mkdir /home/t716/joe/go"
$ ansible peer -m shell -a "mkdir /home/t716/joe/go/bin"
```


下载文件到指定目录[peer]
```shell
$ ansible peer -m get_url -a "url=https://dl.google.com/go/go1.9.7.linux-amd64.tar.gz dest=/home/t716/joe mode=0440 force=yes"
```

解压文件到指定目录[peer]
```shell
$ ansible peer -m unarchive -a "src=/home/t716/go1.9.7.linux-amd64.tar.gz dest=/home/t716 mode=0755 copy=no"
```

移动文件到指定目录[peer]

```shell
$ ansible peer -m shell -a "echo [T716rrs722] | sudo mv /home/t716/go /usr/local"
```

写入配置信息[peer]
```shell
$ ansible peer -m shell -a "echo '' >>~/.bashrc"
$ ansible peer -m shell -a "echo '# -----------------------------------------------------------' >>~/.bashrc"
$ ansible peer -m shell -a "echo '# Hyperledger Cluster Configuration - chwang@comp.hkbu.edu.hk' >>~/.bashrc"
$ ansible peer -m shell -a "echo '# -----------------------------------------------------------' >>~/.bashrc"

$ ansible peer -m shell -a "echo 'export PATH=\$PATH:/usr/local/go/bin' >>~/.bashrc"
$ ansible peer -m shell -a "echo 'export GOPATH=\$HOME/joe/go' >>~/.bashrc"
$ ansible peer -m shell -a "echo 'export PATH=\$PATH:$HOME/joe/go/bin' >>~/.bashrc"
```


配置立即生效[手动]
```shell
$ source ~/.bashrc
```

查看golang的版本信息，go_install.yaml文件如下[手动]，

```shell
$ ansible test -m shell -a "/usr/local/go/bin/go version"
```



## 4. Ansible下载升级Golang[peer]

#### 4.1. Ansible升级Golang[peer]

删除旧版的golang
```shell
$ ansible peer -m shell -a "echo [T716rrs722] | sudo rm -rf /usr/local/go"
$ ansible peer -m shell -a "echo [T716rrs722] | sudo rm -rf /home/t716/go"
```



下载文件到指定目录[peer]
```shell
$ ansible peer -m get_url -a "url=https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz dest=/home/t716 mode=0440 force=yes"
```

解压文件到指定目录[peer]
```shell
$ ansible peer -m unarchive -a "src=/home/t716/go1.12.9.linux-amd64.tar.gz dest=/home/t716 mode=0755 copy=no"
```

移动文件到指定目录[peer]

```shell
$ ansible peer -m shell -a "echo [T716rrs722] | sudo mv /home/t716/go /usr/local"
```

写入配置信息[peer]
```shell
$ ansible peer -m shell -a "echo '' >>~/.bashrc"
$ ansible peer -m shell -a "echo '# -----------------------------------------------------------' >>~/.bashrc"
$ ansible peer -m shell -a "echo '# Hyperledger Cluster Configuration - chwang@comp.hkbu.edu.hk' >>~/.bashrc"
$ ansible peer -m shell -a "echo '# -----------------------------------------------------------' >>~/.bashrc"

$ ansible peer -m shell -a "echo 'export PATH=\$PATH:/usr/local/go/bin' >>~/.bashrc"
$ ansible peer -m shell -a "echo 'export GOPATH=\$HOME/joe/go' >>~/.bashrc"
$ ansible peer -m shell -a "echo 'export PATH=\$PATH:$HOME/joe/go/bin' >>~/.bashrc"
```


配置立即生效[手动]
```shell
$ source ~/.bashrc
```

查看golang的版本信息，go_install.yaml文件如下[手动]，

```shell
$ ansible test -m shell -a "/usr/local/go/bin/go version"
```
