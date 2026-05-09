# Giai đoạn 1: Build mã nguồn bằng Maven và Java 17
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Giai đoạn 2: Khởi chạy ứng dụng với Tomcat 10 (Hỗ trợ Jakarta EE)
FROM tomcat:10.1-jdk17
# Xóa các ứng dụng mặc định của Tomcat để tránh xung đột
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy file ROOT.war từ giai đoạn 1 sang thư mục webapps của Tomcat
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Mở cổng mặc định của Tomcat
EXPOSE 8080
CMD ["catalina.sh", "run"]