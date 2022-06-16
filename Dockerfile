# --------------- #
# build container #
# --------------- #

FROM golang:1.18-bullseye as builder

RUN apt-get -qq update && apt-get install -y libmagic-dev libpng-dev libjpeg-dev libtiff-dev libheif-dev

RUN go install gitlab.com/opennota/findimagedupes@latest

# ----------------- #
# runtime container #
# ----------------- #

FROM debian:bullseye-slim

RUN apt-get -qq update && \
    apt-get install -y libmagic-dev libpng-dev libjpeg-dev libtiff-dev libheif-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/findimagedupes /bin/findimagedupes

ENTRYPOINT ["findimagedupes"]
