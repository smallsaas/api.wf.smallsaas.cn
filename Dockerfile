FROM zelejs/allin-web:alpine-m2 AS M2

#builk-stage
FROM daocloud.io/library/maven:3.6.0-jdk-11-slim AS build

# init .m2 from alpine-m2 image first
WORKDIR /root/.m2
COPY --from=M2 /root/.m2 /root/m2
RUN --mount=type=cache,id=m2_cache,target=/root/.m2,rw cp -r /root/m2/* /root/.m2

## mvn package
WORKDIR /usr/src/app

COPY ./app/pom.xml  ./pom.xml
RUN --mount=type=cache,id=m2_cache,target=/root/.m2,rw mvn dependency:go-offline -Dmaven.main.skip=true -Dmaven.test.skip=true
# #RUN --mount=type=bind,source=./.m2,target=/root/.m2,rw mvn -o install

# # To package the usr/src/*application
COPY ./app/src ./src

RUN rm -rf /root/.m2/repository/com/jfeat
RUN --mount=type=cache,id=m2_cache,target=/root/.m2,rw mvn clean -DskipStandalone=false package -Dmaven.test.skip=true

## final
FROM adoptopenjdk:11-jre-hotspot
WORKDIR /webapps
COPY --from=build /usr/src/app/target/*-standalone.jar /webapps/app.jar
#COPY ./config ./config
CMD ["java", "-jar", "/webapps/app.jar", "--spring.profiles.active=dev", "--server.port=8080"]
# FROM zelejs/app-openjre11:alpine-slim
# WORKDIR /webapps
# COPY --from=build /usr/src/target/*-standalone.jar /webapps/app.jar
