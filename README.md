# Collaborative Editing System

A microservice-based collaborative editing system similar to Google Docs, built with Spring Boot. This system enables multiple users to collaborate on documents in real-time with version control capabilities.

## Architecture

The system consists of **five microservices** and a modern web frontend:

### Backend Microservices:

1. **User Management Service** (Port 8081)
   - User registration
   - User authentication
   - User profile management
   - Get all users

2. **Document Editing Service** (Port 8082)
   - Create new documents
   - Edit existing documents collaboratively
   - Real-time change tracking via Server-Sent Events (SSE)
   - Document CRUD operations

3. **Version Control Service** (Port 8083)
   - Maintain version history of documents
   - Revert to previous document versions
   - Track user contributions
   - Version management

4. **Collaboration Service** (Port 8084)
   - WebSocket-based real-time collaboration
   - Document sharing functionality
   - Real-time document synchronization
   - STOMP messaging protocol

5. **API Gateway** (Port 8080)
   - Single entry point for all microservices
   - Routes requests to appropriate services
   - CORS configuration
   - Request forwarding

### Frontend:
6. **Web UI** (Port 3000)
   - Modern, Google Docs-like interface
   - Real-time collaboration
   - User authentication
   - Version history viewer
   - User management interface
   - Admin panel with database visualization

## Technology Stack

- **Java 17**
- **Spring Boot 3.5.8**
- **Spring Cloud Gateway** (API Gateway)
- **Spring WebSocket** (Real-time collaboration)
- **Spring Data JPA** (Data persistence)
- **H2 Database** (In-memory database for development)
- **JUnit 5** (Testing framework)
- **Maven** (Build tool)
- **SpringDoc OpenAPI (Swagger)** (API documentation)
- **SockJS & STOMP** (WebSocket client libraries)

## Prerequisites

- Java 17 or higher
- Maven 3.6+ (or use Maven Wrapper included in each service)
- Python/Node.js/PHP (for frontend server - optional)

## Quick Start

### 1. Start All Backend Services

```powershell
cd D:\collab-editing-system
.\start-all-services.ps1
```

This will start all 5 services in separate windows. Wait 30-60 seconds for them to start.

### 2. Start Frontend

```powershell
.\start-frontend.ps1
```

### 3. Open Application

Navigate to: `http://localhost:3000`

## Detailed Setup Instructions

### Starting Services Manually

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

**Terminal 4 - Collaboration Service:**
```powershell
cd D:\collab-editing-system\collaboration-service
# If mvnw.cmd exists:
.\mvnw.cmd spring-boot:run
# Otherwise:
mvn spring-boot:run
```

**Terminal 5 - API Gateway:**
```powershell
cd D:\collab-editing-system\api-gateway
.\mvnw.cmd spring-boot:run
```

### Starting Frontend

```powershell
cd D:\collab-editing-system\frontend
python -m http.server 3000
# Or: npx http-server -p 3000
# Or: php -S localhost:3000
```

## Service URLs

| Service | Port | Direct URL | Via Gateway |
|---------|------|------------|-------------|
| API Gateway | 8080 | http://localhost:8080 | - |
| User Service | 8081 | http://localhost:8081 | http://localhost:8080/api/users |
| Document Service | 8082 | http://localhost:8082 | http://localhost:8080/api/documents |
| Version Service | 8083 | http://localhost:8083 | http://localhost:8080/api/versions |
| Collaboration Service | 8084 | http://localhost:8084 | - |
| Frontend | 3000 | http://localhost:3000 | - |

## API Endpoints

### User Service (via Gateway: `/api/users`)

- `POST /api/users/register` - Register a new user
- `POST /api/users/login` - Authenticate user
- `GET /api/users/{id}` - Get user by ID
- `GET /api/users` - Get all users
- `PUT /api/users/{id}` - Update user profile
- `DELETE /api/users/{id}` - Delete user

### Document Service (via Gateway: `/api/documents`)

- `POST /api/documents` - Create a new document
- `GET /api/documents` - Get all documents
- `GET /api/documents/{id}` - Get document by ID
- `GET /api/documents/owner/{ownerId}` - Get documents by owner
- `PUT /api/documents/{id}` - Update document
- `DELETE /api/documents/{id}` - Delete document
- `GET /api/documents/{documentId}/subscribe` - Subscribe to real-time updates (SSE)
- `POST /api/documents/{id}/track-change` - Track document changes

### Version Service (via Gateway: `/api/versions`)

- `POST /api/versions` - Save a new version
- `GET /api/versions/document/{documentId}` - Get all versions for a document
- `GET /api/versions/{id}` - Get version by ID
- `GET /api/versions/document/{documentId}/history` - Get version history
- `POST /api/versions/revert/{documentId}/{versionId}` - Revert to a specific version
- `GET /api/versions/document/{documentId}/contributions` - Track user contributions
- `GET /api/versions/user/{userId}/contributions` - Get contributions by user

### Collaboration Service (Direct: Port 8084)

