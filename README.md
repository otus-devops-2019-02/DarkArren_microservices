# DarkArren_microservices

DarkArren microservices repository

<details>
  <summary>HomeWork 14 - Технология контейнеризации. Введение в Docker</summary>

## HomeWork 14 - Технология контейнеризации. Введение в Docker

- Добавлен шаблон PR `.github/PULL_REQUEST_TEMPLATE.md`
- Добавлена интеграция Slack с GitHub `/github subscribe Otus-DevOps-2019-02/DarkArren_microservices commits:all`
- Настроена интеграция с TravisCI
- Установлен docker
- Запущен контейнер hello-world

<details>
  <summary>docker run hello-world</summary>

```bash
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete
Digest: sha256:41a65640635299bab090f783209c1e3a3f11934cf7756b09cb2f1e02147c6ed8
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

</details>

- Получен список запущенных контейнеров `docker ps`
- Получен список всех контейнеров `docker ps -a`
- Получен список всех сохраненный образов `docker images`
- Запущен контейнер ubuntu:16.04 `docker run -it ubuntu:16.04 /bin/bash`
- В запущенном контейнере создан файл **/tmp/file**
- Контейнер запущен повторно, проверено что файла нет
- Получен список всех запущенных контейнеров с форматирование списка:

```bash
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Names}}"

CONTAINER ID        IMAGE               CREATED AT                      NAMES
02bac0c6d6f7        ubuntu:16.04        2019-07-04 3:44:11 +0300 MSK   xenodochial_aryabhata
1305ff58ec3f        ubuntu:16.04        2019-07-04 3:43:53 +0300 MSK   hopeful_hertz
05fbd50e8973        hello-world         2019-07-04 3:33:18 +0300 MSK   nifty_blackwell
```

- Контейнер 1305ff58ec3f перезапущен через docker start 1305ff58ec3f
- Треминал подсоединен к контейнеру через docker attach 1305ff58ec3f
- Проверено наличие файла **/tmp/file**
- Терминал отсоединен по комбинации "Ctrl + p Ctrl + q"
- Внутри контейнера запущен процесс bash посредством `docker exec -it x bash`
- Создан образ из запущенного контейнера

```bash
docker commit 1305ff58ec3f darkarren/ubuntu-tmp-file
sha256:454a2224550b87e5bf6c1b3158154e2837dd485f86252148cc82862f7ba5d520

docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
darkarren/ubuntu-tmp-file   latest              454a2224550b        2 minutes ago       117MB
ubuntu                      16.04               7e87e2b3bf7a        3 weeks ago         117MB
hello-world                 latest              fce289e99eb9        7 weeks ago         1.84kB
```

### HW14: Задание со *

- Получена метадата контейнера и образа посредством `docker inspect`
- На основе изучения метадаты сделаны выводы о различиях между контейнером и образом, выводы описаны в **./docker-monolith/docker-1.log**

- Контейнер docker остановлен посредством команды `docker kill $(docker ps -q)`
- Получена информация об использованном дисковом пространстве посредством `docker system df`
- Удалены все незапущенные контейнеры `docker rm $(docker ps -a -q)`
- Удалены все образы, от которых не зависят запущенные контейнеры `docker rmi $(docker images -q)`

</details>

<details>
  <summary>HomeWork 15 - Docker-контейнеры</summary>

## HomeWork 15 - Docker-контейнеры

- Создан проект docker в GCE
- Настроил gcloud на работу с новым проектом `gcloud init`
- Авторизовался через `gcloud auth application-default login`
- Имя проекта в Gogle Cloud добавленно в env: `export GOOGLE_PROJECT=docker`
- Для проекта docker включен Google Engine API через консоль <https://console.developers.google.com/apis/api/compute.googleapis.com/landing?project=docker-245714>
- Создан docker-machine в GCE `docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-disk-size 20 --google-zone europe-west1-b docker-host`
- Установлено подключение к docker-host `eval $(docker-machine env docker-host)`
- В ./docker-monolith добавлены файлы: mongod.conf, start.sh, db_config, Dockerfile
- Подготовлен Dockerfile содержащий в себе установку зависимостей, конфигурирование MongoDB, установку самого приложения reddit
- Собран docker-образ: `docker build -t reddit:latest .`
- Запущен контейнер из подготовленного образа `docker run --name reddit -d --network=host reddit:latest`
- Создано правило для входящего трафика на порт 9292 `gcloud compute firewall-rules create reddit-app --allow tcp:9292 --target-tags=docker-machine --description="Allow PUMA connections" --direction=INGRESS`
- Приложение доступно по адресу <http://docker-host:9292>

### Docker Hub

- Создана учетная запись на Docker Hub
- Авторизована учетная запись через консоль `docker login`
- Образ помечен тэгом darkarren/otus-reddit:1.0 `docker tag reddit:latest darkarren/otus-reddit:1.0`
- Образ запушен в Docker Hub `docker push darkarren/otus-reddit:1.0`
- Проверена возможность запуска из образа, который был запушен на Docker Hub, на локальной машине `docker run --name reddit -d -p 9292:9292 darkarren/otus-reddit:1.0`
- Приложение доступно по <http://127.0.0.1:9292>
- Посмотрел логи контейнера посредством `docker logs reddit -f`, убедился что в процессе взаимодействия с приложением логи отображаются
- Зашел в контейнер и вызвал его остановку изнутри `docker exec -it reddit bash; ps aux; killall5 1`
- Запустил контейнер `docker start reddit`
- Остановил и удалил контейнер `docker stop reddit && docker rm reddit`
- Запустил контейнер без запуска приложения `docker run --name reddit --rm -it darkarren/otus-reddit:1.0 bash; ps aux; exit`
-  Получил информацию об образе `docker inspect darkarren/otus-reddit:1.0`
- Получил информацию связанную только с запуском `docker inspect darkarren/otus-reddit:1.0 -f '{{.ContainerConfig.Cmd}}'`
- Запустил контейнер и внес в него изменения

<details>
  <summary>docker run --name reddit -d -p 9292:9292 darkarren/otus-reddit:1.0</summary>

```bash
docker run --name reddit -d -p 9292:9292 darkarren/otus-reddit:1.0

ecc39f8b4a48cb49de30f174098d23be524fd50690cd1271f77f84e056934e9c

[docker exec -it reddit bash](docker exec -it reddit bash

root@ecc39f8b4a48:/# mkdir /test1234
root@ecc39f8b4a48:/# touch /test1234/testfile
root@ecc39f8b4a48:/# rmdir /opt
root@ecc39f8b4a48:/# exit
exit)
```

</details>

- Получил изменения в контейнере

<details>
  <summary>docker diff reddit</summary>

```bash
docker diff reddit
A /test1234
A /test1234/testfile
C /var
C /var/lib
C /var/lib/mongodb
A /var/lib/mongodb/local.0
A /var/lib/mongodb/local.ns
A /var/lib/mongodb/mongod.lock
A /var/lib/mongodb/_tmp
A /var/lib/mongodb/journal
A /var/lib/mongodb/journal/j._0
C /var/log
A /var/log/mongod.log
C /root
A /root/.bash_history
C /tmp
A /tmp/mongodb-27017.sock
D /opt
```

</details>

- Остановил, удалил и заново запустил контейнер, убедился, что изменений не сохранилось

<details>
  <summary>docker stop reddit && docker rm reddit && docker run --name reddit --rm -it darkarren/otus-reddit:1.0 bash </summary>

```bash
docker stop reddit && docker rm reddit
reddit
reddit

