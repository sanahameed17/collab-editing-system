# Quick Start Commands

## 🚀 Fastest Way to Start Everything

### 1. Start Backend Services (One Command)
```powershell
cd D:\collab-editing-system
.\start-all-services.ps1
```

### 2. Wait 30-60 seconds for services to start

### 3. Start Frontend (One Command)
```powershell
cd D:\collab-editing-system
.\start-frontend.ps1
```

### 4. Open Browser
```
http://localhost:3000
```

---

## 📝 Manual Commands (If Scripts Don't Work)

### Backend Services (Run in 4 separate terminals):

**Terminal 1:**
```powershell
cd D:\collab-editing-system\user-service\user-service
.\mvnw.cmd spring-boot:run
```

**Terminal 2:**
```powershell
cd D:\collab-editing-system\version-service\version-service
.\mvnw.cmd spring-boot:run
```

**Terminal 3:**
```powershell
cd D:\collab-editing-system\document-service\document-service
.\mvnw.cmd spring-boot:run
```

**Terminal 4:**
```powershell
cd D:\collab-editing-system\api-gateway\api-gateway
.\mvnw.cmd spring-boot:run
```

### Frontend (One terminal):
```powershell
cd D:\collab-editing-system\frontend
python -m http.server 3000
```

---

## ✅ Verify Everything is Running

```powershell
# Check ports
netstat -ano | findstr ":8080 :8081 :8082 :8083 :3000"
```

---

## 🧪 Quick Test

1. Open: `http://localhost:3000`
2. Click "Sign Up"
3. Create account: `test@example.com` / `password123`
4. Start editing!

---

## 📚 Access Points

- **Frontend UI**: http://localhost:3000
- **Swagger Docs**: 
  - http://localhost:8081/swagger-ui.html
  - http://localhost:8082/swagger-ui.html
  - http://localhost:8083/swagger-ui.html

---

## 🛑 To Stop

Press `Ctrl+C` in each terminal window.

