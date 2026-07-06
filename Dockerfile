# ---- Build stage ----
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Bağımlılıkları önce cache'lemek için sadece wrapper + pom kopyala
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw -B dependency:go-offline

# Kaynak kodu kopyala ve paketle
COPY src ./src
RUN ./mvnw -B clean package -DskipTests

# ---- Run stage ----
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]