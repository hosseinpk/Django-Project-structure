#!/bin/bash


setup_venv() {
    if [ ! -e venv ]; then
        python3 -m venv venv
        echo "Virtual environment created."
    fi
    source venv/bin/activate
    echo "Virtual environment activated."
}


add_app() {
    local app_name="$1"
    echo "Creating app: $app_name"
    python manage.py startapp "$app_name"

    
    mkdir -p "$app_name/api/v1"
    touch "$app_name/urls.py" "$app_name/api/__init__.py" \
          "$app_name/api/v1/__init__.py" "$app_name/api/v1/serializers.py" \
          "$app_name/api/v1/urls.py" "$app_name/api/v1/validators.py" \
          "$app_name/api/v1/views.py"
    echo "Structure for app '$app_name' created."

    
    if grep -q "INSTALLED_APPS" "$settings_file"; then
        if ! grep -q "'$app_name'," "$settings_file"; then
            sed -i "/INSTALLED_APPS = \[/a \ \ \ \ '$app_name'," "$settings_file"
            echo "App '$app_name' added to INSTALLED_APPS."
        else
            echo "App '$app_name' is already in INSTALLED_APPS."
        fi
    fi

    
    if ! grep -q "path('$app_name/', include('$app_name.urls'))," "$urls_file"; then
        sed -i "s/from django.urls import path/from django.urls import path, include/" "$urls_file"
        sed -i "/urlpatterns = \[/a \ \ \ \ path('$app_name/', include('$app_name.urls'))," "$urls_file"
        echo "App '$app_name' URLs added to $urls_file."
    fi


    cat <<EOF > "$app_name/urls.py"
from django.urls import path
from django.http import HttpResponse

urlpatterns = [
    path('', lambda request: HttpResponse('<h1>Welcome to $app_name</h1>')),
]
EOF
    echo "Basic URLs for app '$app_name' created."
}


create_dockerfile() {
    cat <<EOF > Dockerfile
FROM python:3.11-slim-buster
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1
RUN python -m pip install --upgrade pip
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EOF
    echo "Dockerfile created successfully."
}


create_docker_compose() {
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
}


read -p 'Enter project name: ' prj_name
settings_file="$prj_name/settings.py"
urls_file="$prj_name/urls.py"


setup_venv


python -m pip install --upgrade pip
pip install --no-cache-dir -r requirements.txt


django-admin startproject "$prj_name"
cd "$prj_name" || exit


read -p "Do you need 'accounts' app? (yes/no): " create_accounts
if [[ "$create_accounts" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    add_app "accounts"
fi


while true; do
    read -p "Do you need more apps? (yes/no): " create_app
    if [[ "$create_app" =~ ^[Nn][Oo]?$ ]]; then
        echo "No more apps will be created."
        break
    elif [[ "$create_app" =~ ^[Yy]([Ee][Ss])?$ ]]; then
        read -p "Enter app name: " app_name
        add_app "$app_name"
    else
        echo "Invalid input. Please enter 'yes' or 'no'."
    fi
done


read -p "Do you need Dockerfile? (yes/no): " docker_file
if [[ "$docker_file" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    create_dockerfile
fi


read -p "Do you need a basic docker-compose file? (yes/no): " compose_file
if [[ "$compose_file" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    create_docker_compose
fi

echo "django project creation completed."
