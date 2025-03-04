# Stage 1: build da aplicação
FROM node:20-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Execução da aplicação em produção
FROM node:20-alpine AS production

WORKDIR /app

# Copiar somente arquivos necessários para produção
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/package-lock.json ./package-lock.json
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public

RUN npm install --omit=dev

EXPOSE 3333

CMD ["npm", "start"]