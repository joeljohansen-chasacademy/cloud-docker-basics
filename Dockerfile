# Build stage
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

# Runtime stage
FROM node:22-alpine AS runner

WORKDIR /app 

ENV NODE_ENV=production

COPY package*.json ./

RUN npm ci --only=production

# HOSTNAME behövs inte som hade behövts om vi körde next.js som en standalone-applikation
# Det var med i ett ytterligare steg av optimering
# Läs mer här: https://nextjs.org/docs/pages/api-reference/config/next-config-js/output?utm_source=chatgpt.com#:~:text=Good%20to%20know,0.0.0.0%3A8080.
# Men utan detta kommer Render att sköta nätverkandet själv så då behöver vi inte sätta HOSTNAME.
# ENV HOSTNAME=0.0.0.0


COPY --from=builder /app/.next ./.next

EXPOSE 3000

CMD ["npm", "start"]