- `POST /collab/documents/{docId}/share` - Share document with user
- `GET /collab/shared-with/{userId}` - Get documents shared with user
- `DELETE /collab/documents/{docId}/share` - Unshare document
- WebSocket: `ws://localhost:8084/ws` - Real-time collaboration endpoint

## API Documentation (Swagger/OpenAPI)

All services include comprehensive Swagger/OpenAPI documentation. Access the Swagger UI at:

- **User Service**: http://localhost:8081/swagger-ui.html
- **Document Service**: http://localhost:8082/swagger-ui.html
- **Version Service**: http://localhost:8083/swagger-ui.html
- **Collaboration Service**: http://localhost:8084/swagger-ui.html

## Testing

### Run All Tests

**User Service:**
```powershell
cd D:\collab-editing-system\user-service
.\mvnw.cmd test
```

**Document Service:**
```powershell
cd D:\collab-editing-system\document-service
.\mvnw.cmd test
```

**Version Service:**
```powershell
cd D:\collab-editing-system\version-service
.\mvnw.cmd test
```

**Collaboration Service:**
```powershell
cd D:\collab-editing-system\collaboration-service
# If mvnw.cmd exists:
.\mvnw.cmd test
# Otherwise:
mvn test
```

## Example API Calls

### Register a User
```bash
curl -X POST http://localhost:8080/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Login
```bash
curl -X POST http://localhost:8080/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Create a Document
```bash
curl -X POST http://localhost:8080/api/documents \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My First Document",
    "content": "This is the content of my document",
    "ownerId": 1
  }'
```

### Share a Document
```bash
curl -X POST "http://localhost:8084/collab/documents/1/share?userId=2&permission=edit"
```

## Real-Time Collaboration

The system supports real-time collaboration through two mechanisms:

1. **Server-Sent Events (SSE)** - Document Service
   - Endpoint: `GET /api/documents/{documentId}/subscribe`
   - Used for document updates

2. **WebSocket (STOMP)** - Collaboration Service
   - Endpoint: `ws://localhost:8084/ws`
   - Used for real-time collaborative editing
   - Subscribe to: `/topic/doc/{documentId}`
   - Send edits to: `/app/doc/{documentId}/edit`

## Features

### User Management
- ✅ User registration with email validation
- ✅ User authentication
- ✅ User profile management
- ✅ User listing and management

### Document Editing
- ✅ Create, read, update, delete documents
- ✅ Real-time collaborative editing
- ✅ Automatic saving
- ✅ Document sharing

### Version Control
- ✅ Complete version history
- ✅ Revert to previous versions
- ✅ Track user contributions
- ✅ Version comparison

### Collaboration
- ✅ WebSocket-based real-time sync
- ✅ Document sharing with permissions
- ✅ Multi-user editing support
- ✅ Real-time updates

### Admin Panel
- ✅ Service status monitoring
- ✅ Database visualization
- ✅ Statistics dashboard
- ✅ User management
- ✅ Data tables for all entities

## Project Structure

```
collab-editing-system/
├── api-gateway/              # API Gateway service
├── user-service/             # User management service
├── document-service/         # Document editing service
├── version-service/          # Version control service
├── collaboration-service/     # Real-time collaboration service
├── frontend/                 # Web UI
├── start-all-services.ps1    # Start all services script
├── start-frontend.ps1       # Start frontend script
├── test-services.ps1         # Test services script
└── README.md                 # This file
```

## Database Access

### H2 Console Access

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

## Troubleshooting

### Services Won't Start
- Check Java version: `java -version` (should be 17+)
- Check if ports are in use: `netstat -ano | findstr :8080`
- Kill processes if needed: `taskkill /PID <PID> /F`

### Connection Errors
- Ensure all services are running
- Check Admin Panel → Service Status
- Verify API Gateway is running
- Check browser console for specific errors

### Frontend Issues
- Ensure accessing via `http://localhost:3000` (not `file://`)
- Check CORS configuration
- Verify all backend services are running

See `TROUBLESHOOTING.md` for more details.

## Testing Checklist

- [ ] All 5 backend services start successfully
- [ ] Frontend loads at http://localhost:3000
- [ ] Can register new users
- [ ] Can login with registered users
- [ ] Can create documents
- [ ] Can edit documents
- [ ] Real-time collaboration works (2 browsers)
- [ ] Version history is maintained
- [ ] Admin panel shows all data
- [ ] Swagger UI is accessible
- [ ] All tests pass

## Success Indicators

You'll know everything is working when:
- ✅ All 5 services show "Started" in their terminals
- ✅ Frontend loads at `http://localhost:3000`
- ✅ You can register and login
- ✅ You can create and edit documents
- ✅ Real-time collaboration works
- ✅ Admin panel shows all services as "Online"
- ✅ Swagger UI is accessible
- ✅ All tests pass

## License

This project is for educational purposes.

## Support

For issues and questions, refer to:
- `TROUBLESHOOTING.md` - Common issues and solutions
- `QUICK_START.md` - Quick reference guide
- `FIX_CONNECTION_ISSUES.md` - Connection troubleshooting
- `PROJECT_REQUIREMENTS_CHECKLIST.md` - Requirements verification
