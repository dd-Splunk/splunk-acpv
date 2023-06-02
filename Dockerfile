FROM alpine:3.14
WORKDIR /code
RUN apk add --no-cache bash curl
COPY .env .
COPY sidecar.sh sidecar.sh
ENTRYPOINT [ "bash", "/code/sidecar.sh" ]
