# --- Base deps for install ---
FROM node:22-alpine AS deps
WORKDIR /app

COPY package*.json ./
RUN npm install --production=false


# --- Builder ---
FROM node:22-alpine AS builder
WORKDIR /app

COPY . .
COPY --from=deps /app/node_modules ./node_modules

RUN npm run build


# --- Production runner ---
FROM node:22-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# 👉 install only production dependencies
COPY package*.json ./
RUN npm install --omit=dev

# 👉 copy build output
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000
CMD ["npm", "start"]
