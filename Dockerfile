FROM node:18-alpine

# Variables básicas
ENV N8N_VERSION=1.45.1
ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=admin
ENV N8N_BASIC_AUTH_PASSWORD=changeme
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=3000
ENV GENERIC_TIMEZONE=Europe/Madrid
ENV PORT=3000

# Crear directorio y setear permisos
WORKDIR /app

# Instalar dependencias de build y luego n8n
RUN apk --update --no-cache add --virtual .build \
    build-base \
    git \
    python3 \
 && addgroup -S n8n \
 && adduser -S -G n8n n8n \
 && npm_config_user=n8n npm install --omit=dev n8n@${N8N_VERSION} \
 && chown -R n8n:n8n /app \
 && apk del .build \
 && rm -rf /root /tmp/* \
 && mkdir /root

# Establecer usuario
USER n8n

# Puerto expuesto (para Railway)
EXPOSE 3000

# Arrancar n8n
# CAMBIO CLAVE: Apuntar directamente al ejecutable de n8n dentro de node_modules
# Esto le dice a Node.js que ejecute el script principal de n8n con el comando 'start'
CMD ["node", "/app/node_modules/n8n/bin/n8n", "start"]