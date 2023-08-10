FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY ./app.py  .
COPY ./requirements.txt  .
COPY ./boto3-1.28.21-py3-none-any.whl .
COPY ./botocore-1.31.21-py3-none-any.whl .

RUN pip install -r requirements.txt

EXPOSE 5050

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=5050", "--server.address=0.0.0.0"]