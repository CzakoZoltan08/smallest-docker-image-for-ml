import tensorflow as tf


def main():
    # Load the MobileNetV2 model pre-trained on ImageNet, with weights and include top layers
    model = tf.keras.applications.MobileNetV2(
        input_shape=(224, 224, 3),
        include_top=True,  # Use True to include the fully-connected layer at the top of the network
        weights='imagenet'  # Load weights pre-trained on ImageNet
    )

    # Save the model in the SavedModel format
    model.export('mobilenet_model')

    print("MobileNet model saved as 'mobilenet_model'")

    # Path to the saved MobileNet model directory
    saved_model_dir = 'mobilenet_model'

    # Convert the MobileNet model to TensorFlow Lite format
    converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)

    # Optional: Enable optimizations (like quantization)
    # converter.optimizations = [tf.lite.Optimize.DEFAULT]

    tflite_model = converter.convert()

    # Save the converted model to a .tflite file
    tflite_model_path = "mobilenet_model.tflite"
    with open(tflite_model_path, "wb") as f:
        f.write(tflite_model)

    print(f"Model successfully converted to {tflite_model_path}")


if __name__ == "__main__":
    main()