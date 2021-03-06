# syntax = docker/dockerfile:experimental
FROM clux/muslrust:stable as builder

#COPY assets/ assets/
COPY migrations/ migrations/
COPY src/ src/
COPY templates/ templates/
COPY Cargo.lock Cargo.toml ./

RUN --mount=type=cache,target=/root/.cargo/git \
    --mount=type=cache,target=/root/.cargo/registry \
    --mount=type=cache,target=/volume/target \
    cargo install --locked --path .

FROM alpine:3.12

WORKDIR /data

RUN apk add --no-cache ca-certificates tzdata

COPY --from=builder /root/.cargo/bin/crator /app/

EXPOSE 8080
STOPSIGNAL SIGINT

ENTRYPOINT ["/app/crator"]
