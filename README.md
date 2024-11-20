
# Django Project Setup Automation Script

## Overview

This repository contains a **Bash script** to automate the creation and setup of a Django project. The script handles the creation of the Django project, apps, virtual environment, and basic Docker configuration. It streamlines repetitive setup tasks, making it faster and easier to start new Django projects.

---

## Features

### **1. Django Project Creation**
- Automatically creates a Django project by asking for the project name.
- Sets up a virtual environment (`venv`) and installs dependencies.

### **2. App Creation**
- Prompts to create an initial app (`accounts`) with:
  - Directory structure for `api/v1`.
  - Essential files like `urls.py`, `serializers.py`, `views.py`, and more.
- Allows adding multiple apps in a loop with proper URL configuration and addition to `INSTALLED_APPS`.

### **3. Docker Integration**
- Optionally creates a `Dockerfile` for containerizing the Django project.
- Optionally generates a `docker-compose.yml` for quick containerized setup.

### **4. Intelligent Configurations**
- Dynamically updates:
  - `INSTALLED_APPS` in `settings.py`.
  - `urlpatterns` in `urls.py` with app-specific routes.
- Prevents duplicate entries in settings or URLs.

---

## Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```

2. **Ensure you have the following installed:**
   - Python 3.7 or higher.
   - Django installed in your Python environment.
   - Bash shell (Linux/macOS or Git Bash on Windows).

3. **Install required Python packages:**
   Add your Python dependencies in a `requirements.txt` file (if not already provided).

---

## Usage

1. **Run the script:**
   ```bash
   ./setup_django_project.sh
   ```

2. **Follow the prompts:**
   - Enter the Django project name.
   - Choose whether to create an initial `accounts` app.
   - Optionally add more apps in a loop.
   - Decide whether to generate a `Dockerfile` and/or `docker-compose.yml`.

---

## Examples

### Creating a Django Project
When prompted, enter your project name, and the script will:
1. Create the project.
2. Set up a virtual environment.
3. Install dependencies from `requirements.txt`.

### Adding an App
You can add as many apps as needed:
- The script automatically:
  - Creates the app directory and essential files.
  - Updates `INSTALLED_APPS` in `settings.py`.
  - Adds app URLs to the main `urls.py`.

### Generating Docker Configuration
If you choose Docker options:
- The `Dockerfile` will be created with Python and pip configurations.
- The `docker-compose.yml` will include a service for running Django.

---

## Example Directory Structure

After running the script, your project may look like this:

```
project_name/
├── accounts/
│   ├── api/
│   │   └── v1/
│   │       ├── serializers.py
│   │       ├── urls.py
│   │       ├── validators.py
│   │       └── views.py
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── migrations/
│   ├── models.py
│   ├── tests.py
│   └── urls.py
├── project_name/
│   ├── __init__.py
│   ├── asgi.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── manage.py
├── Dockerfile
├── docker-compose.yml
└── requirements.txt
```

---

## Contributing

Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add feature description"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Feedback

If you encounter any issues or have suggestions, feel free to open an issue or submit a pull request.

**Happy coding!** 🚀
