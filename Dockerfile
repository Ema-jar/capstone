FROM nginx

## Step 1:
RUN rm /usr/share/nginx/html/index.html

## Step 2:
# Copy source code to working directory
CMD ["ls"]
COPY . index.html /usr/share/nginx/html/

