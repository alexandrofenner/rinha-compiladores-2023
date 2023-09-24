FROM ubuntu:latest

LABEL maintainer="Alexandro Landmann Fenner"

SHELL [ "/bin/bash", "-c" ]
ENV SHELL=/bin/bash

COPY --chmod=777 build/rinhac .

CMD ["rinhac"]