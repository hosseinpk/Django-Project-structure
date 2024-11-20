#!/bin/bash


read -p 'Enter project name: ' prj_name
echo

if [ ! -e venv  ];then
	python3 -m venv venv	
	source venv/bin/activate
fi
python -m pip install --upgrade pip
pip install --no-cache-dir -r requirements.txt
django-admin startproject $prj_name
cd $prj_name
echo "\n"
read -p "Do you need 'accounts' app: (yes/no)" create_accounts
if [[ "$create_accounts" =~ ^[Yy]([Ee][Ss])?$ ]]; then
	python manage.py startapp accounts
	echo "'accounts' app has been created."
    touch accounts/urls.py
    mkdir -p accounts/api/v1
    touch accounts/api/__init__.py
    touch accounts/api/v1/__init__.py accounts/api/v1/serializers.py accounts/api/v1/urls.py accounts/api/v1/validators.py accounts/api/v1/views.py
    echo "'accounts' app structure created."
    if grep -q "INSTALLED_APPS" "$prj_name/settings.py"; then
            sed -i "/INSTALLED_APPS = \[/a \ \ \ \ 'accounts'," "$prj_name/settings.py"
            echo "App 'accounts' added to INSTALLED_APPS."
        fi
        project_urls="$prj_name/urls.py"
        if ! grep -q "path('$app_name/', include('accounts.urls'))," "$project_urls"; then
            sed -i "s/from django.urls import path/from django.urls import path, include/" "$project_urls"
            sed -i "/urlpatterns = \[/a \ \ \ \ path('accounts/', include('accounts.urls'))," "$project_urls"
            echo "App 'accounts' URLs added to $prj_name/urls.py."
        fi
        cat <<EOF > "accounts/urls.py"
from django.urls import path

urlpatterns = [
    path(),
]
EOF
echo "Basic URLs for app 'accounts' created."

fi

while true; do
    read -p "Do you need more apps? (yes/no): " create_app
    if [[ "$create_app" =~ ^[Nn][Oo]?$ ]]; then
        echo "No more apps will be created."
        break
    elif [[ "$create_app" =~ ^[Yy]([Ee][Ss])?$ ]]; then
        read -p "Enter app name: " app_name
        python manage.py startapp "$app_name"
        echo "App '$app_name' created successfully."
        touch "$app_name"/urls.py
        mkdir -p "$app_name"/api/v1
        touch "$app_name"/api/__init__.py
        touch "$app_name"/api/v1/__init__.py "$app_name"/api/v1/serializers.py "$app_name"/api/v1/urls.py "$app_name"/api/v1/validators.py "$app_name"/api/v1/views.py
        echo "Structure for app '$app_name' created."
        if grep -q "INSTALLED_APPS" "$prj_name/settings.py"; then
            sed -i "/INSTALLED_APPS = \[/a \ \ \ \ '$app_name'," "$prj_name/settings.py"
            echo "App '$app_name' added to INSTALLED_APPS."
        fi
        project_urls="$prj_name/urls.py"
        if ! grep -q "path('$app_name/', include('$app_name.urls'))," "$project_urls"; then
            sed -i "/urlpatterns = \[/a \ \ \ \ path('$app_name/', include('$app_name.urls'))," "$project_urls"
            echo "App '$app_name' URLs added to $prj_name/urls.py."
        fi
                cat <<EOF > "$app_name/urls.py"
from django.urls import path

urlpatterns = [
    path(),
]
EOF
echo "Basic URLs for app '$app_name' created."

    else
        echo "Invalid input. Please enter 'yes' or 'no'."
    fi
done
cd ..


read -p "Do you need Dockerfile? (yes/no): " docker_file
if [[ "$docker_file" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    cat <<EOF > Dockerfile
FROM python:3.11-slim-buster
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1
RUN python -m pip install --upgrade pip
COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt
COPY ./$prj_name /app
EOF
    echo "Dockerfile created successfully."
fi


read -p "Do you need a basic docker-compose file? (yes/no): " compose_file
if [[ "$compose_file" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    cat <<EOF > docker-compose.yml
services:
  django:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - ./core:/app
    ports:
      - 8000:8000
    environment:
      - SECRET_KEY=\${SECRET_KEY}
      - DEBUG=\${DEBUG}
    networks:
      - social

networks:
  social:
    name: social
EOF
    echo "docker-compose.yml created successfully."
fi

echo "done"