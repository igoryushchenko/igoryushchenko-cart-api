# Base
FROM node:12 AS base
WORKDIR /app

# Dependencies
FROM base AS dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force

# Build
FROM dependencies AS build
COPY . .
RUN npm run build
#
# Application
FROM node:12-alpine AS release
COPY --from=dependencies /app/package.json ./
RUN npm install --only=production
COPY --from=build /app/dist ./dist
#
USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
