# --- Install dependencies ---
FROM node:22-alpine AS deps
WORKDIR /app

COPY package*.json ./
RUN npm install


# --- Build stage ---
FROM node:22-alpine AS builder
WORKDIR /app

# Copy all project files
COPY . .

# Copy installed node_modules from deps
COPY --from=deps /app/node_modules ./node_modules

# Build Next.js project
RUN npm run build


# --- Production runner ---
FROM node:22-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Copy only required production files
COPY package*.json ./
COPY next.config.* ./
COPY postcss.config.* ./
COPY tailwind.config.* ./

# Copy public assets
COPY --from=builder /app/public ./public

# Copy production build output
COPY --from=builder /app/.next ./.next

# Copy node_modules (we will prune dev deps)
COPY --from=builder /app/node_modules ./node_modules

# Prune devDependencies to reduce size
RUN npm install --omit=dev

EXPOSE 3000

CMD ["npm", "start"]
