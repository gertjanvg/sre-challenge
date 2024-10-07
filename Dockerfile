# Use alpine for light image
FROM python:3.12.7-alpine3.20

# Set environment variables
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# RUN apk add --no-cache \
#     sqlite

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy requirements.txt file (or similar file)
COPY app/requirements.txt /app/

# Install dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app

# Change ownership of the working directory to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the new non-root user
USER appuser

# Expose port 8000 for the Flask app
EXPOSE 8000

# Command to run the application using Gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app.application:app"]
