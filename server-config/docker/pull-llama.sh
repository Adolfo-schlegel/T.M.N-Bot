#!/bin/sh
sleep 10
echo "Iniciando descarga de Llama 3.2:3b..."
curl -X POST http://ollama:11434/api/pull -d '{"name": "llama3.2:3b"}'
echo "Descarga finalizada."