# Base image
FROM debian:stable-slim

# Install Python
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

RUN mkdir proxy && cd proxy && touch data.json && touch data.txt && touch data-with-geolocation.json
RUN python main.py

# Add cron job to schedule running main.py every 10 minutes
RUN echo "*/10 * * * * cd /app && /venv/bin/python main.py" > /etc/cron.d/main_job
RUN chmod 0644 /etc/cron.d/main_job
RUN crontab /etc/cron.d/main_job

# Expose port 8001 for Uvicorn
EXPOSE 8001

# Start cron and run app.py using uvicorn
CMD service cron start && uvicorn app:app --host 0.0.0.0 --port 8001