docker run --name reddit --rm -it darkarren/otus-reddit:1.0 bash
root@b7aaf9b04429:/# ls /
bin   dev  home  lib64  mnt  proc    root  sbin  start.sh  tmp  var
boot  etc  lib   media  opt  reddit  run   srv   sys       usr
root@b7aaf9b04429:/#
```

</details>

### HW 15: Задание со *

- Подготовлен сценарий terraform, позволяющий развернуть в облаке n машин на чистой ubuntu 16.04, количество машины определяется переменной vm_count="3" в terraform.tfvars
- Подготовлены плейбуки ansible: install.yml  - установка docker и необходимых зависимостей, deploy.yml - запуск прилоежния (reddit.yml - запуск плейбуков друг за другом)
- Подготовлен плейбук для провижининга образа packer - packer.yml

</details>

<details>
  <summary>HomeWork 16 - Docker-образы. Микросервисы</summary>

## HomeWork 16 - Docker-образы. Микросервисы

- Установлен линтер hadolint
- Загружен архив с исходным кодом микросервисов
- Созданы Dockerfile: ./post-py/Dockerfile, ./ui/Dockerfile, ./comment/Dockerfile с учетом рекомендаций hadolint
- Собраны образы микросевисов

<details>
  <summary>build docker images</summary>

```bash
docker build -t darkarren/post:1.0 src/post-py \
&& docker build -t darkarren/comment:1.0 src/comment \
&& docker build -t darkarren/ui:1.0 src/ui
```

</details>

- Создана сеть для контейнеров `docker network create reddit`
- Запущены контейнеры с подключением к созданной сети

<details>
  <summary>run reddit containers</summary>

```bash
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post darkarren/post:1.0
docker run -d --network=reddit --network-alias=comment darkarren/comment:1.0
docker run -d --network=reddit -p 9292:9292 darkarren/ui:1.0
```

</details>

- Проверил доступность и работоспособность приложения по адресу <http://docker-host:9292>

### HW16: Заданиче со * 1

- Остановил все запущенные контейнеры docker kill $(docker ps -q)
- Запустил контейнеры с измененными network-alias и дополнительно переданными значениями переменных

<details>
  <summary>run reddit containers with env</summary>

```bash
docker run -d --network=reddit --network-alias=post_db_1 --network-alias=comment_db_1 mongo:latest \
&& docker run -d --network=reddit --network-alias=post_1 --env POST_DATABASE_HOST=post_db_1 darkarren/post:1.0 \
&& docker run -d --network=reddit --network-alias=comment_1 --env COMMENT_DATABASE_HOST=comment_db_1 darkarren/comment:1.0 \
&& docker run -d --network=reddit --env POST_SERVICE_HOST=post_1 --env COMMENT_SERVICE_HOST=comment_1 -p 9292:9292 darkarren/ui:1.0
```

</details>

- Проверил доступность и работоспособность приложения по адресу <http://docker-host:9292>

### Образы приложений

- Изменил Dockerfile для ui с учетом рекомендаций hadolint
- Пересобрал образ, убедился, что он стал значительно меньше предыдущего

### HW16: Задание со * 2

- Подготовил новый образ для ui. За счет использования alpine в качестве основного образа, а так же чистки лишних библиотек, которые не нужны после сборки образа, и очистки кэша - удалось уменьшить образ до 38.2MB без потери работоспособности

<details>
  <summary>./ui/Dockerfile</summary>

```dockerfile
FROM alpine:3.9


ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
COPY . $APP_HOME
RUN apk --no-cache add ruby-bundler=1.17.1-r0 ruby-dev=2.5.5-r0 make=4.2.1-r2 gcc=8.3.0-r0 musl-dev=1.1.20-r4 ruby-json=2.5.5-r0 \
  && bundle install --clean --no-cache --force \
  && rm -rf /root/.bundle \
  && apk --no-cache del ruby-dev make gcc musl-dev

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]


```

</details>

- Подготовил новый образ для post. Удалось уменьшить образ до 106MB

<details>
  <summary>./post-py/Dockerfile</summary>

```Dockerfile
FROM python:3.6.0-alpine

WORKDIR /app
COPY . /app

RUN apk --no-cache add gcc=5.3.0-r0 musl-dev=1.1.14-r16 \
    && pip --no-cache-dir install -r /app/requirements.txt \
    && apk --no-cache del gcc musl-dev

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

CMD ["python3", "post_app.py"]

```

</details>

- Подготовил новый образ для comment. Удалось уменьшить до 35.8MB

<details>
  <summary>./comment/Dockerfile</summary>

```Dockerfile
FROM alpine:3.9

ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/

RUN apk --no-cache add ruby-bundler=1.17.1-r0 ruby-dev=2.5.5-r0 \
    make=4.2.1-r2 gcc=8.3.0-r0 musl-dev=1.1.20-r4 ruby-json=2.5.5-r0 ruby-bigdecimal=2.5.5-r0 \
    && bundle install --clean --no-cache --force \
    && rm -rf /root/.bundle \
    && apk --no-cache del ruby-dev make gcc musl-dev
COPY . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]

```

</details>

- Получившиеся образы в таблице

<details>
  <summary>docker images</summary>

```bash
arren | sort
darkarren/comment       1.0                 d149d523f32c        About an hour ago    768MB
darkarren/comment       1.1                 3b421cc61e86        About a minute ago   35.8MB
darkarren/post          1.0                 22e54cf2e227        42 minutes ago       198MB
darkarren/post          1.1                 658d72e9d4cd        11 minutes ago       106MB
darkarren/ui            1.0                 cb3b6b4a33fd        About an hour ago    770MB
darkarren/ui            1.1                 1be28b54d475        30 seconds ago       38.2MB
```

</details>

- Создан docker volume `docker volume create reddit_db`
- Контейнеры перезапущены, к mongodb подключен docker volume

<details>
  <summary>docker run with volume</summary>

```bash
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest \
&& docker run -d --network=reddit --network-alias=post darkarren/post:1.1 \
&& docker run -d --network=reddit --network-alias=comment darkarren/comment:1.1 \
&& docker run -d --network=reddit -p 9292:9292 darkarren/ui:1.1
```

</details>

- Добавлен новый пост, контенеры перезапущены, пост на месте.

</details>

<details>
  <summary>HomeWork 17 - Docker, сети, docker-compose</summary>

## HomeWork 17 - Docker, сети, docker-compose

### None network driver

- Запущен контейнер joffotron/docker-net-tools с сететвым драйвером none `docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig`, в таком контейнере доступен тоько loopback, доступа к внешней сети нет

### Host network driver

- Запущен контейнер joffotron/docker-net-tools с сетевым драйвером host `docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig`
- Вывод предудущего запуска контейнера аналогичен выводу при выполнении `docker-machine ssh docker-host ifconfig`
- Запущено четыре контейнера с nginx `docker run --network host -d nginx`
- Выполнение `docker ps` показывает что запущен только один контейнер, так как остальные упали по причине того, что все они используют сеть хоста, и при этом первый из запущенных уже занял порт 80
- Все запущенные контейнеры остановлены `docker kill $(docker ps -q)`
- На docker-host создан симлинк `sudo ln -s /var/run/docker/netns /var/run/netns`
- После запуска `docker run -d --network host joffotron/docker-net-tools` вывод `sudo ip netns` не изменился
- После запуска `docker run -d --network none joffotron/docker-net-tools` в выводе появился еще один namespace `ce75f7d63d5d`

### Bridge network driver

- Создана bridge-сеть reddit `docker network create reddit --driver bridge`
- Запущены контейнеры reddit с использованием bridge-сети

<details>
  <summary>docker run --network reddit</summary>

```bash
docker run -d --network=reddit mongo:latest \
&& docker run -d --network=reddit darkarren/post:1.0 \
&& docker run -d --network=reddit darkarren/comment:1.0 \
&& docker run -d --network=reddit -p 9292:9292 darkarren/ui:1.0
```

</details>

- Обнаружена проблема с некорректной работой сервисов
- Контейнеры остановлены `docker kill $(docker ps -q)`
- Контейнеры перезапущены с использованием --network-alias

<details>
  <summary>docker run network reddit --network-alias</summary>

```bash
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest \
&& docker run -d --network=reddit --network-alias=post darkarren/post:1.0 \
&& docker run -d --network=reddit --network-alias=comment darkarren/comment:1.0 \
&& docker run -d --network=reddit -p 9292:9292 darkarren/ui:1.0
```

</details>

- Результат - приложение работает корректно, контейнеры остановлены `docker kill $(docker ps -q)`
- Созданы новые сети docker-networks

<details>
  <summary>docker network create</summary>

```bash
docker network create back_net --subnet=10.0.2.0/24

docker network create front_net --subnet=10.0.1.0/24
```

</details>

- Контейнеры запущены с использованием новых сетей

<details>
  <summary>docker run</summary>

```bash
docker run -d --network=front_net -p 9292:9292 --name ui darkarren/ui:1.0 \
&& docker run -d --network=back_net --name comment darkarren/comment:1.0 \
&& docker run -d --network=back_net --name post darkarren/post:1.0 \
&& docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest
```

</details>

- Обнаружена проблема на главной странице приложения `Can't show blog posts, some problems with the post service. Refresh?`
- Контейнеры подключены к дополнительным сетям `docker network connect front_net post` и `docker network connect front_net comment`, приложение работает корректно

### Сетевой стек

- Подключился по ssh к docker-host `docker-machine ssh docker-host`
- Установил пакет bridge-utils `sudo apt-get update && sudo apt-get install bridge-utils`
- Выполнил `sudo docker network ls`

<details>
  <summary>sudo docker network ls</summary>

```bash
sudo docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
9820cacd8fab        back_net            bridge              local
bb82f5fb0c7d        bridge              bridge              local
b03a6069d26e        front_net           bridge              local
0c925de52059        host                host                local
04d056f48418        none                null                local
```

</details>

- Вывел информацию о bridge-сетях `ifconfig | grep br`

<details>
  <summary>ifconfig | grep br && brctl show</summary>

