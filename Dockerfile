# Base image with cron and Rust support
FROM debian:stable-slim

# Install Python, cron, and Rust components
RUN apt-get update && \
    apt-get install -y python3 python3-pip cron build-essential curl python3-venv

# Set working directory
WORKDIR /app

# Create a virtual environment and activate it
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Copy the contents of the current directory to the container
COPY . /app/

# Install required Python packages inside the virtual environment
RUN pip install -r requirements.txt

RUN mkdir proxy-list && cd proxy-list && touch data.json && touch data.txt && touch data-with-geolocation.json
RUN python main.py

# Run app.py using uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8001"]

# Schedule main.py to run every 1 hour
RUN echo "0 * * * * python3 /app/main.py >> /app/cron.log 2>&1" > /etc/cron.d/main_cron

# Give execution rights to the cron job
RUN chmod 0644 /etc/cron.d/main_cron

# Apply cron job
RUN crontab /etc/cron.d/main_cron

# Create the log file to be able to run tail
RUN touch /app/cron.log

# Expose port 80 for FastAPI app
EXPOSE 80
