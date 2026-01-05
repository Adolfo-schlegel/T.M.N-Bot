
# T.M.N-Bot 

### � Links importantes:
- **Diagrama de Flujo (Google AI Studio):** [Ver en Drive](https://aistudio.google.com/apps/drive/1L8XZoyfbbxSvONb7N-XTtxxjGgoT2-n-?fullscreenApplet=true&showPreview=true&showAssistant=true)
- **Notion:** [Acceder a Notion](https://www.notion.so/2de3e5f795e680589bf3fa9e40f84cc3?v=2de3e5f795e680ea9d1b000ce5a0d8ab&source=copy_link)

---

# � Guía de errores durante la instalación

## 1. Preparación de la Infraestructura

### Aceleración GPU (NVIDIA)
Para que Ollama use la **GTX 1060**, el host debe tener instalados los controladores y el toolkit de Docker.
* **Comando de verificación:** `nvidia-smi`
* **Requisito:** Instalar `nvidia-container-toolkit` y reiniciar el servicio de Docker.

### Gestión de Almacenamiento (LVM)
Si el disco inicial de la VM es pequeño (ej. 15GB), es necesario expandirlo para alojar modelos de IA.
```bash
# Expandir la partición física, el volumen lógico y el sistema de archivos
sudo growpart /dev/sda 3
sudo pvresize /dev/sda3
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
2. Automatización del Modelo (Ollama)
Para que el modelo se descargue solo al desplegar el stack, se utiliza un contenedor de soporte (curl) y un script de entrada.

Script pull-llama.sh
Bash

#!/bin/sh
sleep 10 # Espera a que el servicio de Ollama esté listo
echo "Iniciando descarga de Llama 3.2:3b..."
curl -X POST http://ollama:11434/api/pull -d '{"name": "llama3.2:3b"}'
echo "Descarga finalizada."
⚠️ Nota crítica: Es obligatorio ejecutar chmod +x pull-llama.sh antes de levantar el stack.

3. Solución de Errores Comunes (Troubleshooting)
❌ Error de Permisos (EACCES: permission denied)
El contenedor de n8n utiliza internamente el usuario node (UID 1000). Si la carpeta de datos fue creada por root o el usuario del host, n8n entrará en un bucle de reinicio.

Solución definitiva:

Bash

# Ajustar el propietario al UID del contenedor
sudo chown -R 1000:1000 ./n8n-data
# Asegurar permisos de lectura y escritura
sudo chmod -R 775 ./n8n-data
� Caracteres Especiales en el YAML
Si la N8N_ENCRYPTION_KEY contiene símbolos como $, Docker intentará interpretarlos como variables de entorno, rompiendo la clave.

Solución: Envolver siempre la clave en comillas simples dentro del archivo docker-compose.yml: N8N_ENCRYPTION_KEY: 'tu_clave_con_$imbolos'

4. Estructura de Archivos Recomendada
Plaintext

/mi-servidor-ia
├── docker-compose.yml   # Blueprint unificado (IA + n8n)
├── pull-llama.sh        # Script de descarga de modelos
├── n8n-data/            # Datos de n8n (Añadir a .gitignore)
└── ollama_data/         # Modelos de Ollama (Añadir a .gitignore)
5. Comandos de Verificación Post-Instalación
Estado de servicios: docker ps

Logs de n8n (Debug): docker logs -f n8n

Progreso de descarga de IA: docker logs -f ollama-pull-llama

Uso de GPU en tiempo real: docker exec -it ollama nvidia-smi
