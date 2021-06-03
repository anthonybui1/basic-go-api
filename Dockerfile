FROM golang:latest AS build
COPY . /app
WORKDIR /app
RUN go get -d
RUN go build -o basic-go-api

FROM alpine:latest AS runtime
# libc from build stage is not the same as alpine libc, creating symlink
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
WORKDIR /app
COPY --from=build /app/basic-go-api ./
COPY .env /app
EXPOSE 8080
ENTRYPOINT ["./basic-go-api"]
