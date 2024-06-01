# Используем официальный базовый образ Ubuntu
FROM ubuntu:20.04

# Указываем автора образа
MAINTAINER Alexander Reutin <sanek2281337@example.com>

# Устанавливаем переменную окружения для неинтерактивной установки
ENV DEBIAN_FRONTEND=noninteractive

# Обновляем списки пакетов и устанавливаем необходимые пакеты
RUN apt-get update && \
    apt-get install -y apache2 postgresql postgresql-contrib && \
    apt-get clean

# Копируем файл конфигурации Apache в контейнер
COPY /apache2.conf /etc/apache2/apache2.conf

# Добавляем содержимое нашего веб-приложения в рабочую директорию
ADD /html /var/www/html

# Создаем и назначаем рабочую директорию для нашего приложения
WORKDIR /var/www/html

# Устанавливаем права на директорию базы данных
RUN mkdir -p /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/lib/postgresql

# Определяем том для хранения данных базы данных, чтобы данные не терялись при перезапуске контейнера
VOLUME /var/lib/postgresql/data

# Определяем пользователя, от имени которого будут запускаться команды внутри контейнера
USER root

# Открываем порты 80 (HTTP) и 5432 (PostgreSQL)
EXPOSE 80 5432

# Указываем команду для запуска Apache и PostgreSQL при старте контейнера
CMD service postgresql start && apachectl -D FOREGROUND