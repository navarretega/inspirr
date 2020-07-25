FROM python:3.7.6-slim-stretch
RUN apt-get -y update && apt-get -y install gcc
RUN pip install pytz loguru starlette uvicorn firebase-admin
ENV TZ=America/Monterrey
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
COPY inspirr-ab176-firebase-adminsdk-2rfdk-808e549f67.json /
COPY app.py /
WORKDIR /
CMD ["python", "app.py"]

