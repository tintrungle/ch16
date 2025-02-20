FROM diamol/maven:2e AS build

WORKDIR /usr/src/iotd
COPY pom.xml .
RUN mvn -B dependency:go-offline
COPY . .

# unit tests
FROM build AS test
RUN mvn test && \
    touch /tests.passed

# publish
FROM build AS package
RUN mvn package -Dmaven.test.skip

# app
FROM diamol/openjdk:2e

WORKDIR /app
COPY --from=package /usr/src/iotd/target/iotd-service-0.1.0.jar .
COPY --from=test /tests.passed .

EXPOSE 80
ENTRYPOINT ["java", "-jar", "/app/iotd-service-0.1.0.jar"]

ARG BUILD_ID=local
ARG COMMIT_SHA=local
LABEL build_id=${BUILD_ID}
LABEL commit_sha=${COMMIT_SHA}