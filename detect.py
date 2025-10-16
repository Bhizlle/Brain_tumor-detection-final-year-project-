import tensorflow as tf
import numpy as np
import cv2

# Load trained model
model = tf.keras.models.load_model("brain_tumor_model.h5")

# Define class labels
categories = ["Gliomas", "Meningiomas", "No Tumor", "Pituitary"]

# Image size (should match model input size)
img_size = 256
def detect_tumor(image_path):
    # Load and preprocess image
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    img = cv2.resize(img, (img_size, img_size))
    img = img.reshape(1, img_size, img_size, 1) / 255.0  # Normalize and reshape

    # Predict using model
    prediction = model.predict(img)
    predicted_class = np.argmax(prediction)  # Get index of max probability
    confidence = np.max(prediction)  # Confidence score

    return categories[predicted_class], confidence
if __name__ == "__main__":
    test_image = "dataset/glioma/g.jpg"  # Replace with actual test image path
    result, confidence = detect_tumor(test_image)
    print(f"Predicted Tumor Type: {result} (Confidence: {confidence:.2f})")
