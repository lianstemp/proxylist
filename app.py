from fastapi import FastAPI
from fastapi.responses import FileResponse
import json

app = FastAPI()

@app.get("/")
async def get_proxy_list():
    with open("proxy-list/data.json") as f:
        data = json.load(f)
    return data

@app.get("/proxy-txt/")
async def get_proxy_list_txt():
    return FileResponse("proxy-list/data.txt", filename="data.txt")

@app.get("/proxy-geo/")
async def get_proxy_list_geo():
    with open("proxy-list/data-with-geolocation.json") as f:
        data = json.load(f)
    return data
