FROM python:3.10-slim

# Rendszer frissítése és alapcsomagok telepítése
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Google Chrome telepítése (ez kötelező a Seleniumhoz)
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Munkakönyvtár beállítása
WORKDIR /app

# Összes fájl másolása
COPY . .

# A Python csomag telepítése (setup.py alapján)
RUN pip install --no-cache-dir -e .

# Az API-hoz szükséges extra csomagok telepítése
RUN pip install --no-cache-dir -r requirements.txt

# A szerver elindítása a 8000-es porton
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
