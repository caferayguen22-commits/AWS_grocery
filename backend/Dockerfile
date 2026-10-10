# Basis-Image: schlankes Python 3.11 (passend zur lokalen venv), kein unnötiger OS-Ballast
FROM python:3.11-slim

# Arbeitsverzeichnis im Container – bewusst /app/backend statt /app, damit die
# relative Pfadberechnung in app/__init__.py (zwei Ebenen hoch -> frontend/build)
# wieder innerhalb von /app landet, wo appuser Schreibrechte hat (siehe Fehler-Log).
WORKDIR /app/backend

# Erst nur requirements.txt kopieren -> Docker cached diesen Layer,
# solange sich die Abhängigkeiten nicht ändern (schnellere Rebuilds)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Jetzt den restlichen Code kopieren
COPY . .

# Best Practice: nicht als root laufen
RUN useradd --create-home appuser && chown -R appuser:appuser /app
USER appuser

# Port, auf dem Flask/Gunicorn lauscht (siehe run.py)
EXPOSE 5050

# Produktionsreifer WSGI-Server statt Flask-Dev-Server
CMD ["gunicorn", "-b", "0.0.0.0:5050", "run:app"]
