FROM arm64v8/python:3.8 as builder

RUN apt update && apt install -y \
    linux-headers-generic \
    tcpdump \
    build-essential \
    ebtables \
    make \
    git

WORKDIR /kube-hunter
COPY setup.py setup.cfg Makefile ./
RUN make deps

COPY . .
RUN make install

FROM arm64v8/python:3.8

RUN apt update && apt install -y \
    tcpdump \
    ebtables

COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=builder /usr/local/bin/kube-hunter /usr/local/bin/kube-hunter

ENTRYPOINT ["kube-hunter"]
