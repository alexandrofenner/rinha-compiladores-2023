FROM ubuntu:latest

LABEL maintainer="Alexandro Landmann Fenner"

RUN mkdir /var/rinha
WORKDIR /var/rinha

COPY build/rinhac /var/rinha/rinhac
RUN chmod +777 /var/rinha/rinhac

CMD ["./rinhac"]
