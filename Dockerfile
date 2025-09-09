# Multi-stage build for Quan Ly Phong Tro - Railway Compatible
# Stage 1: Build the application
FROM maven:3.8.6-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml first for better Docker layer caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM tomcat:9.0.65-jdk17-openjdk

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file as ROOT.war
COPY --from=build /app/target/QuanLyPhongTro.war /usr/local/tomcat/webapps/ROOT.war

# Set environment variables for Railway
ENV CATALINA_OPTS="-Xms256m -Xmx512m"
ENV JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8 -Duser.timezone=Asia/Ho_Chi_Minh"

# Railway uses PORT environment variable
ENV PORT=8080
EXPOSE $PORT

# Start Tomcat
CMD ["catalina.sh", "run"]