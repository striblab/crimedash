#!/bin/bash
cd "$(dirname "$0")"
source ~/.nvm/nvm.sh
nvm use 21
open http://localhost:5173/
npm run dev