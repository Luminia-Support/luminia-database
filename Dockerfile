FROM liquibase/liquibase:4.27-alpine

USER root
RUN apk add --no-cache bash

USER liquibase

WORKDIR /liquibase

COPY --chown=liquibase:liquibase changelog/ /liquibase/changelog/
COPY --chown=liquibase:liquibase config/ /liquibase/config/

ENTRYPOINT ["/liquibase/docker-entrypoint.sh"]
CMD ["--help"]
