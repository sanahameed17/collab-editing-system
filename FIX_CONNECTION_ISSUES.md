# Fix Connection Issues - Step by Step

## Problem: "Connection error. Please check if services are running."

### Solution Steps:

## Step 1: Verify All Services Are Running

Open PowerShell and check ports:

```powershell
netstat -ano | findstr ":8080 :8081 :8082 :8083"
```

You should see all 4 ports listening. If any are missing, start that service.

## Step 2: Start Services in Correct Order

**Terminal 1 - User Service:**
```powershell
cd D:\collab-editing-system\user-service
.\mvnw.cmd spring-boot:run
```

**Terminal 2 - Version Service:**
```powershell
cd D:\collab-editing-system\version-service
.\mvnw.cmd spring-boot:run
```

**Terminal 3 - Document Service:**
```powershell
cd D:\collab-editing-system\document-service
.\mvnw.cmd spring-boot:run
```

**Terminal 4 - API Gateway:**
```powershell
cd D:\collab-editing-system\api-gateway
.\mvnw.cmd spring-boot:run
```

## Step 3: Wait for Services to Start

Wait 30-60 seconds. Look for these messages in each terminal:
- "Started UserServiceApplication"
- "Started VersionServiceApplication"
- "Started DocumentServiceApplication"
- "Started ApiGatewayApplication"

## Step 4: Test API Gateway Directly

Open browser or PowerShell:

```powershell
# Test API Gateway
curl http://localhost:8080/api/users

# Test User Service directly
curl http://localhost:8081/users
```

## Step 5: Check Browser Console

1. Open `http://localhost:3000`
2. Press F12 to open Developer Tools
3. Go to Console tab
4. Look for any CORS or connection errors

## Step 6: Verify Database is Working

The application now has **automatic fallback** - if API Gateway fails, it tries direct service URLs.

## Step 7: Use Admin Panel to Check Status

1. Login to the application
2. Click menu (☰) → "Admin Panel"
3. Check "Service Status" section
4. All services should show "Online"

## Common Issues and Fixes

### Issue 1: Port Already in Use
```powershell
# Find process using port
netstat -ano | findstr :8081

# Kill process (replace PID)
taskkill /PID <PID> /F
```

### Issue 2: CORS Errors
- Ensure API Gateway is running (it handles CORS)
- Check `application.yml` has CORS configuration

### Issue 3: Services Start But Don't Respond
- Check if services are actually listening: `netstat -ano | findstr :8081`
- Check service logs for errors
- Verify H2 database is initialized

### Issue 4: Frontend Can't Connect
- Ensure you're accessing via `http://localhost:3000` (not `file://`)
- Check browser console for specific errors
- Try direct service URLs as fallback

## Verification Checklist

- [ ] All 4 services show "Started" in terminals
- [ ] Ports 8080, 8081, 8082, 8083 are listening
- [ ] API Gateway responds: `curl http://localhost:8080/api/users`
- [ ] User Service responds: `curl http://localhost:8081/users`
- [ ] Frontend loads at `http://localhost:3000`
- [ ] Admin Panel shows all services as "Online"
- [ ] Can register a new user
- [ ] Can login with registered user
- [ ] Data appears in Admin Panel tables

## Still Having Issues?

1. **Check service logs** - Look at terminal output for errors
2. **Restart services** - Stop all (Ctrl+C) and restart
3. **Clear browser cache** - Hard refresh (Ctrl+Shift+R)
4. **Check firewall** - Ensure ports aren't blocked
5. **Verify Java version** - Should be Java 17+

The application now has automatic fallback, so even if API Gateway fails, it will try direct service connections.

