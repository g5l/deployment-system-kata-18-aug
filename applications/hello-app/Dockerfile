FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY main.go .
RUN go mod init hello-app && go build -o hello-app main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/hello-app .
EXPOSE 8080
CMD ["./hello-app"]