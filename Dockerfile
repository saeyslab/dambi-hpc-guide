FROM python:3.10-slim

WORKDIR /book
COPY . .
RUN pip install -r requirements.txt

CMD [ "jupyter-book", "build", "./dambi_hpc_guide"]
