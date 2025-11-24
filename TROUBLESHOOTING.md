# Troubleshooting Guide

## Common Issues and Solutions

### 1. Port Already in Use

**Error:** `Port 8080/8081/8082/8083 is already in use`

**Solution:**
- Check if services are already running: `netstat -ano | findstr :8080`
- Kill the process using the port: `taskkill /PID <process_id> /F`
- Or change the port in `application.properties`/`application.yml`

### 2. Compilation Errors

**Error:** Maven compilation fails

**Solution:**
- Clean and rebuild: `mvnw.cmd clean compile`
- Check Java version: `java -version` (should be 17 or higher)
- Delete `.m2` repository cache if needed

### 3. Service Not Starting

**Error:** Application fails to start

**Solution:**
- Check logs in the console output
- Verify all dependencies are downloaded
- Ensure H2 database is properly configured
- Check for conflicting dependencies

### 4. API Gateway Not Routing

**Error:** 404 or connection refused when accessing via gateway

**Solution:**
- Ensure all backend services are running first
- Check gateway routes in `application.yml`
- Verify service URLs are correct (localhost:8081, 8082, 8083)
- Check CORS configuration

### 5. Database Connection Issues

**Error:** Cannot connect to H2 database

**Solution:**
- H2 is in-memory, so data is lost on restart (this is expected)
- Access H2 console at: `http://localhost:8081/h2-console`
- JDBC URL: `jdbc:h2:mem:userdb` (or `docdb`, `versiondb`)
- Username: `sa`, Password: (empty)

### 6. Inter-Service Communication Fails

**Error:** Document service cannot call version service

**Solution:**
- Ensure version service is running before document service
- Check `version.service.url` in document-service `application.properties`
- Verify network connectivity between services

## Starting Services in Correct Order

1. **User Service** (Port 8081)
2. **Version Service** (Port 8083)
3. **Document Service** (Port 8082)
4. **API Gateway** (Port 8080)

## Verifying Services are Running

```powershell
# Check if ports are listening
netstat -ano | findstr :8080
netstat -ano | findstr :8081
netstat -ano | findstr :8082
netstat -ano | findstr :8083

# Test API Gateway
curl http://localhost:8080/api/users

# Test User Service directly
curl http://localhost:8081/users
```

## Common Runtime Errors

### Spring Boot Application Context Failed

**Cause:** Missing dependency or configuration issue

**Fix:**
- Check `pom.xml` for all required dependencies
- Verify `@SpringBootApplication` annotation is present
- Check for conflicting dependencies (e.g., web vs webflux)

### Bean Creation Error

**Cause:** Missing `@Repository` or `@Service` annotation

**Fix:**
- Ensure all repositories extend `JpaRepository`
- Add `@Repository` annotation if needed
- Check component scanning is enabled

### JPA/Hibernate Errors

**Cause:** Entity configuration issues

**Fix:**
- Verify `@Entity` annotation on model classes
- Check `@Id` and `@GeneratedValue` annotations
- Ensure `spring.jpa.hibernate.ddl-auto=update` is set

## Logs Location

- Console output shows all errors
- Check Maven build output for compilation errors
- Spring Boot logs appear in the console when running

## Getting Help

1. Check the console output for specific error messages
2. Verify all services are running: `Get-Process | Where-Object {$_.ProcessName -like "*java*"}`
3. Test each service individually before using the gateway
4. Review the README.md for API endpoint documentation

