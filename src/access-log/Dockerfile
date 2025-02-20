FROM diamol/node:2e AS build

WORKDIR /src
COPY src/package.json .
RUN npm install

# test framework
FROM build AS jest
RUN npm install jest --save-dev

# unit tests
FROM jest AS test
COPY src/ .
RUN npm test && \
    touch /tests.passed

# app
FROM diamol/node:2e

EXPOSE 80
CMD ["node", "server.js"]

WORKDIR /app
COPY --from=build /src/node_modules/ /app/node_modules/
COPY --from=test /tests.passed .
COPY src/ .

ARG BUILD_ID=docker
ARG COMMIT_SHA=local
LABEL build_id=${BUILD_ID}
LABEL commit_sha=${COMMIT_SHA}