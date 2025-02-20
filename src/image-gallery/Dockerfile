FROM diamol/golang:2e AS build

COPY go.mod main.go /src/
WORKDIR /src
RUN go mod tidy
RUN go build -o /server

# unit tests
FROM build AS test
COPY sample_test.go /src/
RUN go test && \
    touch tests.passed

# app
FROM diamol/base:2e

ENV IMAGE_API_URL="http://iotd/image" \
    ACCESS_API_URL="http://accesslog/access-log"

CMD ["/web/server"]

WORKDIR /web
COPY index.html .
COPY --from=build /server .
COPY --from=test /src/tests.passed .
RUN chmod +x server

ARG BUILD_ID=docker
ARG COMMIT_SHA=local
LABEL build_id=${BUILD_ID}
LABEL commit_sha=${COMMIT_SHA}