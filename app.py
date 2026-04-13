from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import sys
import os

# Megakadályozzuk a bytecode írást, ahogy az example.py-ban is tetted
sys.dont_write_bytecode = True
from chatgptapibypass.core import chatgpt

app = FastAPI(title="ChatGPT Bypass API")

# Bemeneti adatstruktúra definiálása
class PromptRequest(BaseModel):
    prompt: str
    search: bool = False

@app.post("/api/chat")
def ask_chatgpt(request: PromptRequest):
    try:
        # Meghívjuk a te core.py-ban lévő függvényedet
        response = chatgpt(prompt=request.prompt, search=request.search)
        
        if response:
            return {"status": "success", "response": response}
        else:
            raise HTTPException(status_code=500, detail="Nem sikerült választ generálni (lehet hogy Timeout vagy Captcha).")
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/")
def read_root():
    return {"message": "A ChatGPT API Bypass szerver fut!"}
