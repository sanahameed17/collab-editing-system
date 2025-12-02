# Step-by-Step Guide to Run and Test the Project

## Prerequisites Check

First, verify you have the required tools:

```powershell
# Check Java version (should be 17 or higher)
java -version

# Check if ports are available
netstat -ano | findstr :8080
netstat -ano | findstr :8081
netstat -ano | findstr :8082
netstat -ano | findstr :8083
```

If ports are in use, stop the processes or change ports in `application.properties` files.

---

## Step 1: Start Backend Services

### Option A: Using the Startup Script (Recommended)

Open PowerShell in the project root directory:

```powershell
# Navigate to project root
cd D:\collab-editing-system

# Run the startup script
.\start-all-services.ps1
```

This will open 4 separate PowerShell windows, one for each service.

### Option B: Manual Start (4 Separate Terminals)

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

---

## Step 2: Wait for Services to Start

Wait approximately 30-60 seconds for all services to fully start. You'll know they're ready when you see:

```
Started UserServiceApplication in X.XXX seconds
Started VersionServiceApplication in X.XXX seconds
Started DocumentServiceApplication in X.XXX seconds
Started ApiGatewayApplication in X.XXX seconds
```

---

## Step 3: Verify Services are Running

Open a new PowerShell window and run:

```powershell
# Check if all ports are listening
netstat -ano | findstr :8080
netstat -ano | findstr :8081
netstat -ano | findstr :8082
netstat -ano | findstr :8083
```

Or use the test script:

```powershell
cd D:\collab-editing-system
.\test-services.ps1
```

---

## Step 4: Start the Frontend

Open a new PowerShell window:

```powershell
# Navigate to project root
cd D:\collab-editing-system

# Option A: Use the startup script
.\start-frontend.ps1

# Option B: Manual start (choose one method)
# Method 1: Python
cd frontend
python -m http.server 3000

# Method 2: Node.js (if http-server is installed)
cd frontend
npx http-server -p 3000

# Method 3: PHP
cd frontend
php -S localhost:3000
```

---

## Step 5: Access the Application

### Web UI
Open your browser and navigate to:
```
http://localhost:3000
```

### Swagger UI (API Documentation)
- User Service: `http://localhost:8081/swagger-ui.html`
- Document Service: `http://localhost:8082/swagger-ui.html`
- Version Service: `http://localhost:8083/swagger-ui.html`

### H2 Database Console
- User Service: `http://localhost:8081/h2-console`
  - JDBC URL: `jdbc:h2:mem:userdb`
  - Username: `sa`
  - Password: (leave empty)

---

## Step 6: Test the Application

### Test 1: User Registration (via Web UI)
1. Open `http://localhost:3000`
2. Click "Sign Up" tab
3. Fill in:
   - Username: `testuser`
   - Email: `test@example.com`
   - Password: `password123`
4. Check "I agree to Terms..."
5. Click "Create Account"
6. Should automatically log you in

### Test 2: User Login (via Web UI)
1. If logged out, click "Sign In" tab
2. Enter:
   - Email: `test@example.com`
   - Password: `password123`
3. Click "Sign In"
4. Should redirect to editor

### Test 3: Create Document (via Web UI)
1. After login, you'll see the editor
2. Type some content in the editor
3. Change the document title in the top bar
4. Content saves automatically

### Test 4: API Testing (via PowerShell/curl)

**Register a User:**
```powershell
curl -X POST http://localhost:8080/api/users/register `
  -H "Content-Type: application/json" `
  -d '{\"username\": \"john_doe\", \"email\": \"john@example.com\", \"password\": \"password123\"}'
```

**Login:**
```powershell
curl -X POST http://localhost:8080/api/users/login `
  -H "Content-Type: application/json" `
  -d '{\"email\": \"john@example.com\", \"password\": \"password123\"}'
```

**Create Document:**
```powershell
curl -X POST http://localhost:8080/api/documents `
  -H "Content-Type: application/json" `
  -d '{\"title\": \"My First Document\", \"content\": \"This is test content\", \"ownerId\": 1}'
```

**Get All Users:**
```powershell
curl http://localhost:8080/api/users
```

**Get Version History:**
```powershell
curl http://localhost:8080/api/versions/document/1/history
```

---

## Step 7: Run Tests

### Run All Tests for User Service
```powershell
cd D:\collab-editing-system\user-service
.\mvnw.cmd test
```

### Run All Tests for Document Service
```powershell
cd D:\collab-editing-system\document-service
.\mvnw.cmd test
```

### Run All Tests for Version Service
```powershell
cd D:\collab-editing-system\version-service
.\mvnw.cmd test
```

---

## Step 8: Test Real-Time Collaboration

1. Open `http://localhost:3000` in two different browsers (or incognito windows)
2. Login with different accounts in each
3. Create or open the same document
4. Type in one browser - changes should appear in the other browser in real-time

---

## Troubleshooting

### Services Won't Start
```powershell
# Check if Java is installed
java -version

# Check if ports are in use
netstat -ano | findstr :8081

# Kill process using port (replace PID with actual process ID)
taskkill /PID <PID> /F
```

### Frontend Won't Load
```powershell
# Check if frontend server is running
netstat -ano | findstr :3000

# Try a different port
python -m http.server 3001
```

### API Errors
- Ensure all 4 backend services are running
- Check API Gateway is running on port 8080
- Verify services are accessible:
  ```powershell
  curl http://localhost:8081/users
  curl http://localhost:8082/documents
  curl http://localhost:8083/versions
  ```

### CORS Errors
- Ensure API Gateway is running (it handles CORS)
- Check browser console for specific error messages

---

## Quick Reference: Service URLs

| Service | Direct URL | Via Gateway |
|---------|-----------|-------------|
| User Service | http://localhost:8081 | http://localhost:8080/api/users |
| Document Service | http://localhost:8082 | http://localhost:8080/api/documents |
| Version Service | http://localhost:8083 | http://localhost:8080/api/versions |
| Frontend | http://localhost:3000 | - |

---

## Stop All Services

To stop all services:
1. Close all PowerShell windows running the services
2. Or press `Ctrl+C` in each terminal window
3. For frontend, press `Ctrl+C` in the frontend terminal

---

## Complete Test Flow

1. ✅ Start all 4 backend services
2. ✅ Wait for services to start (30-60 seconds)
3. ✅ Start frontend server
4. ✅ Open browser to `http://localhost:3000`
5. ✅ Register a new user
6. ✅ Create a document
7. ✅ Edit document content
8. ✅ View version history
9. ✅ Test real-time collaboration (2 browsers)
10. ✅ Test API endpoints via Swagger UI

---

## Success Indicators

You'll know everything is working when:
- ✅ All 4 services show "Started" in their terminals
- ✅ Frontend loads at `http://localhost:3000`
- ✅ You can register and login
- ✅ You can create and edit documents
- ✅ Swagger UI is accessible
- ✅ All tests pass

