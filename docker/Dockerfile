FROM --platform=linux/x86_64 python:3.8-slim-buster

WORKDIR /app

COPY /src .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080