#https://lcalcagni.medium.com/deploy-your-fastapi-to-aws-ec2-using-nginx-aa8aa0d85ec7 
#https://dev.to/nick_langat/how-to-deploy-a-fastapi-app-to-aws-ec2-server-46d4 

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

class Input(BaseModel):
    name: str
    age: int

app = FastAPI()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/", tags=["Root"])
async def read_root():
    return {"message": "TestWelcome to the API!"}

@app.post("/test")
def test(input: Input):
    da = input.age*2
    return {"age": da}