#/bin/bash

echo Start update script

# Pull changes
echo Pull changes
git pull origin master

# install python packages
echo Install python packages

env/bin/python -m pip install --upgrade pip
env/bin/python -m pip install -r requirements.txt

# Collect static Web App
echo Collect static Web App

env/bin/python manage.py collectstatic --noinput

# Aplying migrations
echo Aplying migrations

env/bin/python manage.py migrate

# Restart gunicorn service
echo Restart gunicorn service

systemctl restart gunicorn.socket
systemctl restart gunicorn.service

# Restart NGINX
echo Restart NGINX

systemctl restart nginx

echo End initial script



