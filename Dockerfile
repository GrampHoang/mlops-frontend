FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY script.js /usr/share/nginx/html/

ARG BACKEND_URL
RUN chmod -R 777 /usr/share/nginx/html/
# RUN sed -i "s|__BACKEND_URL__|$BACKEND_URL|g" /usr/share/nginx/html/index.html
# Expose port 8008
EXPOSE 8008

RUN chmod -R 777 /var/run/
RUN chmod -R 777 /var/cache/

# Start Nginx
# CMD sed -i "s|__BACKEND_URL__|$BACKEND_URL|g" /usr/share/nginx/html/index.html && envsubst '$$BACKEND_URL' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && nginx -g 'daemon off;'
CMD sed -i "s|__BACKEND_URL__|$BACKEND_URL|g" /usr/share/nginx/html/index.html && nginx -g 'daemon off;'
# CMD ["nginx", "-g", "daemon off;"]