FROM python:3.10-slim

# Rendszer frissítése és telepítéshez szükséges alapcsomagok
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Google Chrome letöltése és telepítése
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Munkakönyvtár beállítása
WORKDIR /app

# Teljes projekt másolása
COPY . .

# A csomag és a függőségek telepítése
RUN pip install --no-cache-dir -e .

# Példa parancs futtatása (Ezt a saját igényeidre szabhatod)
CMD ["python", "example.py"]
