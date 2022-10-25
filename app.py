#https://lcalcagni.medium.com/deploy-your-fastapi-to-aws-ec2-using-nginx-aa8aa0d85ec7 
#https://dev.to/nick_langat/how-to-deploy-a-fastapi-app-to-aws-ec2-server-46d4 

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import pickle 
import numpy as np

class Input(BaseModel):
    fea1: float
    fea2: float
    fea3: float

pickled_model = pickle.load(open('iso_forest_model.sav', 'rb'))

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
    pred=int(pickled_model.predict(np.array([input.fea1, input.fea2, input.fea3]).reshape(1, -1)))
    return {"pred": pred}