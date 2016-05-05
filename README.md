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


=== Using uWSGI ===

Add uWSGI configuration in Dockerfile and:

```shell
$ docker stop [CONTAINER_ID]
$ docker rm [CONTAINER_ID]
$ docker build -t identidock .
$ docker run -d -p 9090:9090 -p 9191:9191 -v /Users/mvpa/usingdocker/identidock/app:/app identidock
$ curl $(docker-machine ip default):9090
Hello world!
$ curl $(docker-machine ip default):9191:9191
[uwsgi stats]
```

==== Run uwsgi with a dedicated user ====

```shell
$ docker build -t identidock .
$ docker run identidock whoami # whoami overrides CMD instruction
uwsgi
$ docker run -d -P --name port-test identidock
75543a7811a4dd69558511ad5cf6db041ccf208a3a99123044110b3a323a5b77
$ docker port port-test
9191/tcp -> 0.0.0.0:32768
9090/tcp -> 0.0.0.0:32769
$ curl $(docker-machine ip default):32769
Hello world!
```

=== Add a script to choose environment ===

* Our script will be a shell script. After editing it, make it executable and modify your Dockerfile to use it, before building the image:

```shell
$ chmod +x cmd.sh
$ docker build -t identidock .
$ docker run -e "ENV=DEV" -p 5000:5000 identidock
```

The exec command is used inside cmd.sh script in order to avoid creating a new process, which ensures any signals (such as SIGTERM) are recieved by our uwsgi process rather than being swallowed by the parent process.

Now, running with -e "ENV=DEV" starts a development server; otherwise, we get a production server.
