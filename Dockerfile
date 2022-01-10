FROM gradle:jdk11

WORKDIR /usr/demo

COPY ./demo /usr/demo/

EXPOSE 8080

ENTRYPOINT [ "sh", "gradlew", "bootRun" ]
