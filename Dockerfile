#### image 1, for building the GOCA
FROM golang:1.18.4 as builder
LABEL maintainer="jacky01.zhang@outlook.com"

RUN mkdir -p /go/src/github.com/jackyzhangfudan/goca
WORKDIR /go/src/github.com/jackyzhangfudan/goca/
COPY . /go/src/github.com/jackyzhangfudan/goca/
RUN go env -w GOPROXY=https://goproxy.cn,direct && GOOS=linux go build -a -o goca .

#### image 2, the CA image which can be pulled and ran
FROM alpine:latest
LABEL maintainer="jacky01.zhang@outlook.com"

WORKDIR /
COPY --from=builder /go/src/github.com/jackyzhangfudan/goca/goca .
RUN mkdir cert && mkdir cert/clientCert && mkdir cert/localCert && mkdir cert/rootCA
#line below is needed in alpine, otherwise exe can't run
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

EXPOSE 8112

CMD ["./goca","caserver","--grpc=true", "--mtls=false"]