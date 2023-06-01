FROM alpine:3.14
WORKDIR /code
RUN apk add --no-cache bash curl
COPY hf.sh hf.sh
ENTRYPOINT [ "bash", "/code/hf.sh" ]
