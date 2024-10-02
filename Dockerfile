# First stage: Builder
FROM python:3.9-slim-buster AS builder

LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# Install necessary system libraries and dependencies in the builder stage
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
  && python -m pip install --no-cache-dir --upgrade pip \
  && python -m pip install --no-cache-dir numpy==1.21.4 \
  && python -m pip install --no-cache-dir tflite_runtime==2.7.0 \
  && python -m pip install --no-cache-dir flask==3.0.3 \
  && python -m pip install --no-cache-dir pillow==10.4.0

# Second stage: Final slim image
FROM python:3.9-slim-buster

# Copy only necessary files from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Set the working directory
WORKDIR /app

# Copy the TensorFlow Lite model and inference script
COPY mobilenet_model.tflite inference_tflite.py imagenet_labels.txt app.py /app/

# Expose the port the app runs on
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]

# Set the default command to run the inference script
# CMD ["python", "inference_tflite.py"]

# docker build -t inference-slim-buster-tflite-multistage-minimal-dependencies-optimized .
# docker run -it --rm inference-slim-buster-tflite-multistage-minimal-dependencies-optimized