# syntax=docker.io/docker/dockerfile:1

# Etapa base con dependencias del sistema y Node.js
FROM node:23.1.0 AS base 

# Instalar dependencias del sistema y Chrome en una sola capa
RUN apt-get update && apt-get install -y openssl && apt-get install curl gnupg -y \
&& rm -rf /var/lib/apt/lists/*

# Etapa para instalar dependencias de Node.js
FROM base AS deps
WORKDIR /app
COPY package.json package-lock.json* .npmrc* ./
RUN npm install --force

# Etapa de construcción de la aplicación
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN npm run build

# Etapa final (runner) optimizada para producción
FROM base AS runner
WORKDIR /app

# Configuración de entorno para producción
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Crear usuario seguro
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copiar solo lo necesario para producción
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder /app/package.json ./package.json

USER nextjs
ENV HOME=/home/nextjs

# Exponer puerto y definir comando de inicio
EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"
CMD ["node", "server.js"]