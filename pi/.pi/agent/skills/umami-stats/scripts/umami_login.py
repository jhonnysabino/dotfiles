#!/usr/bin/env python3
"""Login helper for self-hosted Umami - saves token to ~/.umami_token"""
import urllib.request
import json
import os
import sys

TOKEN_FILE = os.path.expanduser("~/.umami_token")

def login(base_url: str, username: str, password: str):
    url = f"{base_url.rstrip('/')}/api/auth/login"
    data = json.dumps({"username": username, "password": password}).encode()
    req = urllib.request.Request(url, data=data, headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req) as resp:
        result = json.load(resp)
    return result["token"]

def save_token(token: str):
    with open(TOKEN_FILE, "w") as f:
        f.write(token)
    os.chmod(TOKEN_FILE, 0o600)

def load_token() -> str | None:
    if os.path.exists(TOKEN_FILE):
        return open(TOKEN_FILE).read().strip()
    return None

if __name__ == "__main__":
    base_url = sys.argv[1] if len(sys.argv) > 1 else os.getenv("UMAMI_BASE_URL", "https://analytics.carbos.app")
    username = sys.argv[2] if len(sys.argv) > 2 else os.getenv("UMAMI_USERNAME")
    password = sys.argv[3] if len(sys.argv) > 3 else os.getenv("UMAMI_PASSWORD")
    
    if not username or not password:
        print("Usage: python3 umami_login.py <base_url> <username> <password>", file=sys.stderr)
        sys.exit(1)
    
    token = login(base_url, username, password)
    save_token(token)
    print(f"Token saved to {TOKEN_FILE}")