```bash
ifconfig | grep br
br-9820cacd8fab Link encap:Ethernet  HWaddr 02:42:50:cc:73:ca
br-b03a6069d26e Link encap:Ethernet  HWaddr 02:42:c4:f3:68:74

brctl show br-9820cacd8fab
bridge name       bridge id           STP enabled   interfaces
br-9820cacd8fab   8000.024250cc73ca   no            veth33e7906
                                                    veth7716168
                                                    vetheca5e8d

brctl show br-b03a6069d26e
bridge name       bridge id           STP enabled   interfaces
br-b03a6069d26e   8000.0242c4f36874   no            veth12b3738
                                                    vethb898164
                                                    vethdea83a8
```

</details>

- Отобразил iptables `sudo iptables -nL -t nat`

<details>
  <summary>sudo iptables -nL -t nat</summary>

```bash
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  10.0.1.0/24          0.0.0.0/0
MASQUERADE  all  --  10.0.2.0/24          0.0.0.0/0
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0
MASQUERADE  tcp  --  10.0.1.2             10.0.1.2             tcp dpt:9292

Chain DOCKER (2 references)
target     prot opt source               destination
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:9292 to:10.0.1.2:9292
```

</details>

- Нашел процесс, который слушает порт 9292:

<details>
  <summary>ps ax | grep docker-proxy</summary>

```bash
ps ax | grep docker-proxy
 7319 ?        Sl     0:00 /usr/bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 9292 -container-ip 10.0.1.2 -container-port 9292
16344 pts/0    S+     0:00 grep --color=auto docker-proxy
```

</details>

### Docker-compose

- Создал файл `./src/docker-compose.yml`
- Остановил контейнеры `docker kill $(docker ps -q)`
- Добавил в env переменную USERNAME `export USERNAME=darkarren`
- Запустил контейнеры через docker-compose `docker-compose up -d`
- Убедился в том, что приложение доступно по <http://docker-host:9292>

### HW 17: Самостоятельное задание

- Добавлено использование множественных сетей (двух) front_net и back_net вместо использования одной сети reddit, добавил в файл параметры сетей (network range) и алиасы для сервисов
- Порт публикации сервиса ui параметризован и будет задаваться переменной `PUBLIC_PORT`
- Параметризованы версии сервисов, будут использованы переменные `UI_VERSION`, `POST_VERSION` и `COMMENT_VERSION`
- Добавил файл `./src/.env`, указал в нем параметры для запуска контейнеров docker-compose
- Убедился что контейнеры поднимаются и работают корректно
- Выяснил как задается базовое имя проекта при старте контейнеров, очевидно, что по умолчанию берется название папки, в которой находится docker-compose.yml, например в моем случае контенеры (и сети и иже с ними) называются с префиксом `src_`, например: `src_ui_1`. Изменить базовое имя проекта можно следующими способами:
  - указав параметр `COMPOSE_PROJECT_NAME=foo` в переменных окружения
  - указав этот параметр в `.env`, который используется в docker-compose.yml
  - либо указав непосредственно при запуске docker-compose, например: `docker-compose -p foo up -d`

### HW 17: Задание со *

- Скопировал локальную директорию `./src` на хост docker-machine: `docker-machine scp -r -d ./src docker-host:/home/docker-user`
- Создал файл `docker-compose.override.yml`
- Добавил запуск в puma в debug режиме и с двумя воркерами посредством инструкции entrypoint для ui и comment микросервисов

<details>
  <summary>entrypoint</summary>

```bash
   entrypoint:
    - puma
    - --debug
    - -w 2
```

</details>

- Добавил подключение к контейнерам папок с докер-хоста

<details>
  <summary>volumes</summary>

```bash
   volumes:
    - /home/docker-user/src/ui:/app
```

</details>

- Запустил контейнеры `docker-compose up -d`, написал пост, перезапустил контейнеры и убедился, что пост сохранился

</details>

<details>
  <summary>HomeWork 19 - Устройство Gitlab CI. Построение процесса непрерывной поставки</summary>

## HomeWork 19 - Устройство Gitlab CI. Построение процесса непрерывной поставки

- Создан новый хост через docker-machine

<details>
  <summary>new docker-machine</summary>

```bash
docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-disk-size 100 --google-zone europe-west1-b gitlab-ci
```

</details>

- Подключился к новой vm - `docker-machine ssh gitlab-ci`
- Подготовил директории и docker-compose.yml для GitLab
- Установил docker-compose
- Запустил контейнеры `sudo docker-compose up -d`
- Разрешил доступ к машине по http / https
- Зашел на главную GitLab и задал root password
- Отключил Sign Up
- Создал Project Group - Homework
- Создал новый проект в группе - example
- Добавил remote в репозиторий DarkArren_microservices `git remote add gitlab http://34.76.178.217/homework/example.git`
- Запушил в gitlab - `git push gitlab gitlab-ci-1`
- Добавил в репозиторий `.gitalb-ci.yml` и запушил в репозиторий gitlab
- Получен токен для GitLab Runner `1SzF1G6VcjW5TEd4qxU2`
- На сервере GitLab CI запущен контейнер gitlab runner

<details>
  <summary>run gitlab runner</summary>

```bash
docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest
```

</details>

- Запущена регистрация gitlab runner `docker exec -it gitlab-runner gitlab-runner register --run-untagged --locked=false`
- Зарегистрирован gitlab runner для проекта
- CI/CD Pipeline прошел успешно
- В репозиторий добавлен исходный код приложения reddit
- Изменил описание pipeline в .gitlab-ci.yml для запуска тестов приложения
- Добавил файл `simpletest.rb` с описанием теста в директорию приложения
- Добавил библиотеку для тестирования `rack-test` в `reddit/Gemfile`
- Запушил изменения в gitlab и убедился, что тесты прошли

### Окружения

- Изменил шаг deploy_job так, что теперь он описывает окружение dev
- Убедился в том, что в Operations - Environments появилось описание первого окружения - dev
- Добавил в .gitlab-ci.yml описание для окружения stage и production
- Добавил в описание stage и production окружий директиву only, которая позволит запустить job только если установлен semver тэг в git, например, 2.4.10
- Проверил запуск все job при пуше изменений, которые помечены тегом

### Динамические окружения

- Добавил определение динамического окружения для веток кроме master

### HW 19: Задание со *

#### Сборка Docker image

- Подготовил Dockerfile для сборки docker-image приложения
- В /srv/gitlab-runner/config/config.toml выставил `priveleged=true` и `volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]`
- В разделе `before_script` закомментировал `bundle install`, в test_unit_job добавлена установка зависимостей через `bundle install` для прохождения тестов
- Для успешной сборки и отправи оборазом в registry необходимо в Settings - CI/CD - Variables добавить параметры
  - docker_hub_user - логин от учетной записи docker hub
  - docker_hub_password - пароль от учетной записи docker hub
- В шаг build добавлены команды сборки контейнера и пуша в registry

<details>
  <summary>build step</summary>

```bash
build_job:
  image: docker:dind
  stage: build
  script:
    - echo 'Building'
    - docker login -u darkarren -p ${docker_hub_password}
    - docker build -t gitlab-reddit:$CI_COMMIT_SHORT_SHA .
    - docker tag gitlab-reddit:$CI_COMMIT_SHORT_SHA darkarren/gitlab-reddit:latest
    - docker tag gitlab-reddit:$CI_COMMIT_SHORT_SHA darkarren/gitlab-reddit:$CI_COMMIT_SHORT_SHA
    - docker push darkarren/gitlab-reddit:$CI_COMMIT_SHORT_SHA
    - docker push darkarren/gitlab-reddit:latest
```

</details>

- В Settings - CI/CD - Variables добавлены следующие параметры
  - gcloud_compute_service_account - type: file, value: json-файл кредов от service account с достаточными правами в проекте
  - gcloud_project_id - type: variable, value: название проекта
  - ssh_key - type: file, value: приватный ключ пользователя appuser
- Настроил создание новой машины в GCP при каждом запуске пайплайна
- Настроил запуск контейнера из образа, собранного на предыдущем шаге
- Настроил удаление машины, после проверки запуска приложения

#### GitLab runner automated deployment

Skipped

#### Интеграция GitLab и Slack

- Добавил в workspace в Slack приложение incoming webhooks
- Получил WebHook URL
- Добавил webhook url в настройках интеграции со Slack в GitLab (Project Settings - Integration - Slack Notification)
- Убедился что нотификация прошла

</details>

<details>
  <summary>HomeWork 20 - Введение в мониторинг. Системы мониторинга</summary>

## HomeWork 20 - Введение в мониторинг. Системы мониторинга

- Создано firewall-правило для prometheus `gcloud compute firewall-rules create prometheus-default --allow tcp:9090`
- Создано firewall-правило для puma `gcloud compute firewall-rules create puma-default --allow tcp:9292`
- Создан хост docker-machine

<details>
  <summary>docker-machine</summary>

```bash
docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/
images/family/ubuntu-1604-lts \
--google-machine-type n1-standard-1 \
--google-zone
```

</details>

