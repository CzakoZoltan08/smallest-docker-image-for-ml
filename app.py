import numpy as np
import tflite_runtime.interpreter as tflite

from flask import Flask, request, jsonify
from PIL import Image

# Initialize Flask app
app = Flask(__name__)

# Load the TensorFlow Lite model
model_path = "mobilenet_model.tflite"
interpreter = tflite.Interpreter(model_path=model_path)
interpreter.allocate_tensors()

# Get input and output details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Helper function to preprocess input image
def preprocess_image(image):
    # Resize the image to 224x224 (expected size for MobileNetV2)
    image = image.resize((224, 224))
    # Convert the image to a NumPy array
    img_array = np.array(image, dtype=np.float32)
    # Normalize the image to the range [-1, 1]
    img_array = (img_array / 127.5) - 1.0
    # Add a batch dimension (1, 224, 224, 3)
    img_array = np.expand_dims(img_array, axis=0)
    return img_array

# Route to handle prediction requests
@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get the image file from the POST request
        if 'file' not in request.files:
            return jsonify({'error': 'No file part'})
        
        file = request.files['file']
        
        if file.filename == '':
            return jsonify({'error': 'No selected file'})

        # Open the image file
        image = Image.open(file.stream)

        # Preprocess the image
        input_data = preprocess_image(image)

        # Set input tensor
        interpreter.set_tensor(input_details[0]['index'], input_data)

        # Run inference
        interpreter.invoke()

        # Get the output
        output_data = interpreter.get_tensor(output_details[0]['index'])

        # Get the predicted class (argmax)
        predicted_class = np.argmax(output_data)

        # Load ImageNet class labels
        with open("imagenet_labels.txt", "r") as f:
            labels = [line.strip() for line in f.readlines()]

        # Get the label corresponding to the predicted index
        predicted_label = labels[predicted_class]

        predicted_class_name = predicted_label[predicted_label.index("'") + 1 : predicted_label.rindex("'")]

        # Return the predicted class as JSON
        return jsonify(
            {
                'predicted_class_index': int(predicted_class),
                'predicted_class_name': predicted_class_name
            })

    except Exception as e:
        return jsonify({'error': str(e)})

# Main entry point
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
