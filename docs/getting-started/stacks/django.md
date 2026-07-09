# Django setup with leash-secrets

Keep Django secrets out of source control and catch leaks before they land in git.

## 1. Install leash-secrets

```bash
# macOS / Linux / WSL
curl -fsSL https://raw.githubusercontent.com/FasterApiWeb/leash-secrets/main/scripts/install.sh | bash

# Windows PowerShell
irm https://raw.githubusercontent.com/FasterApiWeb/leash-secrets/main/scripts/install.ps1 | iex
```

## 2. Put secrets in environment variables

```python
# settings.py — good
import os

SECRET_KEY = os.environ["DJANGO_SECRET_KEY"]
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.environ["POSTGRES_DB"],
        "USER": os.environ["POSTGRES_USER"],
        "PASSWORD": os.environ["POSTGRES_PASSWORD"],
        "HOST": os.environ.get("POSTGRES_HOST", "localhost"),
    }
}
```

```python
# settings.py — avoid
SECRET_KEY = "django-insecure-hardcoded-example"  # will be flagged
```

Load env vars with [django-environ](https://django-environ.readthedocs.io/) or your host's secret manager. Never commit `.env` files containing real credentials.

## 3. Scan before you commit

```bash
leash-secrets scan .
```

Add the pre-commit hook (installed by the installer) so API keys and tokens never enter history.

## 4. CI tip

Run `leash-secrets scan .` in CI on pull requests so secret regressions fail the build.