- Запущен контейнер Prometheus `docker run --rm -p 9090:9090 -d --name prometheus prom/prometheus:v2.1.0`
- Поосмтрел метрики, которые уже сейчас собирает prometheus
- Посмотрел список таргетов, с которых prometheus забирает метрики
- Остановил контейнер с prometheus `docker stop prometheus`
- Перенес docker-monolith и файлы docker-compose и .env из src в новую директорию docker
- Создал директорию под все, что связано с мониторингом - monitoring
- Добавил monitoring/prometheus/Dockerfile для создания образа с кастомным конфигом
- Создал конфиг monitoring/prometheus/prometheus.yml
- Собрал образ prometheus `docker build -t darkarren/prometheus .`
- Собрал образы микросервисов посредсвом docker_build.sh `for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done`
- удалил из docker/docker-compose.yml директивы build и добавил описание для prometheus
- добавил конфигурацию networks для prometheus в docker-compose
- актуализировал переменные в .env
- запустил контейнеры `docker-compose up -d`
- приложения доступно по адресу <http://34.76.154.234:9292/> и prometheus доступен на <http://34.76.154.234:9090/>

### Мониторинг состояния микросервисов

- Убедился что в prometheus определены и доступны эндпоинты ui и comment
- Получил статус метрики ui_health, так же получил ее в виде графика
- Остановил микросервис post и увидел, что метрика изменила свое значение на 0
- Посмотрел метрики доступности сервисов comment и post
- Заново запустил post-микросервис `docker-compose start post`

### Сбор метрик хоста

- Добавил определение контейнера node-exporter в docker-compose.yml
- Добавил job для node-exporter в конфиг Prometheus и пересобрал контейнер
- Остановил и повторно запустил контейнеры docker-compose
- Убедился в том, что в списке эндпоинтов пояивлся эндпоинт node
- Выполнил `yes > /dev/null` на docker-host и убедился что метрики демонстрируют увеличение нагрузки на процессор
- Загрузил образы на Docker Hub <https://hub.docker.com/u/darkarren>

### HW 20: Задание со * 1

- Решил использовать для мониторинг MongoDB Percona MongoDB Exporter
- Source code: <https://github.com/percona/mongodb_exporter>
- Использоваться будет последний релиз - `git checkout tags/v0.8.0`
- Создал Dockerfile на основе того, что есть в репозитории, добавил в ./monitoring/mongodb-exporter
- Подготовил образ mongodb-exporter `docker build -t $USER_NAME/mongodb-exporter .`
- Добавил тэг версии `docker tag $USER_NAME/mongodb-exporter:latest $USER_NAME/mongodb-exporter:0.8.0`
- Запушил на Docker Hub `docker push $USER_NAME/mongodb-exporter`
- Добавил в docker-compose запуск контейнера с MongoDB Exporter

<details>
  <summary>docker-compose mongodb-exporter</summary>

```docker
  mongodb-exporter:
    image: ${USERNAME}/mongodb-exporter:${MONGO_EXPORTER_VERSION}
    ports:
      - '9216:9216'
    command:
      - '--collect.database'
      - '--collect.collection'
      - '--collect.indexusage'
      - '--collect.topmetrics'
      - '--mongodb.uri=mongodb://post_db:27017'
    networks:
      back_net:
        aliases:
          - mongodb-exporter
```

</details>

- Добавил в prometheus.yml job mongod, собирающий метрики mongodb-exporter

<details>
  <summary>prometheus job</summary>

```bash
  - job_name: 'mongod'
    static_configs:
      - targets:
        - 'mongodb-exporter:9216'
```

</details>

- Пересобрал образ prometheus и перезапустил контейнеры

### HW 20: Задание со * 2 - BlackBox Exporter

- Изучил репозиторий prometheus/blackbox-exporter
- Подготовил Dockerfile для сборки docker image

<details>
  <summary>Dockerfile blackbox-exporter</summary>

```Dockerfile
FROM golang:1.11 as golang

ARG VERSION=0.14.0

WORKDIR /go/src/github.com/blackbox_exporter

RUN git clone https://github.com/prometheus/blackbox_exporter.git . && \
    git checkout tags/v"${VERSION}" && \
    make

FROM quay.io/prometheus/busybox:latest

COPY --from=golang /go/src/github.com/blackbox_exporter/blackbox_exporter  /bin/blackbox_exporter
COPY blackbox.yml       /etc/blackbox_exporter/config.yml

EXPOSE      9115
ENTRYPOINT  [ "/bin/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]
```

</details>

- Подготовил конфигурационный файл blackbox.yml с проверками по http и icmp

<details>
  <summary>blackbox.yml</summary>

```yml
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2"]
      valid_status_codes:
        - 200
        - 404
      method: GET
      referred_ip_protocol: "ip4"
  icmp:
    prober: icmp
    timeout: 5s
    icmp:
      preferred_ip_protocol: "ip4"

```

</details>

- Подготовил образ blackbox-exporter `docker build -t $USER_NAME/blackbox-exporter .`
- Добавил тэг версии `docker tag $USER_NAME/blackbox-exporter:latest $USER_NAME/blackbox-exporter:0.8.0`
- Запушил на Docker Hub `docker push $USER_NAME/blackbox-exporter`
- Добавил в docker-compose запуск контейнера с BlackBox Exporter

<details>
  <summary>blackbox-exporter docker-compose</summary>

```yml
  blackbox-exporter:
    image: ${USERNAME}/blackbox-exporter:${BLACKBOX_EXPORTER_VERSION}
    ports:
      - '9115:9115'
    networks:
      back_net:
        aliases:
          - blackbox-exporter

      front_net:
        aliases:
          - blackbox-exporter
```

</details>

- Добавил job в конфиг prometheus и пересобрал контейнер

<details>
  <summary>prometheus job</summary>

```yml
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module:
        - http_2xx # Look for a HTTP 200 response.
        - icmp
    static_configs:
      - targets:
        - ui:9292
        - comment:9292
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115  # The blackbox exporter's real hostname:port.
```

</details>

- Добавил переменную BLACKBOX_EXPORTER_VERSION в .env
- Пересобрал образ prometheus и перезапустил контейнеры `docker-compose donw && docker-compose up -d`

### HW 20 задание со * 3 - Make

- Подготовил Makefile, перед запуском нужно выполнить `export USER_NAME=your-docker-hub-login`
- Сборка всех контейнеров - `make build-all`
- Пуш всех контейнеров - `make push-all`

</details>

<details>
  <summary>HomeWork 21 - Мониторинг приложения и инфраструктуры</summary>

## HomeWork 21 - Мониторинг приложения и инфраструктуры

### Мониторинг Docker-контейнеров

- Перенес описание приложений для мониторинга в отдельный docker-compose-файл `docker-compose-monitoring.yml`
- Добавил в docker-compose-monitoring.yml описание для контейнера cAdvisor
- Добавил в конфиг prometheus job для cadvisor, пересобрал image prometheus
- Создал в gcloud правило для доступа на 8080 порт `gcloud compute firewall-rules create cadvisor-default --allow tcp:8080`
- Запустил контейнеры `docker-compose up -d && docker-compose -f docker-compose-monitoring.yml up -d`
- Изучил информацию, которую предоставляет web-интерфейс cAdvisor

### Визуализация метрик

- Добавил описание Grafana в `docker-compose-monitoring.yml`
- Запустил контейнер Grafana `docker-compose -f docker-compose-monitoring.yml up -d grafana`
- Добавил firewall rule для Grafana `gcloud compute firewall-rules create grafana--default --allow tcp:3000`
- Через web-интерфейс добавил datasource prometheus server
- Нашел на официальном сайте и загрузил дашборд `Docker and system monitoring` в monitoring/grafana/dashboards/DockerMonitoring.json
- Импортировал дашборд в Grafana
- Убедился что появился дашборд, показывающий метрики контейнеров

### Сбор метрик приложения

- В конфиг prometheus.yml добавлен job для сбора метрик с сервиса post
- Пересобран образ prometheus
- Пересозданы контейнеры инфраструктуры мониторинга `docker-compose -f docker-compose-monitoring.yml down && docker-compose -f docker-compose-monitoring.yml up -d`
- В приложении reddit добавлены посты и комментарии к ним
- В Grafana добавлен новый дашборд
- В Grafana добавлен график ui_request_count
- Добавлен график http_requests with error codes
- Сохранил изменениея в дашборде, проверил наличие версий в options дашборда
- Добавил rate(ui_request_count[1m]) для первого графика
- Добавил новый график с вычислением 95-ого процентиля для метрики ui_request_response_time_bucket `histogram_quantile(0.95, sum(rate(ui_request_response_time_bucket[5m])) by (le))`
- Экспортировал дашборд в виде json

### Сбор метрик бизнес логики

- Создал новый дашборд Business_Logic_Monitoring
- Добавил на дашборд график `rate(post_count[1h])`
- Добавил график `rate(comment_count[1h])`
- Экпортировал дашборд в json

