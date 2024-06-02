FROM python:3.10

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz && \
    tar xvfz node_exporter-1.5.0.linux-amd64.tar.gz && \
    mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/ && \
    rm -rf node_exporter-1.5.0.linux-amd64 node_exporter-1.5.0.linux-amd64.tar.gz && \
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    apt-get clean

COPY . .

EXPOSE 5000
EXPOSE 9100

CMD ["sh", "-c", "node_exporter & flask run --host=0.0.0.0"]