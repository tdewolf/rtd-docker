#!/bin/bash

python manage.py syncdb --noinput
python manage.py migrate
python manage.py loaddata test_data
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'admin')" | python manage.py shell
cat elasticsearch_setup.py | python manage.py shell
cd ..
