# Collaborative Editing System

A microservice-based collaborative editing system similar to Google Docs, built with Spring Boot. This system enables multiple users to collaborate on documents in real-time with version control capabilities.

## Architecture

The system consists of four microservices and a modern web frontend:

### Backend Microservices:

1. **User Management Service** (Port 8081)
   - User registration
   - User authentication
   - User profile management

2. **Document Editing Service** (Port 8082)
   - Create new documents
   - Edit existing documents collaboratively
   - Real-time change tracking via Server-Sent Events (SSE)

3. **Version Control Service** (Port 8083)
   - Maintain version history of documents
   - Revert to previous document versions
   - Track user contributions

4. **API Gateway** (Port 8080)
   - Single entry point for all microservices
   - Routes requests to appropriate services
   - CORS configuration

### Frontend:
5. **Web UI** (Port 3000 - optional)
   - Modern, Google Docs-like interface
   - Real-time collaboration
   - User authentication
   - Version history viewer
   - User management interface

## Technology Stack

- **Java 17**
- **Spring Boot 3.5.8**
- **Spring Cloud Gateway** (API Gateway)
- **Spring Data JPA** (Data persistence)
- **H2 Database** (In-memory database for development)
- **JUnit 5** (Testing framework)
- **Maven** (Build tool)
- **SpringDoc OpenAPI (Swagger)** (API documentation)

## Prerequisites

- Java 17 or higher
- Maven 3.6+ (or use Maven Wrapper included in each service)

## Getting Started

### Quick Start

1. **Start all backend services:**
   ```powershell
   .\start-all-services.ps1
   ```

2. **Start the frontend:**
   ```powershell
   cd frontend
   python -m http.server 3000
   # Or use: npx http-server -p 3000
   ```

3. **Open your browser:**
   Navigate to `http://localhost:3000`

### Running Individual Services

Each service can be run independently:

#### User Service
```bash
cd user-service/user-service
./mvnw.cmd spring-boot:run
# Or on Linux/Mac: ./mvnw spring-boot:run
```

#### Document Service
```bash
cd document-service/document-service
./mvnw.cmd spring-boot:run
```

#### Version Service
```bash
cd version-service/version-service
./mvnw.cmd spring-boot:run
```

#### API Gateway
```bash
cd api-gateway/api-gateway
./mvnw.cmd spring-boot:run
```

### Running All Services

Start each service in a separate terminal window. The recommended order is:
1. User Service (8081)
2. Version Service (8083)
3. Document Service (8082)
4. API Gateway (8080)

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

### Update a Document
```bash
curl -X PUT http://localhost:8080/api/documents/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Updated Title",
    "content": "Updated content"
  }'
```

### Get Version History
```bash
curl http://localhost:8080/api/versions/document/1/history
```

### Track Contributions
```bash
curl http://localhost:8080/api/versions/document/1/contributions
```

## Real-Time Collaboration

The document service supports real-time collaboration through Server-Sent Events (SSE). To subscribe to document updates:

```javascript
const eventSource = new EventSource('http://localhost:8080/api/documents/1/subscribe');
eventSource.addEventListener('document-update', (event) => {
    const document = JSON.parse(event.data);
    // Update UI with new document content
});
```

## API Documentation (Swagger/OpenAPI)

All services include comprehensive Swagger/OpenAPI documentation. Access the Swagger UI at:

- **User Service**: http://localhost:8081/swagger-ui.html
- **Document Service**: http://localhost:8082/swagger-ui.html
- **Version Service**: http://localhost:8083/swagger-ui.html

The Swagger UI provides:
- Interactive API documentation
- Try-it-out functionality
- Request/response schemas
- Authentication testing
- All endpoint details

## Testing

Each service includes comprehensive JUnit tests:

### Run Tests for User Service
```bash
cd user-service/user-service
./mvnw.cmd test
```

### Run Tests for Document Service
```bash
cd document-service/document-service
./mvnw.cmd test
```

### Run Tests for Version Service
```bash
cd version-service/version-service
./mvnw.cmd test
```

## Database

Each service uses an in-memory H2 database. You can access the H2 console at:
- User Service: http://localhost:8081/h2-console
- Document Service: http://localhost:8082/h2-console
- Version Service: http://localhost:8083/h2-console

JDBC URL: `jdbc:h2:mem:userdb` (or `docdb`, `versiondb` respectively)
Username: `sa`
Password: (empty)

## Project Structure

```
collab-editing-system/
├── api-gateway/
│   └── api-gateway/
│       └── src/
├── user-service/
│   └── user-service/
│       └── src/
├── document-service/
│   └── document-service/
│       └── src/
└── version-service/
    └── version-service/
        └── src/
```

## Features Implemented

### User Management Service
✅ User registration with email validation
✅ User authentication
✅ User profile management (CRUD operations)
✅ Get all users

### Document Editing Service
✅ Create new documents
✅ Edit existing documents
✅ Real-time collaboration via SSE
✅ Track document changes
✅ Get documents by owner
✅ Full CRUD operations

### Version Control Service
✅ Maintain version history
✅ Revert to previous versions
✅ Track user contributions
✅ Get version history
✅ Get contributions by user

### API Gateway
✅ Route configuration for all services
✅ CORS support
✅ Request routing with path stripping

### Testing
✅ Unit tests for all controllers
✅ Integration tests for repositories
✅ JUnit 5 test framework

## Future Enhancements

- JWT-based authentication
- WebSocket support for real-time collaboration
- Document sharing and permissions
- Conflict resolution for concurrent edits
- Document export functionality
- Search functionality
- Notification system

## License

This project is for educational purposes.

