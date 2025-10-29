# This is an intermidiat image 

# stage 1
FROM node:24-alpine AS stage1

# change into a folder called /app
WORKDIR /app

# only copy package.json from the source and place it in the destination .(app foldeR)
COPY package.json .

# download the project dependencies
RUN npm install

# copy everything from the react app folder to the /app folder in the container
COPY . .

# package up the react project in the /app directory
RUN npm run build


# stage 2  - because its a new from this kicks a new image 
FROM nginx:1.28-alpine
COPY --from=stage1 /app/build /usr/share/nginx/html


COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# meta data 
EXPOSE 80

# this is my workload. This is the comand to run anything in "" after nginx is classed as a peramiter. This command keeps it running forever
CMD ["nginx", "-g", "daemon off;"]

#  Everytime you specify from it is getting a new image. unless specified it gets this from docker hub.
# Package.json  - copy only this file and place it into working directory 
#  install - this is to do with caching. If package.json has not changed it will use the cache rather than downloading all the dependencies again. 
# copy - copy everything 
# npm run build - this is to build the react ap for production. Creates a new build folder. Meaning app now has a build folder in it. 
# stage 2 is now nginx image - copy from stage 1 the build folder. place it where nginx serves its html files from. 
# copy config file - this is to replace the default with our own config. 
# expose port 80 - this documents which port it is listening on. 
#  CMD this is the command to run nginx in the foreground so the container keeps running. 


# We will need to think about variables on how to pass the url from back end to our front end containor 
# We will also need to think about how the backend works with the frontend. (could use AI which might suggest gunicorn? for python backend)
