# Stage 1: deps 
FROM node:20-alpine AS deps
WORKDIR /app

COPY package*.json ./
# Install only production dependencies
RUN npm ci --omit=dev

# ── Stage 2: build/test (CI uses this target) 
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run lint
RUN npm test

# Stage 3: production image 
FROM node:20-alpine AS production
WORKDIR /app

# Run as non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copy only production deps + source
COPY --from=deps /app/node_modules ./node_modules
COPY src ./src

EXPOSE 3000
ENV NODE_ENV=production

CMD ["node", "src/index.js"]
