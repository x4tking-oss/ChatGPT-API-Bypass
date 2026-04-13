from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import sys
import os

# Megakadályozzuk a felesleges fájlok írását
sys.dont_write_bytecode = True
from chatgptapibypass.core import chatgpt

app = FastAPI(title="ChatGPT Bypass API")

class PromptRequest(BaseModel):
    prompt: str
    search: bool = False

@app.post("/api/chat")
def ask_chatgpt(request: PromptRequest):
    try:
        # A core.py-ban lévő függvényed hívása
        response = chatgpt(prompt=request.prompt, search=request.search)
        
        if response:
            return {"status": "success", "response": response}
        else:
            raise HTTPException(status_code=500, detail="Nem érkezett válasz a ChatGPT-től.")
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/")
def read_root():
    return {"status": "online", "message": "A szerver fut és fogadja a kéréseket."}
