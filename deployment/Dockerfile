FROM adoptopenjdk/openjdk11:x86_64-alpine-jre-11.0.6_10

LABEL maintainer="martin.scholz@msg-david.de" \
        group.msg.at.cloud.cnj-hello-backend-spring.project="CXP" \
        group.msg.at.cloud.cnj-hello-backend-spring.version="0.0.1" \
        group.msg.at.cloud.cnj-hello-backend-spring.description="Most simple possible cloud native java backend based on Spring Boot"

ENV JAVA_OPTS="" \
    DOCKER_JAVA_OPTS="" \
    SPRING_JAVA_OPTS="" \
    SPRING_PROFILES_ACTIVE="default" \
    CNAP_CLOUD="local"

RUN echo "adding run user spring to system" \
    && addgroup -S spring -g 1000 \
    && adduser -S spring -u 1000 -G spring

COPY *.jar /home/spring/
COPY docker-entrypoint.sh /home/spring/

RUN chown -R spring:spring /home/spring \
    && chmod u+x /home/spring/docker-entrypoint.sh

USER spring

EXPOSE 8080

ENTRYPOINT ["/home/spring/docker-entrypoint.sh"]
CMD ["java"]