import tflite_runtime.interpreter as tflite
import numpy as np

# Load the TensorFlow Lite model
interpreter = tflite.Interpreter(model_path="mobilenet_model.tflite")
interpreter.allocate_tensors()

# Get input and output tensors
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Prepare dummy input data
input_data = np.array(np.random.random_sample(input_details[0]['shape']), dtype=np.float32)

# Set input tensor
interpreter.set_tensor(input_details[0]['index'], input_data)

# Run inference
interpreter.invoke()

# Get output data
output_data = interpreter.get_tensor(output_details[0]['index'])
print("Inference result:", output_data)

# Find the index of the highest probability (argmax)
predicted_index = np.argmax(output_data[0])

print(f"Predicted class index: {predicted_index}")

# Load ImageNet class labels
with open("imagenet_labels.txt", "r") as f:
    labels = [line.strip() for line in f.readlines()]

# Get the label corresponding to the predicted index
predicted_label = labels[predicted_index]
print(f"Predicted label: {predicted_label}")