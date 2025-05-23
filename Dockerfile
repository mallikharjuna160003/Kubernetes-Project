# Use an official Node.js runtime as a parent image
FROM node:20.17.0 AS build

# Set the working directory
WORKDIR /usr/src/app 

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps


# Copy the rest of the application code
COPY . .


#RUN npm test

# Build the application with the legacy OpenSSL provider option
RUN NODE_OPTIONS=--openssl-legacy-provider npm run build
#RUN npm run build

# Use Nginx to serve the app
FROM nginx:alpine


# Copy the build files to the Nginx server
COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Expose the port Nginx is running on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

