################################ Python image and tensorflow #################################

# FROM python:3.9

# LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# # os and opencv libraries
# RUN apt-get update -y \
#   && apt install libgl1-mesa-glx -y \
#   && apt-get install 'ffmpeg' 'libsm6' 'libxext6'  -y \
#   && python -m pip install --no-cache-dir --upgrade pip

# RUN python -m pip install --no-cache-dir --upgrade pip \
#   &&  pip install --no-cache-dir numpy==1.21.4 \
#   &&  pip install --no-cache-dir tensorflow

# # Set the working directory
# WORKDIR /app

# # Copy the TensorFlow Lite model and inference script
# COPY mobilenet_model.tflite /app/mobilenet_model.tflite
# COPY inference_tensorflow.py /app/inference_tensorflow.py
# COPY imagenet_labels.txt /app/imagenet_labels.txt

# # Set the default command to run the inference script
# CMD ["python", "inference_tensorflow.py"]

# docker build -t inference-python-tensorflow .
# docker run -it --rm inference-python-tensorflow

################################# Python image with tflite ##################################

# FROM python:3.9

# LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# # os and opencv libraries
# RUN apt-get update -y \
#   && apt install libgl1-mesa-glx -y \
#   && apt-get install 'ffmpeg' 'libsm6' 'libxext6'  -y \
#   && python -m pip install --no-cache-dir --upgrade pip

# RUN python -m pip install --no-cache-dir --upgrade pip \
#   &&  pip install --no-cache-dir numpy==1.21.4 \
#   &&  pip install --no-cache-dir tflite_runtime==2.7.0

# # Set the working directory
# WORKDIR /app

# # Copy the TensorFlow Lite model and inference script
# COPY mobilenet_model.tflite /app/mobilenet_model.tflite
# COPY inference_tflite.py /app/inference_tflite.py
# COPY imagenet_labels.txt /app/imagenet_labels.txt

# # Set the default command to run the inference script
# CMD ["python", "inference_tflite.py"]

# docker build -t inference-python-tflite .
# docker run -it --rm inference-python-tflite


################################# Small image with tensorflow ###############################

# FROM python:3.9-slim-buster

# LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# # os and opencv libraries
# RUN apt-get update -y \
#   && apt install libgl1-mesa-glx -y \
#   && apt-get install 'ffmpeg' 'libsm6' 'libxext6'  -y \
#   && python -m pip install --no-cache-dir --upgrade pip

# RUN python -m pip install --no-cache-dir --upgrade pip \
#   &&  pip install --no-cache-dir numpy==1.21.4 \
#   &&  pip install --no-cache-dir tensorflow

# # Set the working directory
# WORKDIR /app

# # Copy the TensorFlow Lite model and inference script
# COPY mobilenet_model.tflite /app/mobilenet_model.tflite
# COPY inference_tensorflow.py /app/inference_tensorflow.py
# COPY imagenet_labels.txt /app/imagenet_labels.txt

# # Set the default command to run the inference script
# CMD ["python", "inference_tensorflow.py"]

# docker build -t inference-slim-buster-tensorflow .
# docker run -it --rm inference-slim-buster-tensorflow

####################################### Small image with tflite #########################################

# FROM python:3.9-slim-buster

# LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# # os and opencv libraries
# RUN apt-get update -y \
#   && apt install libgl1-mesa-glx -y \
#   && apt-get install 'ffmpeg' 'libsm6' 'libxext6'  -y \
#   && python -m pip install --no-cache-dir --upgrade pip

# RUN python -m pip install --no-cache-dir --upgrade pip \
#   &&  pip install --no-cache-dir numpy==1.21.4 \
#   &&  pip install --no-cache-dir tflite_runtime==2.7.0

# # Set the working directory
# WORKDIR /app

# # Copy the TensorFlow Lite model and inference script
# COPY mobilenet_model.tflite /app/mobilenet_model.tflite
# COPY inference_tflite.py /app/inference_tflite.py
# COPY imagenet_labels.txt /app/imagenet_labels.txt

# # Set the default command to run the inference script
# CMD ["python", "inference_tflite.py"]

# docker build -t inference-slim-buster-tflite .
# docker run -it --rm inference-slim-buster-tflite

########################## Smallest - multistage and optimized tensorflow ##########################

# # First stage: Builder
# FROM python:3.9-slim-buster AS builder

# LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# # Install necessary system libraries and dependencies in the builder stage
# RUN apt-get update -y \
#   && apt-get install -y --no-install-recommends \
#     libgl1-mesa-glx \
#     ffmpeg \
#     libsm6 \
#     libxext6 \
#   && python -m pip install --no-cache-dir --upgrade pip \
#   && python -m pip install --no-cache-dir numpy==1.21.4 \
#   && python -m pip install --no-cache-dir tensorflow

# # Second stage: Final slim image
# FROM python:3.9-slim-buster

# # Install only required system libraries in the final stage
# RUN apt-get update -y \
#   && apt-get install -y --no-install-recommends \
#     libgl1-mesa-glx \
#     ffmpeg \
#     libsm6 \
#     libxext6 \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/*

# # Copy only necessary files from the builder stage
# COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
# COPY --from=builder /usr/local/bin /usr/local/bin

# # Set the working directory
# WORKDIR /app

# # Copy the TensorFlow Lite model and inference script
# COPY mobilenet_model.tflite /app/mobilenet_model.tflite
# COPY inference_tensorflow.py /app/inference_tensorflow.py
# COPY imagenet_labels.txt /app/imagenet_labels.txt

# # Set the default command to run the inference script
# CMD ["python", "inference_tensorflow.py"]

# docker build -t inference-slim-buster-tensorflow-multistage .
# docker run -it --rm inference-slim-buster-tensorflow-multistage

###################################################################################################

########################## Smallest - multistage and optimized tflite ##########################

# # First stage: Builder
# FROM python:3.9-slim-buster AS builder

# LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# # Install necessary system libraries and dependencies in the builder stage
# RUN apt-get update -y \
#   && apt-get install -y --no-install-recommends \
#     libgl1-mesa-glx \
#     ffmpeg \
#     libsm6 \
#     libxext6 \
#   && python -m pip install --no-cache-dir --upgrade pip \
#   && python -m pip install --no-cache-dir numpy==1.21.4 \
#   && python -m pip install --no-cache-dir tflite_runtime==2.7.0

# # Second stage: Final slim image
# FROM python:3.9-slim-buster

# # Install only required system libraries in the final stage
# RUN apt-get update -y \
#   && apt-get install -y --no-install-recommends \
#     libgl1-mesa-glx \
#     ffmpeg \
#     libsm6 \
#     libxext6 \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/*

# # Copy only necessary files from the builder stage
# COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
# COPY --from=builder /usr/local/bin /usr/local/bin

# # Set the working directory
# WORKDIR /app

# # Copy the TensorFlow Lite model and inference script
# COPY mobilenet_model.tflite /app/mobilenet_model.tflite
# COPY inference_tflite.py /app/inference_tflite.py
# COPY imagenet_labels.txt /app/imagenet_labels.txt

# # Set the default command to run the inference script
# CMD ["python", "inference_tflite.py"]

# docker build -t inference-slim-buster-tflite-multistage .
# docker run -it --rm inference-slim-buster-tflite-multistage

###################################################################################################

########################## Smallest - multistage and optimized tflite - removed unnecessary dependencies ##########################

# # First stage: Builder
# FROM python:3.9-slim-buster AS builder

# LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# # Install necessary system libraries and dependencies in the builder stage
# RUN apt-get update -y \
#   && apt-get install -y --no-install-recommends \
#   && python -m pip install --no-cache-dir --upgrade pip \
#   && python -m pip install --no-cache-dir numpy==1.21.4 \
#   && python -m pip install --no-cache-dir tflite_runtime==2.7.0

# # Second stage: Final slim image
# FROM python:3.9-slim-buster

# # Copy only necessary files from the builder stage
# COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
# COPY --from=builder /usr/local/bin /usr/local/bin

# # Set the working directory
# WORKDIR /app

# # Copy the TensorFlow Lite model and inference script
# COPY mobilenet_model.tflite /app/mobilenet_model.tflite
# COPY inference_tflite.py /app/inference_tflite.py
# COPY imagenet_labels.txt /app/imagenet_labels.txt

# # Set the default command to run the inference script
# CMD ["python", "inference_tflite.py"]

# docker build -t inference-slim-buster-tflite-multistage-minimal-dependencies .
# docker run -it --rm inference-slim-buster-tflite-multistage-minimal-dependencies

#############################################################################

########################## Smallest - multistage and optimized tensorflow - removed unnecessary dependencies ##########################

# # First stage: Builder
# FROM python:3.9-slim-buster AS builder

# LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# # Install necessary system libraries and dependencies in the builder stage
# RUN apt-get update -y \
#   && apt-get install -y --no-install-recommends \
#   && python -m pip install --no-cache-dir --upgrade pip \
#   && python -m pip install --no-cache-dir numpy==1.21.4 \
#   && python -m pip install --no-cache-dir tensorflow \
#   && python -m pip install --no-cache-dir flask \
#   && python -m pip install --no-cache-dir pillow

