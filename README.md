BUILD
=====

```
docker build . -t handlersocket --no-cache
```

COPY
====

```
docker run --rm -ti -v $PWD/plugin:/root/tmp handlersocket bash
cp -v /usr/lib/mysql/plugin/* /root/tmp/
exit
```