### Алертинг

- Создал Dockerfile для alertmanager
- Добавил config.yml для alertmanager с индвидуальными настройками webhook
- Собрал образ alertmanager и запушил в Docker Hub
- Добавил alertmanager в docker-compose-monitoring.yml
- Добавил alerts.yml для prometheus
- Добавил копирование alerts.yml в Dockerfile prometheus
- Добавил информацию об алертинге в конфиг prometheus и пересобрал образ
- Перезапустил контейнеры мониторинга
- Убедился что правила алертинга отображаются в web-интерфейсе Prometheus
- Остановил сервис post и убедился в том, что оповещение пришло в Slack
- Запушил все образы в Docker Hub - <https://hub.docker.com/u/darkarren>

### HW21: Задание со *

- В Makefile добавлены команды для сборки новых образов
- На docker-host в /etc/docker добавлен daemon.json (172.17.0.1 - адрес хоста в сети docker0)

```json
{
  "metrics-addr" : "172.17.0.1:9323",
  "experimental" : true
}
```

- В prometheus.yml добавлен таргет для docker

``` yml
  - job_name: 'docker'
    static_configs:
    - targets:
      - '172.17.0.1:9323'
```

- В Grafana добавлен дашборд Docker Engine Metrics <https://grafana.com/grafana/dashboards/1229>
- Добавлен Dockerfile monitoring/telegraf/Dockerfile и конфиг monitoring/telegraf/telegraf.conf
- Запуск Telegraf добавлен в docker-compose-monitoring.yml

<details>
  <summary>telegraf docker-compose</summary>

```yml
  telegraf:
    image: ${USER_NAME}/telegraf:${TELEGRAF_VERSION}
    ports:
      - 9273:9273
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      back_net:
        aliases:
          - telegraf
      front_net:
        aliases:
          - telegraf
```

</details>

- В prometheus.yml добавлен таргет на telegraf

<details>
  <summary>telegraf prometheus target</summary>

```yml
  - job_name: 'telegraf'
    static_configs:
      - targets: ['telegraf:9273']
```

</details>

- В Grafana добавлен дашборд Telegraf Docker

</details>

<details>
  <summary>HomeWork 23 - Логирование и респределенная трассировка</summary>

## HomeWork 23 - Логирование и респределенная трассировка

- Обновил код приложения и пересобрал образы `for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done`
- Убедился что образы с тегом `logging` существуют, запушил их в Docker Hub
- Создал новый хост docker-machine

<details>
  <summary>docker-machine logging</summary>

```bash
docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-open-port 5601/tcp \
    --google-open-port 9292/tcp \
    --google-open-port 9411/tcp \
    logging
```

</details>

- Окружение настроено на работу с новой vm `eval $(docker-machine env logging)`
- Получен адрес новой машины `docker-machine ip logging`

### Логирование Docker контейнеров

- Подготовлен compose-файл docker-compose-logging.yml с описанием контейнеров fluentd, elasticsearch, kibana
- Подготовлен Dockerfile для fluentd **logging\fluentd\Dockerfile**
- Подготовлен config-файл для fluentd **logging\fluentd\fluent.conf**
- Собран образ fluentd `docker build -t $USER_NAME/fluentd .`
- В .env указан тэг logging для ui, post, comment
- Запустил контейнеры `docker-compose up -d`
- Просмотрел логи приложения `docker-compose logs -f post`
- Добавил опередление драйвера для логирования сервиса post в `docker-compose.yml`
- Запустил контейнеры системы логирования и перезапустил контейнеры приложения
- Исправил падение контейнера Elasticsearch, изменил параметр на docker-host - `sudo sysctl -w vm.max_map_count=262144`, заработало
- Добавил Index Pattern на Kibana
- Посмотрел что логи теперь собираются и отображаются в Kibana
- Добавил фильтр в конфиг fluentd
- Пересобрал и перезапустил fluentd `docker-compose -f docker-compose-logging.yml up -d fluentd`
- Убедился что фильтр применился и вместо одного поля log доступно несколько
- Убедился что можно найти запись в логе через поиск

### Неструктурированные логи

- Добавил драйвер логирования для сервиса ui
- Перезапустил контейнер ui `docker-compose stop ui && docker-compose rm ui && docker-compose up -d`
- Добавил фильтр с использованием регулярного выражения для сервиса ui в конфигурационный файл fluent.conf
- Пересобрал образ fluentd и перезапустил сервисы логирования
- Убедился что в кибане корректно распарсились логи микросервиса UI
- Заменил регулярное выражение на использование grok-паттернов
- Пересобрал и перезапустил кибану, убедился что логи парсятся корректно

### HW23: Задание со *

- Добавлен второй grok-pattern <https://github.com/fluent/fluent-plugin-grok-parser> в фильтр service.ui

<details>
  <summary>filter service.ui</summary>

```xml
<filter service.ui>
  @type parser
  format grok
  grok_pattern service=%{WORD:service} \| event=%{WORD:event} \| request_id=%{GREEDYDATA:request_id} \| message='%{GREEDYDATA:message}'
  key_name message
  reserve_data true
</filter>

<filter service.ui>
  @type parser
  format grok
  grok_pattern service=%{WORD:service} \| event=%{WORD:event} \| path=%{URIPATH:path} \| request_id=%{GREEDYDATA:request_id} \| remote_addr=%{IP:remote_addr} \| method= %{WORD:method} \| response_status=%{NUMBER:response_status}
  key_name message
  reserve_data true
</filter>
```

</details>

### Распределенный трейсинг ***

- Добавил Zipkin в `docker-compose-logging.yml`
- В `docker-compose.yml` добавленна env-переменая ZIPKIN_ENABLED=${ZIPKIN_ENABLED} для микросервисов
- Добавлено значение ZIPKIN_ENABLED в .env
- Просмотрел трассировки через webui zipkin

### Самостоятельное задание

- Обновил сорцы приложения на "забагованные"
- Пересобрал контейнеры с тэгом bugged
- Запустил приложение и посмотрел трейсы. Выясняется, что обращение к серверу post стало занимать 3 секунды, вместо миллисекунд, вероятно проблема с долгим открытием поста именно в этом.
- Вернул обратно незабагованный код в директорию src.

</details>

<details>
  <summary>HomeWork 25 - Введение в Kubernetes</summary>

## HomeWork 25 - Введение в Kubernetes

- Подготовил Deployment-манифесты для post/comment/ui/mongo

### Kubernetes - The Hard Way

<https://github.com/kelseyhightower/kubernetes-the-hard-way>

- Развернул кластер по гайду и запустил деплойменты

```bash
kubectl get pods -o wide
NAME                                  READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE
busybox-bd8fb7cbd-5pkch               1/1     Running   0          29m   10.200.0.2   worker-0   <none>
comment-deployment-69c487c659-zdjd7   1/1     Running   0          23m   10.200.1.3   worker-1   <none>
mongo-deployment-6895dffdf4-dk74b     1/1     Running   0          22m   10.200.2.4   worker-2   <none>
nginx-dbddb74b8-x6tkp                 1/1     Running   0          28m   10.200.0.3   worker-0   <none>
post-deployment-65899c6d8c-95gtj      1/1     Running   0          22m   10.200.1.4   worker-1   <none>
ui-deployment-6698c98b75-lml5k        1/1     Running   0          22m   10.200.0.4   worker-0   <none>
untrusted                             1/1     Running   0          24m   10.200.2.3   worker-2   <none>
```

- Удалил все ресурсы созданные при прохождении гайда

</details>

<details>
  <summary>HomeWork 26 - Основные модели безопасности и контроллеры в Kubernetes</summary>

## HomeWork 26 - Основные модели безопасности и контроллеры в Kubernetes

- Установлен kubectl `brew install kubernetes-cli` <https://kubernetes.io/docs/tasks/tools/install-kubectl/>
- Установлен minikube `brew cask install minikube`
- Запустил minikube-кластер `minikube start`
- Убедился что кластер доступен `kubectl get nodes`

### Deployment

#### UI

- Обновил файл ui-deployment.yml
- Запустил ui в minikube `kubectl apply -f ui-deployment.yml`
- Убедился что количество реплик соответствует заданному `kubectl get deployment`
- Получил поды приложения через селектор `kubectl get pods --selector component=ui`
- Запустил порт-форвардинг для пода `kubectl port-forward ui-5d79c5dc6-66x8x 8080:9292`
- Проверил что web-интерфейс приложения открывается

#### Comment

- обновил deployment-файл для сервиса comment
- запустил сервис `kubectl apply -f comment-deployment.yml`
- убедился что поды прилоежния доступны `kubectl get pods --selector component=comment`
- проверил доступность сервиса пробросив порт `kubectl port-forward comment-7d6dc6b87d-2mzcm 8080:9292`

#### Post

