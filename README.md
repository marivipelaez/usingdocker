= Giving a try to docker =

[Using docker book](https://www.safaribooksonline.com/library/view/using-docker)
My first [docker repository](https://hub.docker.com/r/vpelalo/docker-whale)
Also following this very basic [docker tutorial](https://docs.docker.com/mac)

== Hello world ==

```shell
$ cd identidock
$ docker build -t identidock .
$ docker run -d -p 5000:5000 identidock
$ curl $(docker-machine ip default):5000
Hello world!
```


