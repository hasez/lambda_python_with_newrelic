import uuid
from fastapi import FastAPI
from mangum import Mangum

app = FastAPI(title="InsideOutDemoApp")

@app.get("/uuid")
def index():
    return {"uuid": uuid.uuid4()}

handler = Mangum(app)
