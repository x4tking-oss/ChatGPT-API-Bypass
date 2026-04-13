FROM python:3.10-slim

# Rendszer frissítése és telepítéshez szükséges alapcsomagok
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Google Chrome letöltése és telepítése közvetlenül a .deb fájlból (ÚJ MÓDSZER)
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
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
