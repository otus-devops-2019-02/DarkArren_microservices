# DarkArren_microservices

DarkArren microservices repository

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
