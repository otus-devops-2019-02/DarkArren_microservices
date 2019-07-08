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

<details>

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
