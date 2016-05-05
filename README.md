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


=== Mounting code directory inside the container ===

```shell
$ docker stop [CONTAINER_ID]
$ docker rm [CONTAINER_ID]
$ docker build -t identidock .
$ docker run -d -p 5000:5000 -v /Users/mvpa/usingdocker/identidock/app:/app identidock
$ curl $(docker-machine ip default):5000
Hello world!
```

*Notes*
* Source folder cannot be a soft link inside /Users/mvpa, because /Users is directly shared with docker vm.
* Edit app/identidock.py and validate that it automatically changes running ```sh curl $(docker-machine ip default):5000``` again.