- обновил deployment-файл по аналогии с comment и ui
- запустил сервис `kubectl apply -f post-deployment.yml`
- проверил наличие подов `kubectl get pods --selector component=post`
- Проверил работоспособность `kubectl port-forward post-6966855766-mxj4k 8080:5000`

#### MongoDB

- обновил deployment-файл
- Добавил монтирование Volume

### Services

- Добавлен service-файл для микросервиса comment
- запустил создание сервиса через `kubectl apply -f comment-service.yml`
- убедился в том, что создались эндпоинты для подов comment `kubectl describe service comment | grep Endpoints`
- Проверил что имя comment резолвится из подов `kubectl exec -ti post-6966855766-mxj4k nslookup comment`
- создал сервис-файл post-service.yml и запустил `kubectl apply -f post-service.yml`
- проверил эндопоинты для подов post `kubectl describe service post | grep Endpoints`
- Добавил и запустил service для mongodb `kubectl apply -f mongodb-service.yml`
- Оказывается, что сервисы не могут достучаться до mongodb
- Добавлен service для comment_db с лейблом `comment_db: "true"`
- В mongo-deployment.yml так же добавлен лейбл `comment_db: "true"` в метадату деплоймента и в метадату пода
- Для подов comment добавлена переменная окружений `COMMENT_DATABASE_HOST: comment_db`
- По аналогии с comment_db добавлен сервис, лейблы и переменная окружения для post_db
- Обновил / применил новые манифесты `kubectl apply -f .`
- Проверил логи, убедился что обращение идет к нужным базам
- Удалил объект mongodb service `kubectl delete -f mongodb-service.yml` `kubectl delete service mongodb`
- Для обеспечения доступа к UI добавлен сервис ui-service.yml с типом NodePort
- В ui-service.yml добавлен параметр `nodePort: 32092`

### Minikube

- Страница с UI сервисом доступна `minikube service ui`
- Список сервисов доступен `minikube service list`
- Список расширений / аддонов `minikube addons list`
- Список запущенных подов в namespace default `kubectl get pods`
- Получены все объекты для аддона dashboard из неймспейса kube-system `kubectl get all -n kube-system --selector app=kubernetes-dashboard`

### Dashboard

- Запущен дашборд `minikube dashboard`
- Изучен функционал

### Namespace

- Добавлено описание для создания отдельного неймспейса для среды разработки dev-namespace.yml и применены изменений `kubectl apply -f dev-namespace.yml`
- Приложение запущено в новом неймспейса `kubectl apply -n dev -f .`
- По причиние возникновения конфликта портов из ui-service.yml убран параметр NodePort
- Обновил ui-service `kubectl apply -n dev -f ui-service.yml`
- Убедился что страница UI-сервиса открывается `minikube service ui -n dev`
- В ui-deployment.yml добавлена информация об окружениях, в которых будет запускаться контейнеры
- Применил изменения для ui `kubectl apply -n dev -f ui-deployment.yml`
- Убедился, что теперь в заголовке страницы корректно отображается навзание окружения `Microservices Reddit in dev ui-ff5c4db7f-6b2kl container
`

### Google Kubernetes Engine

- Запущено создание кластера Kubernetes через web-консоль Google Cloud
- Подготовлен контекст для подключения к кластеру `gcloud container clusters get-credentials your-first-cluster-1 --zone europe-west3-b --project docker-123456`
- Убедился что в качестве текущего контекста выставлен контекст для подключения к кластеру GKE `kubectl config current-context`
- Создан dev namespace `kubectl apply -f ./kubernetes/reddit/dev-namespace.yml`
- Приложение задеплоено в namespace dev `kubectl apply -f ./kubernetes/reddit/ -n dev`
- Добавлено правило разрешающее доступ по портам 30000-32767
- Получены внешние адреса нод кластера `kubectl get nodes -o wide`
- Получен порт публикации сервиса ui `kubectl describe service ui -n dev | grep NodePort`
- Убедился, что сервис доступен по адресу `http://<node-ip>:<NodePort>`

<details>
  <summary>proofpic</summary>

