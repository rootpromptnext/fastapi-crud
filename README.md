## FastAPI CRUD Application

This is a simple FastAPI CRUD application using:

- FastAPI  
- SQLite (items.db)  
- SQLAlchemy  
- Uvicorn  
- Pydantic  

It provides a clean CRUD API for managing items with `name` and `description`.

---

## Project Structure

```

fastapi-crud/
├── app/
│   ├── main.py
│   ├── models.py
│   ├── schemas.py
│   └── database.py
├── items.db             ← SQLite database automatically created
├── requirements.txt
└── venv/                ← Virtual environment

````

---

## Setup Instructions

### Create & Activate Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate
````

### Install Dependencies

```bash
pip install -r requirements.txt
```

### Run the FastAPI App

> Use the python -m method to avoid Uvicorn reloader issues on Ubuntu.

```bash
python -m uvicorn app.main:app --reload
```

App available at:

    http://127.0.0.1:8000

Swagger docs:

    http://127.0.0.1:8000/docs

***

## Working With SQLite (items.db)

The app automatically creates a SQLite database file:

    items.db

You checked the folder content:

    app  items.db  requirements.txt  venv

### Install sqlite3 (if missing)

If you get:

    Command 'sqlite3' not found

Install it:

```bash
sudo apt install sqlite3
```

### Open the SQLite Database

Navigate to project root:

```bash
cd fastapi-crud
sqlite3 items.db
```

### View Tables

Inside the SQLite shell:

```sql
.tables
```

You should see:

    items

### View Items Table Schema

```sql
PRAGMA table_info(items);
```

Expected output:

    0|id|INTEGER|1||1
    1|name|VARCHAR|0||0
    2|description|VARCHAR|0||0

### Exit SQLite

```sql
.quit
```

***

## Testing the API with cURL

Below are the **exact curl commands** used during testing.

***

### Get all items

```bash
curl http://127.0.0.1:8000/items
```

***

### Create Item 1 — Laptop

```bash
curl -X POST http://127.0.0.1:8000/items \
  -H "Content-Type: application/json" \
  -d '{
        "name": "Laptop",
        "description": "Dell Latitude"
      }'
```

***

### View items again

```bash
curl http://127.0.0.1:8000/items
```

***

### Update item #1

```bash
curl -X PUT http://127.0.0.1:8000/items/1 \
  -H "Content-Type: application/json" \
  -d '{
        "name": "Updated Laptop",
        "description": "Updated description"
      }'
```

***

### Create Item 2 — Keyboard

```bash
curl -X POST http://127.0.0.1:8000/items \
  -H "Content-Type: application/json" \
  -d '{
        "name": "Keyboard",
        "description": "Mechanical RGB keyboard"
      }'
```

***

## **List all items**

```bash
curl http://127.0.0.1:8000/items
```

***

## **Create an item**

### Create Laptop

```bash
curl -X POST http://127.0.0.1:8000/items \
  -H "Content-Type: application/json" \
  -d '{
        "name": "Laptop",
        "description": "Dell Latitude"
      }'
```

### Create Keyboard

```bash
curl -X POST http://127.0.0.1:8000/items \
  -H "Content-Type: application/json" \
  -d '{
        "name": "Keyboard",
        "description": "Mechanical RGB keyboard"
      }'
```

***

## *Get a specific item**

```bash
curl http://127.0.0.1:8000/items/1
```

***

## **Update an item (PUT)**

Example: Update item with ID=1

```bash
curl -X PUT http://127.0.0.1:8000/items/1 \
  -H "Content-Type: application/json" \
  -d '{
        "name": "Updated Laptop",
        "description": "Updated description"
      }'
```

Expected result:

```json
{
  "id": 1,
  "name": "Updated Laptop",
  "description": "Updated description"
}
```

***

## **Delete an item (DELETE)**

Example: Delete item with ID=1

```bash
curl -X DELETE http://127.0.0.1:8000/items/1
```

Expected output:

```json
{"detail":"Item deleted"}
```

## **Verify after update/delete**

```bash
curl http://127.0.0.1:8000/items
```

## Publish Docker Image to GitHub Container Registry (GHCR)

Authenticate, build, tag, and push Docker images to **GitHub Container Registry** using your GitHub Personal Access Token (PAT).

---

## Authenticate to GHCR

Replace `<changeme>` with your GitHub Personal Access Token (PAT).

```bash
export GITHUB_PAT="<changeme>"
export GITHUB_USERNAME="rootpromptnext"
````

Login to GHCR:

```bash
echo $GITHUB_PAT | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin
```

You should see:

    Login Succeeded

***

## Build Docker Images

Ensure your Dockerfile is in the project root.

### Build with version tag:

```bash
docker build -t ghcr.io/rootpromptnext/fastapi-crud:v1 .
```

### Build with `latest` tag:

```bash
docker build -t ghcr.io/rootpromptnext/fastapi-crud:latest .
```

***

## Push Images to GHCR

Push versioned image:

```bash
docker push ghcr.io/rootpromptnext/fastapi-crud:v1
```

Push latest tag:

```bash
docker push ghcr.io/rootpromptnext/fastapi-crud:latest
```
***

## Deploying Application Using GitHub Container Registry (GHCR) + Kubernetes

This guide explains how to authenticate to GitHub Container Registry (GHCR), store the credentials as a Kubernetes secret, and deploy your application using `deployment.yaml`.

---

## Export GitHub Credentials

Set your GitHub username and GitHub Personal Access Token (PAT):

```bash
export GITHUB_USERNAME=rootpromptnext
export GITHUB_PAT="<changeme>"
````

Create a token here:  
<https://github.com/settings/tokens>

***

## Create Kubernetes Secret for GHCR

Kubernetes needs a Docker registry secret to pull images from GHCR.

Run:

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=$GITHUB_USERNAME \
  --docker-password=$GITHUB_PAT \
  --docker-email=rootpromptnext@gmail.com
```

This creates a secret named **ghcr-secret**, which must be referenced in your `deployment.yaml`.

***

## Apply Kubernetes Deployment

Make sure your `deployment.yaml` includes:

```yaml
imagePullSecrets:
  - name: ghcr-secret
```

Deploy it:

```bash
kubectl apply -f deployment.yaml
```

***

## Verify Resources

Check that Pods, Deployments, and Services were created successfully:

```bash
kubectl get all
```

