FROM python:3.10-slim-bullseye

ADD rates app/

RUN apt-get update && apt-get install -y python3-pip

WORKDIR app/

RUN pip install -U gunicorn && pip install -Ur requirements.txt

CMD ["gunicorn","-b :3000", "wsgi"]
