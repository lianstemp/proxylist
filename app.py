from fastapi import FastAPI
import json

app = FastAPI()

@app.get("/proxy/")
async def get_proxy_list():
    with open("proxy-list/data.json") as f:
        data = json.load(f)
    return data

@app.get("/proxy-txt/")
async def get_proxy_list():
    with open("proxy-list/data.txt") as f:
        data = json.load(f)
    return data

@app.get("/proxy-geo/")
async def get_proxy_list():
    with open("proxy-list/data-with-geolocation.json") as f:
        data = json.load(f)
    return data