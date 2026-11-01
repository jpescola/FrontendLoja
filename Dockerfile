FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Copia os arquivos de configuração e o wrapper do Gradle
COPY gradlew .
COPY gradle ./gradle
COPY build.gradle settings.gradle ./

# Copia o código-fonte da aplicação
COPY src ./src
RUN chmod +x ./gradlew
RUN ./gradlew bootJar --no-daemon -x test

FROM eclipse-temurin:21-jre
WORKDIR /app

# Copia o artefato compilado (.jar) da etapa anterior
COPY --from=build /app/build/libs/*.jar app.jar

# Expõe a porta da aplicação
EXPOSE 10000

# Inicializa a aplicação Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]


