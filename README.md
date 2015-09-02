
# 如何使用该镜像

php-apache是在Apache httpd服务里提供PHP解析的能力。

## 在项目下放一个Dockerfile
```console
from index.csphere.cn/microimages/php-apache
add . /app
```

上面的Dockerfile将项目代码下的所有php文件加到了 `/app` 目录下。

## 构建运行
```console
$ docker build -t my-php-app .
$ docker run -d --name some-app my-php-app
```

## 安装额外扩展
由于base镜像使用了alpine，用的是apk包管理工具，你可以进入alpine容器，来搜索对应的php扩展包

```console
$ docker run -it --rm index.csphere.cn/microimages/alpine sh -c "apk search php-* | grep myextension"
```

找到对应的软件包php-myextension后，编写Dockerfile如下：

```console
from index.csphere.cn/microimages/php-apache
run apk add php-myextension
```

## 开发环境使用
在开发环境为了更加高效，避免每次代码更新都进入build流程，可以：

```console
$ image=index.csphere.cn/microimages/php-apache
$ docker run -d --name php -p 8080:80 -v /myapp:/app --link mysql:mysql-master.example.com --link mysql:mysql-slave.example.com $image
```

我们通过volume将 `/myapp` 映射到了容器里的 `/app` ,这样代码放到 `/myapp` 下面编写，就可以实时观看到效果了。

上面我们用了两个link，一个用于主库，一个用于从库。建议开发过程中，使用生产环境分配好的名字，这样镜像部署到生产环境时，就不需要重新修改代码打包了。
我们在连结mysql时：

```console
// connect to master
mysql_connect("mysql-master.example.com", 3306)

// connect to slave
mysql_connect("mysql-slave.example.com", 3306)
```

另一种方法是使用环境变量，环境变量的好处是你在不同的部署环境下，可以赋予不同的名字或值。比如：

```console
$ image=index.csphere.cn/microimages/php-apache
$ docker run -d -p 8080:80 -v /myapp:/app -e MYSQL_MASTER_HOST=192.168.1.2 -e MYSQL_SLAVE_HOST=192.168.1.2 $image 
```

如果我们使用 `docker-compose` 部署，在不同环境部署时，需要注意修改yml配置里对应环境变量的值。

使用名字和环境变量，各有优劣。

## 生产环境使用

通过Dockerfile构建出应用镜像之后，在生产环境部署时，需要注意：

- 后端服务的名字，如数据库dbhost，redis主机的host等。由于我们已经在前面规范好了名字，所以部署到生产环境 就比较容易了。
- 日志收集, php的错误日志和访问日志，可以通过 `syslog` 进行收集

```console
$ docker run -d -p 80:80 --log-driver=syslog --log-opt address=udp://syslogserver:514 my-php-app
```

这个时候 `docker logs` 是没有日志输出的，日志都转存到 `syslog server` 了

## 授权和法律

该镜像由希云制造，未经允许，任何第三方企业和个人，不得重新分发。违者必究。

## 支持和反馈

该镜像由希云为企业客户提供技术支持和保障，任何问题都可以直接反馈到: `docker@csphere.cn`
