FROM ubuntu:latest

LABEL maintainer="Alexandro Landmann Fenner"

RUN mkdir /var/rinha
WORKDIR /var/rinha

COPY --chmod=777 build/rinhac /var/rinha/rinhac

CMD ["./rinhac"]
