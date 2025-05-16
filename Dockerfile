# This is a comment line
# The Java library that will be used
# FROM openjdk:17-jdk-slim-buster 
FROM openjdk:8-jdk-alpine

# Working directory
WORKDIR /src

# Copy Maven wrapper directory
COPY .mvn/ .mvn/

# Copy Maven wrapper script and pom.xml file
COPY mvnw pom.xml ./

# Download dependencies for offline work
RUN ./mvnw dependency:go-offline

# Copy source code
COPY src/ ./src/

# Run Spring Boot application
CMD ["./mvnw", "spring-boot:run"]
