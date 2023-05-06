FROM nginx:alpine

# Copy nginx configuration file to the container
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the static files to the appropriate directory
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/


# Expose port 80
EXPOSE 8008

RUN chmod -R 777 /var/run/
RUN chmod -R 777 /var/cache/

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]