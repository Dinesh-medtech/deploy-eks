# Stage 1: Build environment
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --omit=dev

# Copy the rest of the application code
COPY . .

# # Set build arguments
# ARG NODE_ENV

# # Set environment variables
# ENV NODE_ENV=${NODE_ENV}

RUN npm install next

# Build the Next.js application
RUN npm run build

# Stage 2: Runtime environment
FROM node:20-alpine AS runtime

# Set working directory
WORKDIR /app

# Copy only necessary files from the build stage
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
# COPY --from=build /app/public ./public
# COPY --from=build /app/.env ./.env
COPY --from=build /app/package.json ./package.json

# Expose the port your Next.js app runs on
EXPOSE 3000

# Command to run the Next.js app
ENTRYPOINT [ "node", "server.js" ]
