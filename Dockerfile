# ========== DEPENDENCY INSTALLATION ==========
FROM node:20-alpine AS deps
WORKDIR /app

COPY package*.json ./
RUN npm install --production=false


# ========== BUILD STAGE ==========
FROM node:20-alpine AS builder
WORKDIR /app

COPY . .
COPY --from=deps /app/node_modules ./node_modules

# Inject backend URL at build time if provided
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL

RUN npm run build


# ========== RUNNER STAGE ==========
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app ./

EXPOSE 3000

CMD ["npm", "start"]
