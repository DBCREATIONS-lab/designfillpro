import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Design Fill Pro Backend")

# Read allowed origins from environment variable (comma-separated).
# Example:
#   ALLOWED_ORIGINS="http://localhost:3000,https://your-front.vercel.app"
allowed_origins_env = os.getenv(
    "ALLOWED_ORIGINS",
    "http://localhost:3000,http://127.0.0.1:3000"
)
allowed_origins = [o.strip() for o in allowed_origins_env.split(",") if o.strip()]

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- existing routes and logic should remain below ---
# e.g., include routers or define endpoints after this middleware setup.
