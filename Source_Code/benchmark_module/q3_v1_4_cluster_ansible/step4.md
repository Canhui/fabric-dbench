## 1. 手动安装nodejs

```shell
$ curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
```

```shell
$ sudo bash nodesource_setup.sh
```

```shell
$ sudo apt-get install nodejs
```

```shell
$ sudo npm install npm@6.9.0 -g
```


```shell
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
```



## Ansible下载fabric-samples

```shell
$ ansible all -m shell -a " cd /home/t716/joe && curl -sSL http://bit.ly/2ysbOFE | bash -s -- 1.4.0"
```