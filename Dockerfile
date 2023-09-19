FROM ubuntu:latest

LABEL maintainer="Alexandro Landmann Fenner"

SHELL [ "/bin/bash", "-c" ]
ENV SHELL=/bin/bash

RUN mkdir /var/rinha
WORKDIR /var/rinha

RUN apt-get update
RUN apt-get install unzip -y

ADD https://raw.githubusercontent.com/alexandrofenner/rinha-compiladores-2023/main/build/rinha.zip /var/rinha/rinha_fenner.zip
ADD https://raw.githubusercontent.com/alexandrofenner/rinha-compiladores-2023/main/build/exemplos/resumo.rinha /var/rinha/source.rinha

RUN unzip /var/rinha/rinha_fenner.zip
RUN rm /var/rinha/rinha_fenner.zip


ENTRYPOINT ["/var/rinha/rinha"]
