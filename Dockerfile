FROM alpine:3.14
WORKDIR /code
RUN apk add --no-cache bash curl
COPY .env .
COPY hf.sh .
ENTRYPOINT [ "bash", "/code/hf.sh" ]
