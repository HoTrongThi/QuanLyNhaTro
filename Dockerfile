# Multi-stage build for Quan Ly Phong Tro
# Stage 1: Build the application
FROM maven:3.8.6-openjdk-17 AS build

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
FROM tomcat:9.0-jdk17

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file as ROOT.war
COPY --from=build /app/target/QuanLyPhongTro.war /usr/local/tomcat/webapps/ROOT.war

# Set environment variables for Tomcat
ENV CATALINA_OPTS="-Xms512m -Xmx1024m"
ENV JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8 -Duser.timezone=Asia/Ho_Chi_Minh"

# Expose port 8080 (Railway expects this)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]