from fastapi import FastAPI
from fastapi.responses import FileResponse
import json

app = FastAPI()

@app.get("/")
async def get_proxy_list():
    with open("proxy/data.json") as f:
        data = json.load(f)
    return data

@app.get("/proxy-txt/")
async def get_proxy_list_txt():
    return FileResponse("proxy/data.txt", filename="data.txt")

@app.get("/proxy-geo/")
async def get_proxy_list_geo():
    with open("proxy/data-geo.json") as f:
        data = json.load(f)
    return data
