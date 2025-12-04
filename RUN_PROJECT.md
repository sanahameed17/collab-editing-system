# Step-by-Step Guide to Run and Test the Project

## 🚀 Quick Start (Fastest Method)

### Step 1: Start All Backend Services
```powershell
cd D:\collab-editing-system
.\start-all-services.ps1
```
**Wait 60-90 seconds** for all 5 services to start.

### Step 2: Start Frontend
```powershell
.\start-frontend.ps1
```

### Step 3: Open Application
Navigate to: **http://localhost:3000**

---

## 📋 Detailed Step-by-Step Instructions

### Prerequisites Check

```powershell
# Check Java version (should be 17+)
java -version

# Check if ports are available
netstat -ano | findstr ":8080 :8081 :8082 :8083 :8084"
```

If ports are in use, stop the processes or change ports in `application.properties` files.

---

## Step 1: Start Backend Services

### Option A: Using Startup Script (Recommended)

```powershell
cd D:\collab-editing-system
.\start-all-services.ps1
```

This opens 5 separate PowerShell windows, one for each service.

### Option B: Manual Start (5 Separate Terminals)

**Terminal 1 - User Service (Port 8081):**
```powershell
cd D:\collab-editing-system\user-service
.\mvnw.cmd spring-boot:run
```

**Terminal 2 - Version Service (Port 8083):**
```powershell
cd D:\collab-editing-system\version-service
.\mvnw.cmd spring-boot:run
```

**Terminal 3 - Document Service (Port 8082):**
```powershell
cd D:\collab-editing-system\document-service
.\mvnw.cmd spring-boot:run
```

**Terminal 4 - Collaboration Service (Port 8084):**
```powershell
cd D:\collab-editing-system\collaboration-service
# If mvnw.cmd exists:
.\mvnw.cmd spring-boot:run
# Otherwise:
mvn spring-boot:run
```

**Terminal 5 - API Gateway (Port 8080):**
```powershell
cd D:\collab-editing-system\api-gateway
.\mvnw.cmd spring-boot:run
```

**Important:** Start services in this order:
1. User Service
2. Version Service  
3. Document Service
4. Collaboration Service
5. API Gateway (last, as it depends on others)

---

## Step 2: Wait for Services to Start

Wait approximately **60-90 seconds** for all services to fully start. You'll know they're ready when you see:

```
Started UserServiceApplication in X.XXX seconds
Started VersionServiceApplication in X.XXX seconds
Started DocumentServiceApplication in X.XXX seconds
Started CollaborationServiceApplication in X.XXX seconds
Started ApiGatewayApplication in X.XXX seconds
```

---

## Step 3: Verify Services are Running

### Option A: Use Test Script
```powershell
cd D:\collab-editing-system
.\test-services.ps1
```

### Option B: Manual Check
```powershell
# Check if all ports are listening
netstat -ano | findstr ":8080 :8081 :8082 :8083 :8084"
```

### Option C: Test Individual Services
```powershell
# Test API Gateway
curl http://localhost:8080/api/users

# Test User Service directly
curl http://localhost:8081/users

# Test Document Service
curl http://localhost:8082/documents

# Test Version Service
curl http://localhost:8083/versions

# Test Collaboration Service
curl http://localhost:8084/collab/shared-with/1
```

---

## Step 4: Start the Frontend

### Option A: Using Startup Script
```powershell
cd D:\collab-editing-system
.\start-frontend.ps1
```

### Option B: Manual Start

**Using Python:**
```powershell
cd D:\collab-editing-system\frontend
python -m http.server 3000
```

**Using Node.js:**
```powershell
cd D:\collab-editing-system\frontend
npx http-server -p 3000
```