![reddit](https://www.dropbox.com/s/mnxb6wjk1xqpdzf/reddit_gke.png?raw=1)

</details>

- Для кластера в GKE включен Dashboard (Cluster - Edit - Addons - Dashboard)
- Запустил kubectl proxy, ui доступен <http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login>
- Добавлены права для сервисного аккаунта `kubectl create clusterrolebinding kubernetes-dashboard  --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard`
- Залогинился с токеном из `kubectl config view`

### HW26: Задание со *

- Подготовил сценарий создания кластера при помощи terraform согласно рекомендациям.
- Получил манифест для добавления прав доступа на kubernetes dashboard `kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard -o yaml --dry-run`

<details>
  <summary>dashboard manifest</summary>

```bash
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  creationTimestamp: null
  name: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kube-system
```

</details>

</details>

<details>
  <summary>HomeWork 27 - Kubernetes. Networks, storages</summary>

## HomeWork 27 - Kubernetes. Networks, storages

### Сетевое взаимодействие

#### Kube-DNS

- Проскейлен в 0 сервис, который следит за количеством kube-dns подов `kubectl scale deployment --replicas 0 -n kube-system kube-dns-autoscaler`
- Проскейлен в 0 kube-dns `kubectl scale deployment --replicas 0 -n kube-system kube-dns`
- Проверена невозможность достучаться по имени до сервиса comment из пода ui `kubectl exec -ti -n dev ui-8668977c86-9c2jg ping comment`, доступа нет `ping: bad address 'comment'`
- Kube-dns-autoscaler возвращен в исходное состояние `kubectl scale deployment --replicas 1 -n kube-system kube-dns-autoscaler`
- Проверил что в бразуере все работает корректно

#### LoadBalancer

- Обновил UI-деплоймент добавив туда LoadBalancer и прописанный NodePort
- Обновил компонент UI `kubectl apply -f ui-service.yml -n dev`
- Получил информацию о созданном LoadBlancer для UI

<details>
  <summary>kubectl get service -n dev --selector component=ui</summary>

```bash
NAME   TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
ui     LoadBalancer   10.31.246.101   35.234.98.129   80:32092/TCP   18h
```

</details>

- Проверил подключение через браузер сразу на 80 порт

#### Ingress

- Добавлен и применен конфиг Ingress для сервиса UI `kubectl apply -f ui-ingress.yml -n dev`
- Из консоли GCP получена информация о порте сервиса, на который направлен Ingress `Named port: port32092`
- Получен адрес Ingress

<details>
  <summary>kubectl get ingress -n dev</summary>

```bash
NAME   HOSTS   ADDRESS         PORTS   AGE
ui     *       130.211.12.16   80      4m47s
```

</details>

- Убран балансировщик Google из ui-service.yml
- Изменен ui-ingress для того, чтобы он работал как классический web-балансировщик

#### Secret

- Подготовлен сертификат `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=130.211.12.16"`
- Сертификат загружен в Кубернетес `kubectl create secret tls ui-ingress --key tls.key --cert tls.crt -n dev`
- Секрет действительно создался `kubectl describe secret ui-ingress -n dev`

#### TLS Termination

- Ingress настроен только на прием HTTPS
- В Web-консоли видно, что в описании баланщировщика есть только HTTPS

#### HW 27: Задание со *

- Подготовлен манифест для создания объекта Secret используемого в Ingress `kubectl create secret tls ui-ingress --key tls.key --cert tls.crt -n dev -o yaml --dry-run > ui-ingress-secret.yml`

<details>
  <summary>ui ungress secret</summary>

```yaml
apiVersion: v1
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNyakNDQVpZQ0NRQ3hXRW1QL1A5c0RqQU5CZ2txaGtpRzl3MEJBUXNGQURBWk1SY3dGUVlEVlFRRERBNHgKTXpBdU1qRXhMakV5TGpFMkNqQWVGdzB4T1RBM01qWXhOREV5TWpWYUZ3MHlNREEzTWpVeE5ERXlNalZhTUJreApGekFWQmdOVkJBTU1EakV6TUM0eU1URXVNVEl1TVRZS01JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBCk1JSUJDZ0tDQVFFQXkxWVc5MXBFR0t5cFFsSUp5aWVyKzNHVEYwdWcrNy9yTlh3aWY2RG9BNGFsdjdqNENMd1cKeEJuWnFoRTFNcXM1Njl1OXhCeHZmb1lUMzVKekkva2NXMU9lcDJPWDRKRklTKzR4MmVqRndlZjRoUDVldmZvTAptcUpxR280U0tURXhHSlRxNmdvV0p0a3R5R0ZIUUZyWXArbm4vb3lxVktRQXFmYWZURmhUdkI2TFlpMzZOTGhZClNhM1ZTTmNVTU9Xb3dYNkczdnEyRzdUVGZRbEZSYWw1YkJzMHhTWmh2YUdMUlFQNCtFMWlmbFlkbE5jRzZ6OUMKTURXWGozUzZmdGcxNEtWeGI0Rm95Z28yQ3NpSGFGekR1bm1oMm9tKzEvQjg3TmpkcWNxbE1YQUNhV1VJbjJsUwoxbjB4MXlKTmlmVURjdWFJbEtYcGRHNWZYUWZyVGxDTzN3SURBUUFCTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCCkFRRExUMlVtejRoaWE1R1M5RW5XY0liajQ4Wno1VjBSRGZCZ20xd0YvV1hJT1lYU3FxaUMvalREbVprRmVSSEYKVDc0RmMrZDVLWE5HZDBCVHBsMzV0TlBRNVRvdGQxVVFITjA1d0lhdU1oMldWZTA2RzhVbm1KTzdwWkQrZElQawpBT2hUYVFWU3Y2YUF5QUlIUWFJWEt0Wkl6VURsc244RkczZVVxMGtIOW43NlRMT24rSjlhOTAwdTZNYWJFSEc3ClVrQ2c4T2Naa0hoRHlOMG9Bd0NHOWhjUFRsbGhBaitibWZrT2NzT0h5U0tHL1BmTjVyUW52dE1tZkFkb21CalcKN0lUMUtLaDc2UlRCNkN6aE85VndXTEF4dlZCdHZoMERCYy9RMWcyREsrL3VTa1NDaUtJZk1FTHhFS1NzdExLbAp4bXdtTWNmamkrcll5ZzV6Z2lWSUpLR0MKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
  tls.key: LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2d0lCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktrd2dnU2xBZ0VBQW9JQkFRRExWaGIzV2tRWXJLbEMKVWduS0o2djdjWk1YUzZEN3YrczFmQ0ovb09nRGhxVy91UGdJdkJiRUdkbXFFVFV5cXpucjI3M0VIRzkraGhQZgprbk1qK1J4YlU1Nm5ZNWZna1VoTDdqSFo2TVhCNS9pRS9sNjkrZ3Vhb21vYWpoSXBNVEVZbE9ycUNoWW0yUzNJCllVZEFXdGluNmVmK2pLcFVwQUNwOXA5TVdGTzhIb3RpTGZvMHVGaEpyZFZJMXhRdzVhakJmb2JlK3JZYnROTjkKQ1VWRnFYbHNHelRGSm1HOW9ZdEZBL2o0VFdKK1ZoMlUxd2JyUDBJd05aZVBkTHArMkRYZ3BYRnZnV2pLQ2pZSwp5SWRvWE1PNmVhSGFpYjdYOEh6czJOMnB5cVV4Y0FKcFpRaWZhVkxXZlRIWElrMko5UU55NW9pVXBlbDBibDlkCkIrdE9VSTdmQWdNQkFBRUNnZ0VCQU1HUTdzUUIxaGwzSkpuUjV5ZmVwRVgxVklVMHBjZUNaN0srdlVpcU1MUksKbGJieHFvMEdJTllGbGNQa0piUmFkQVVuWm5zdVpxVVhsZ3ViS3Fqd0dDS0ljOXY5WHpPVW1qSk9TbjZhck1kdQp3Skk2Wkk2TlhrYVNubGN4TC9DdXQ0SWpJWTR5ayt2Zmkwblo4UzQrVFVscnprSHdQcVhjaWhWQ2hWcjBLcUpFCjd3TDNSQ0hiOGNSTi8zdy9XWTBENjNZcWNEcGVPcWJ3YWdaL1ZZVy9MdlBmbUNnandwRnBwaHNpaFZMMWhWeGYKeUpGOTlwV2g2NUtCWDVIVkp2YkpCU0drbUhtLzNtUnhNR3BPQVY0b0ZsS3hUNlZiZUJBNnVtcVNDL1BTS1FraApXRkJMQy81ZFI1UU5Jc2R5TkFDWkRucFBxWHRtUDdqMW5Kd3RSanFhckVFQ2dZRUE2V2RuUVhHTjIwM3lrZDFmCmNZbVd1TG44ZHk5UFZsc0xFcVdTYWR6WHJJRlNtMUMzZE5OS2pPV0pVUHgxNFE3b2pwb0c2VjVGNis3aEdNVlIKZmdRUktJL0E2OE0rS2pHUkpackFUODExMXkvTUtaT2pRaUdjbmZ1ZHN4U2lDVG91aW1hMVVVZ3ZFeHJlRmNwQgppZFJMbnNaV1c1eTJsMnFVMmExbzNITFdZcGNDZ1lFQTN3V0FWQXVJU3RzUjNJUFFMYWhCR1dId0swWWF6TzRJCm1qbXhaMVJROS8xaXphYUxOZ2hHNlJUZ3FlWG0zZ1A3SnpWN0F2WnRscFBlaGdmNi9MOGZnUlhVZ3FqZEdtK0IKdWhycktyUVhOZFVsa3RiZHN6MGl6T0haajlSUEM4S3dzbElVcUZFUk9VOU9kWGZiU09CbDJ4bDFHQ2orNGt5WQorbTFpcmZ4aDV2a0NnWUI1OHg4T0lJaWY1eEF3aWx2TjlMZWRlUCtpUGtQVHVPb0dLaUJmMDVXVWVsVnc5VEdGCmhzaFM2Yk5mYnlrZ0dDd0dKaEFxYXFsWjVvd1I1emIzQXFUOGJtKzhQMTBCcXJoTno1ZGZtdGhSUUpZSnV5djMKNTV2dko0SjBDUG5Jbkcrb3ZKVk1ETTBiekZQeFNxWUhuN2FMRk5JV044Rm5SN2JTTFRxMnhBR2pyUUtCZ1FDSQpZTWpVbkNpLy9hNnlkamg3Y3dROERWUGNZb1pKQXRabjJSZk81QlNQVVhkMTRuNEdrSkVzUHdRVFlPOEluTTZjCmIydkZxQVBqckpES3pWNkI2QzNQdGhXNXdLRlVaUk9qUm9yQUZsaUxKc2hQUHUxYmllc1o5cElnRGVnNGZObW8KY2VFSC9Hclg3Tk5CcWdXQ1R4WjZJTnNsNXd2V1BwamRxcjVKUHFodm9RS0JnUURiVloralBodXRHdCtOcWtWdgppaEU5SnNPZittN0JHWVdsazZiRCtPNm1Kb2RaRTlLL01XV09ySEVTMDVpU0Uwc2VKZFdzdHErUlpmdVg3ekloCklBbmh4bGZCVUpFUTBjOGRXVWgyV0g5d2c0UVJsLzV6NHJhczluN08yN1daZnR5bVdrTVdIK2svakowbGR5clIKSHZJM1c2dzN1RGhMdWUrRVoxYkpGMXgyb2c9PQotLS0tLUVORCBQUklWQVRFIEtFWS0tLS0tCg==
kind: Secret
metadata:
  creationTimestamp: null
  name: ui-ingress
  namespace: dev
type: kubernetes.io/tls

```

</details>

#### Network Policy

- Получено имя контейнера `gcloud beta container clusters list`
- Активирован Addon NetworkPolicy `gcloud beta container clusters update reddit-gke --zone=europe-west3-b --update-addons=NetworkPolicy=ENABLED`
- Включена NetworkPolicy для кластера `gcloud beta container clusters update reddit-gke --zone=europe-west3-b  --enable-network-policy`
- Добавлена политика доступа к mongodb `mongo-network-policy.yml`
- Применена политика доступа к монго, доступ с comment есть, доступа с post нет
- В политику добавлен селектор для подов post

<details>
  <summary>podSelector post</summary>

```yaml
- podSelector:
    matchLabels:
      app: reddit
      component: post
```

</details>

### Хранилища

#### Volume

- Создан диск в Google Cloud `gcloud compute disks create --size=25GB --zone=europe-west3-b reddit-mongo-disk`
- В mongo-deployment добавлен volume для пода и применены ихменения `kubectl apply -f mongo-deployment.yml -n dev`
- Добавлен пост в web-интерфейсе и пересоздан деплоймент монго `kubectl delete deploy mongo -n dev` и `kubectl apply -f mongo-deployment.yml -n dev`
- Пост сохранился!

#### PersistentVolume

- В mongo-volume.yml добавлено описание persistentVolume и он добавлен в кластер `kubectl apply -f mongo-volume.yml -n dev`

#### PersistentVolumeClaim

- Добавлено описание PVC (запрос на место) mongo-claim.yml и выполнено добавление в кластер `kubectl apply -f mongo-claim.yml -n dev`
- Получено описание стандартного StorageClass, используемого для создания PV если он не будет найден по заданным параметрам или будет занят другим Claim `kubectl describe storageclass standard -n dev`
- PVC подключен к поду монго в mongo-deployment.yml

#### Динамическое выделение Volume

- Добавлено описание StorageClass для ssd дисков в storage-fast.yml
- Добавлено описание PVC, ссылающееся на созданный StorageClass
- Динамический PVC добавлен к подам монго в mongo-deployment.yml
- Получен список созданных PersistentVolume `kubectl get persistentvolume -n dev`

</details>

<details>
  <summary>HomeWork 28 - CI/CD в Kubernetes</summary>

## HomeWork 28 - CI/CD в Kubernetes

- Пересоздан кластер без деплоя компонентов
- Добавлен namespace dev `kubectl apply -f ./kubernetes/reddit/dev-namespace.yml`

### Helm

- Установлен клиент Helm `brew install kubernetes-helm`
- Подготовлен манифест для Tiller `kubectl apply -f tiller.yml`
- Запущен Tiller-сервер `helm init --service-account tiller`
- Проверено создание tiller-сервера (пода) `kubectl get pods -n kube-system --selector app=helm`

#### Charts

- Подготовлены директории для helm charts
- Создано описание чарта для UI

#### Templates

- Все ui-related манифесты перенесены в Charts/ui/templates
- Запущена установка `helm install --name test-ui-1 ./Charts/ui`

<details>
  <summary>helm install --name test-ui-1 ./Charts/ui</summary>

```bash
helm install --name test-ui-1 Charts/ui
NAME:   test-ui-1
LAST DEPLOYED: Sat Jul 27 14:28:39 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Pod(related)
NAME                 READY  STATUS             RESTARTS  AGE
ui-8668977c86-84rrw  0/1    ContainerCreating  0         0s
ui-8668977c86-d5vsv  0/1    ContainerCreating  0         0s
ui-8668977c86-l6pg7  0/1    ContainerCreating  0         0s

==> v1/Secret
NAME        TYPE               DATA  AGE
ui-ingress  kubernetes.io/tls  2     0s

==> v1/Service
NAME  TYPE      CLUSTER-IP     EXTERNAL-IP  PORT(S)         AGE
ui    NodePort  10.31.243.198  <none>       9292:31213/TCP  0s

==> v1beta1/Ingress
NAME  HOSTS  ADDRESS  PORTS  AGE
ui    *      80, 443  0s

==> v1beta2/Deployment
NAME  READY  UP-TO-DATE  AVAILABLE  AGE
ui    0/3    3           0          0s
```

</details>

- Выведен список установленный helm charts `helm ls`

<details>
  <summary>helm ls</summary>

```bash
helm ls
NAME     	REVISION	UPDATED                 	STATUS  	CHART   	APP VERSION	NAMESPACE
test-ui-1	1       	Sat Jul 27 14:28:39 2019	DEPLOYED	ui-1.0.0	1          	default
```

</details>

- Шаблонизированы ui/templates/service.yaml, ui/templates/deployment.yaml, ui/templates/ingress.yaml
- Добавлен файл со значениями переменных ui/values.yaml
- Установлены три релиза `helm install ui --name ui-1 && helm install ui --name ui-2 && helm install ui --name ui-3`
- Получены данные о созданных ингрессах `kubectl get ingress`

<details>
  <summary>kubectl get ingress</summary>

```bash
 kubectl get ingress
NAME      HOSTS   ADDRESS         PORTS   AGE
ui-1-ui   *       35.244.187.59   80      9m5s
ui-2-ui   *       130.211.12.16   80      9m2s
ui-3-ui   *       34.98.107.115   80      8m58s
```

</details>

- Кастомизированы ui/templates/deployment.yaml, ui/templates/service.yaml и ui/templates/ingress.yaml
- Выполнен апгрейд для всех трех инсталляций `helm upgrade ui-1 ui/ && helm upgrade ui-2 ui/ && helm upgrade ui-3 ui/`
- Подготовлен пакет для сервиса post
- Подготовлен пакет для сервиса comment
- Для сервиса comment добавлен helper
- Хелперы добавлены в чарты для всех сервисов, в шаблоны манифестов добавлено использование хелпера

#### Управление зависимостями

- Создан reddit/Chart.yaml, reddit/values.yaml и reddit/requirements.yaml
- Выполнена загрузка зависимостей `helm dep update`
- Выполнен поиск чартов в открытом доступе `helm search mongo`
- В reddit\requirements.yaml добавлен пакет mongo и обновлены зависимости `helm dep update`
- Выполнил установку приложения `helm install reddit --name reddit-test`
- Главная страница приложения запускается, но UI не может получить доступ к базе данных
- В ui/deployment.yaml добавлены описания переменных окружения
- В values для ui добавлены переменные postHost, postPort, commentHost, commentPort
- Так же "перезаписывающие" значниея переменных добавлены в reddit/values.yaml
- Выполнено обновление зависимостей `helm dep update ./reddit`
- Выполнен апгрейд приложения в k8s `helm upgrade reddit-test ./reddit/`
- Проблема с дотсупом к базе решилась

### GitLab + Kubernetes

- Через web-интерфейс GCP к кластеру добавлен еще один node pool состоящий из одной машины n1-standard-2
- В параметрах кластера включено Legacy Authorization
- Добавлен репозиторий чартов гитлаб `helm repo add gitlab https://charts.gitlab.io`
- Загружен чарт gitlab-omnibus `helm fetch gitlab/gitlab-omnibus --version 0.1.37 --untar`
- Внесены изменения в gitlab-omnibus/values.yaml
- Внесены изменения в gitlab-omnibus/templates/gitlab/gitlabsvc.yaml
- Внесены изменения в gitlab-omnibus/templates/gitlab-config.yaml
- Внесены изменения в gitlab-omnibus/templates/ingress/gitlab-ingress.yaml
- Запущена установка gitlab `helm install --name gitlab . -f values.yaml`
- Получен адрес `kubectl get service -n nginx-ingress nginx`
- В /etc/hosts внесена запись для развернутого GitLab `echo "35.234.64.25 gitlab-gitlab staging production” >> /etc/hosts`
- Залогинился в Gitlab
- Создана группа http://gitlab-gitlab/darkarren
- В Settings - CI/CD добавлены переменные CI_REGISTRY_USER и CI_REGISTRY_PASSWORD
- Создан проект deploy-reddit
- Добавлены проекты ui, comment, post
- Исходный код сервисов скопирован в локальную директорию Gitlab_ci
- Код сервисов загружен в соответсвующие репозитории в GitLab
- Чарты перенесены в директорию reddit и загружены в Gitlab в проект reddit-deploy
- В репозитории сервисов загружены пайплайны gitlab-ci
- Обновлены ui/templates/ingress.yaml и ui/values.yaml
- Проверена возможность деплоить в отдельное окружение из бранчей
- Добавлены staging и production среды для приложения

</details>

<details>
  <summary>HomeWork 29 - Kubernetes. Мониторинг и логирование</summary>

## HomeWork 29 - Kubernetes. Мониторинг и логирование

- Для кластера отключен Stackdriver Monitoring и Stackdriver Logging
- Установлен nginx `helm install stable/nginx-ingress --name nginx`
- Получен адрес nginx `kubectl get svc` и добавлен в /etc/hosts

### Мониторинг

- Загружен helm chart prometheus `helm fetch --untar stable/prometheus`
- Для prometheus добавлены кастомные значения переменных в custom_values.yaml
- Выполнена установка prometheus `helm upgrade prom . -f custom_values.yml --install`
- В custom_values.yml для prometheus включен сервис kube-state-metrics, релиз обновлен и запущен `helm upgrade prom . -f custom_values.yml --install`
- В Targets появились "kubernetes_service_endpoints" и добавились метрики "kube_*"
- В custom_values.yml включены поды node_exporter, в Targets появились три новых эндпоинта с метками "node-exporter"
- Выполнена установка приложения reddit

```bash
helm upgrade reddit-test ./reddit --install
helm upgrade production --namespace production ./reddit --install
helm upgrade staging --namespace staging ./reddit --install
```

- Добавлен servicediscovery приложений, запущенных в k8s, по метке reddit, в Targets отбразились reddit-endpoints
- Добавлен mapping лейблов, у эндпоинтов появились лейблы app/component/instance/relese
- Добавлены лейблы на основе лейблов __meta_kubernetes_namespace и __meta_kubernetes_service_name
- Добавлен аналогичный job, для подов из неймспейса production
- Конфигурация `reddit-endpoints` разделена на три отдельных для post \ comment \ ui

### Визуализация

- Установлена Grafana

```bash
helm upgrade --install grafana stable/grafana --set "adminPassword=admin" \
--set "service.type=NodePort" \
--set "ingress.enabled=true" \
--set "ingress.hosts={reddit-grafana}"
```

- Добавлен Datasource Prometheus
- Добавлен Dashboard `Kubernetes cluster monitoring (via Prometheus)`
- Добавлены дашборды из задания по мониторингу
- Параметризированы все дашбордыы, отражающие параметры работы приложения reddit для работы с несколькими окружениями(неймспейсами). Сохранены в `kubernetes/monitoring/grafana`

</details>
