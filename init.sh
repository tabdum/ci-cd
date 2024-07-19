#/bin/bash

echo Start initial script

# install system packages
echo Install system packages

apt update -y && apt upgrade -y
apt install -y postgresql nginx python3-venv

# set environment variables
echo Set environment variables

export $(cat .env | xargs)

# Creating a database
echo Creating a database

sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password '${DB_PASSWORD}';"
sudo -u postgres psql -U postgres -d postgres -c "create database ${DB_NAME};"

# install python packages
echo Install python packages

python3 -m venv env
env/bin/python -m pip install --upgrade pip
env/bin/python -m pip install -r requirements.txt

# Collect static Web App
echo Collect static Web App

env/bin/python manage.py collectstatic

# Aplying migrations
echo Aplying migrations

env/bin/python manage.py migrate

# Create gunicorn service
echo Create gunicorn service

cp config/service/gunicorn.service /etc/systemd/system
cp config/service/gunicorn.socket /etc/systemd/system

# Start gunicorn service
echo Start gunicorn service

systemctl daemon-reload

systemctl enable gunicorn.socket
systemctl start gunicorn.socket

systemctl enable gunicorn.service
systemctl start gunicorn.service

# Aplying settings NGINX
echo Aplying settings NGINX

cp config/nginx/django_project.conf /etc/nginx/sites-available
[ -e /etc/nginx/sites-enabled/default ] && rm /etc/nginx/sites-enabled/default
[ -e /etc/nginx/sites-enabled/django_project.conf ] && rm /etc/nginx/sites-enabled/django_project.conf
ln -s /etc/nginx/sites-available/django_project.conf /etc/nginx/sites-enabled
systemctl restart nginx

echo End initial script