**Using PHP:**
```powershell
cd D:\collab-editing-system\frontend
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
- **User Service**: http://localhost:8081/swagger-ui.html
- **Document Service**: http://localhost:8082/swagger-ui.html
- **Version Service**: http://localhost:8083/swagger-ui.html
- **Collaboration Service**: http://localhost:8084/swagger-ui.html

### H2 Database Console
- **User Service**: http://localhost:8081/h2-console
  - JDBC URL: `jdbc:h2:mem:userdb`
  - Username: `sa`, Password: (empty)

- **Document Service**: http://localhost:8082/h2-console
  - JDBC URL: `jdbc:h2:mem:docdb`
  - Username: `sa`, Password: (empty)

- **Version Service**: http://localhost:8083/h2-console
  - JDBC URL: `jdbc:h2:mem:versiondb`
  - Username: `sa`, Password: (empty)

- **Collaboration Service**: http://localhost:8084/h2-console
  - JDBC URL: `jdbc:h2:file:./data/collabdb`
  - Username: `sa`, Password: (empty)

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

### Test 4: Admin Panel (via Web UI)
1. After login, click menu (☰) → "Admin Panel"
2. View:
   - Service Status (all should be "Online")
   - Statistics (Users, Documents, Versions)
   - Database tables with all data

### Test 5: API Testing (via PowerShell/curl)

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

**Share Document:**
```powershell
curl -X POST "http://localhost:8084/collab/documents/1/share?userId=2&permission=edit"
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

### Run All Tests for Collaboration Service
```powershell
cd D:\collab-editing-system\collaboration-service
# If mvnw.cmd exists:
.\mvnw.cmd test
# Otherwise:
mvn test
```

---

## Step 8: Test Real-Time Collaboration

### WebSocket Collaboration (Collaboration Service)
1. Open `http://localhost:3000` in two different browsers (or incognito windows)
2. Login with different accounts in each
3. Create or open the same document
4. Type in one browser - changes should appear in the other browser in real-time via WebSocket

### Server-Sent Events (Document Service)
1. Subscribe to document updates via SSE endpoint
2. Changes are broadcasted to all subscribers

---

## 🌐 Complete Service Reference

| Service | Port | Direct URL | Via Gateway | Swagger UI |
|---------|------|------------|-------------|------------|
| API Gateway | 8080 | http://localhost:8080 | - | - |
| User Service | 8081 | http://localhost:8081 | http://localhost:8080/api/users | http://localhost:8081/swagger-ui.html |
| Document Service | 8082 | http://localhost:8082 | http://localhost:8080/api/documents | http://localhost:8082/swagger-ui.html |
| Version Service | 8083 | http://localhost:8083 | http://localhost:8080/api/versions | http://localhost:8083/swagger-ui.html |
| Collaboration Service | 8084 | http://localhost:8084 | - | http://localhost:8084/swagger-ui.html |
| Frontend | 3000 | http://localhost:3000 | - | - |

---

## 🐛 Troubleshooting

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
- Ensure all 5 backend services are running
- Check API Gateway is running on port 8080
- Verify services are accessible:
  ```powershell
  curl http://localhost:8081/users
  curl http://localhost:8082/documents
  curl http://localhost:8083/versions
  curl http://localhost:8084/collab/shared-with/1
  ```

### CORS Errors
- Ensure API Gateway is running (it handles CORS)
- Check browser console for specific error messages

### Connection Errors
- Use Admin Panel → Service Status to see which services are offline
- Check service logs in terminal windows
- Verify all services started successfully

---

## ✅ Complete Test Flow

1. ✅ Start all 5 backend services
2. ✅ Wait for services to start (60-90 seconds)
3. ✅ Verify services are running (use test script)
4. ✅ Start frontend server
5. ✅ Open browser to `http://localhost:3000`
6. ✅ Register a new user
7. ✅ Login with registered user
8. ✅ Create a document
9. ✅ Edit document content
10. ✅ View version history
11. ✅ Access Admin Panel
12. ✅ Test real-time collaboration (2 browsers)
13. ✅ Test API endpoints via Swagger UI
14. ✅ Run all tests

---

## 🎯 Success Indicators

You'll know everything is working when:
- ✅ All 5 services show "Started" in their terminals
- ✅ Frontend loads at `http://localhost:3000`
- ✅ You can register and login
- ✅ You can create and edit documents
- ✅ Admin Panel shows all services as "Online"
- ✅ Real-time collaboration works
- ✅ Swagger UI is accessible
- ✅ All tests pass

---

## 🛑 To Stop All Services

Press `Ctrl+C` in each terminal window where services are running.

Or close all PowerShell windows.

---

## 📚 Additional Resources

- `README.md` - Complete project documentation
- `QUICK_START.md` - Quick reference guide
- `TROUBLESHOOTING.md` - Common issues and solutions
- `FIX_CONNECTION_ISSUES.md` - Connection troubleshooting
- `PROJECT_REQUIREMENTS_CHECKLIST.md` - Requirements verification
- `SOLUTION_SUMMARY.md` - Solutions to common problems