# # Second stage: Final slim image
# FROM python:3.9-slim-buster

# # Copy only necessary files from the builder stage
# COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
# COPY --from=builder /usr/local/bin /usr/local/bin

# # Set the working directory
# WORKDIR /app

# # Copy the TensorFlow Lite model and inference script
# COPY mobilenet_model.tflite /app/mobilenet_model.tflite
# COPY inference_tensorflow.py /app/inference_tensorflow.py
# COPY imagenet_labels.txt /app/imagenet_labels.txt
# COPY app.py /app/app.py

# # # Set the default command to run the inference script
# # CMD ["python", "inference_tensorflow.py"]

# # docker build -t inference-slim-buster-tensorflow-multistage-minimal-dependencies .
# # docker run -it --rm inference-slim-buster-tensorflow-multistage-minimal-dependencies

# # Expose the port the app runs on
# EXPOSE 5000

# # Run the Flask app
# CMD ["python", "app.py"]

# # docker build -t app-slim-buster-tensorflow-multistage-minimal-dependencies .
# # docker run -it --rm app-slim-buster-tensorflow-multistage-minimal-dependencies

########################## Smallest - multistage and optimized tensorflow - removed unnecessary dependencies - optimized ##########################

# # First stage: Builder
# FROM python:3.9-slim-buster AS builder

# LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# # Install necessary system libraries and dependencies in the builder stage
# RUN apt-get update -y && apt-get install -y --no-install-recommends \
#   gcc \
#   libpq-dev \
#   && python -m pip install --no-cache-dir --upgrade pip \
#   && python -m pip install --no-cache-dir numpy==1.21.4 \
#   && python -m pip install --no-cache-dir tensorflow \
#   && apt-get remove -y gcc libpq-dev \
#   && apt-get autoremove -y \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/*

# # Second stage: Final slim image
# FROM python:3.9-slim-buster

# # Copy only necessary files from the builder stage
# COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
# COPY --from=builder /usr/local/bin /usr/local/bin

# # Set the working directory
# WORKDIR /app

# # Copy the TensorFlow Lite model and inference script
# COPY mobilenet_model.tflite /app/mobilenet_model.tflite
# COPY inference_tensorflow.py /app/inference_tensorflow.py
# COPY imagenet_labels.txt /app/imagenet_labels.txt

# # Set the default command to run the inference script
# CMD ["python", "inference_tensorflow.py"]

# docker build -t inference-slim-buster-tensorflow-multistage-minimal-dependencies-optimized .
# docker run -it --rm inference-slim-buster-tensorflow-multistage-minimal-dependencies-optimized

########################## Smallest - multistage and optimized tflite - removed unnecessary dependencies ##########################

# # First stage: Builder
FROM python:3.9-slim-buster AS builder

LABEL author="Zoltan Czako https://github.com/CzakoZoltan08"

# Install necessary system libraries and dependencies in the builder stage
RUN apt-get update -y && apt-get install -y --no-install-recommends \
  gcc \
  libpq-dev \
  && python -m pip install --no-cache-dir --upgrade pip \
  && python -m pip install --no-cache-dir numpy==1.21.4 \
  && python -m pip install --no-cache-dir tflite_runtime==2.7.0 \
  && python -m pip install --no-cache-dir flask==3.0.3 \
  && python -m pip install --no-cache-dir pillow==10.4.0 \
  && apt-get remove -y gcc libpq-dev \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Second stage: Final slim image
FROM python:3.9-slim-buster

# Copy only necessary files from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Set the working directory
WORKDIR /app

# Copy the TensorFlow Lite model and inference script
COPY mobilenet_model.tflite inference_tflite.py imagenet_labels.txt app.py /app/

# # Set the default command to run the inference script
# CMD ["python", "inference_tflite.py"]

# # docker build -t inference-slim-buster-tflite-multistage-minimal-dependencies-optimized .
# # docker run -it --rm inference-slim-buster-tflite-multistage-minimal-dependencies-optimized

# Expose the port the app runs on
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]

# docker build -t app-slim-buster-tensorflow-multistage-minimal-dependencies-optimized .
# docker run -p 5000:5000 app-slim-buster-tensorflow-multistage-minimal-dependencies-optimized

##### Also demonstarte that we can win 100MB with # Optional: Enable optimizations (like quantization)
#####    converter.optimizations = [tf.lite.Optimize.DEFAULT]