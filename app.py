#https://lcalcagni.medium.com/deploy-your-fastapi-to-aws-ec2-using-nginx-aa8aa0d85ec7 
#https://dev.to/nick_langat/how-to-deploy-a-fastapi-app-to-aws-ec2-server-46d4 

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, create_model
import pickle 
import numpy as np

""" class Input(BaseModel):
    fea1: float
    fea2: float
    fea3: float """

pickled_model = pickle.load(open('iso_forest_model.sav', 'rb'))

Input=create_model('Input', **{f: (float, ...) for f in pickled_model.feature_names_in_})

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
    return {"message": "Welcome"}

@app.post("/predict")
def predict(input: Input):
    pred=int(pickled_model.predict(np.array([list(dict(input).values())])))
    return {"pred": pred}