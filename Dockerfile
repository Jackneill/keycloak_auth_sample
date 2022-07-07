FROM quay.io/keycloak/keycloak:latest as builder
LABEL stage=builder

ENV LANG=en_US.UTF-8

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange
ENV KC_DB=postgres

RUN curl -sL https://github.com/aerogear/keycloak-metrics-spi/releases/download/2.5.3/keycloak-metrics-spi-2.5.3.jar -o /opt/keycloak/providers/keycloak-metrics-spi-2.5.3.jar

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest

ENV LANG=en_US.UTF-8

COPY --from=builder /opt/keycloak/ /opt/keycloak/

WORKDIR /opt/keycloak

# ENV KC_DB_URL
# ENV KC_DB_USERNAME
# ENV KC_DB_PASSWORD
# ENV KC_HOSTNAME

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
