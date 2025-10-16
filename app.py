from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
import cv2
import os

app = Flask(__name__)
CORS(app)

# Load model
model = tf.keras.models.load_model("brain_tumor_model.h5")

# Classes and config
categories = ["Gliomas", "Meningiomas", "No Tumor", "Pituitary"]
img_size = 256

# Track statistics
scan_stats = {
    "total_scans": 0,
    "tumor_detected": 0,
    "no_tumor": 0
}

# Load reference MRI histograms
reference_histograms = []
reference_dir = "mri_references/"
for ref_img in os.listdir(reference_dir):
    img_path = os.path.join(reference_dir, ref_img)
    img = cv2.imread(img_path, cv2.IMREAD_GRAYSCALE)
    img = cv2.resize(img, (img_size, img_size))
    hist = cv2.calcHist([img], [0], None, [256], [0, 256])
    hist = cv2.normalize(hist, hist).flatten()
    reference_histograms.append(hist)

def is_mri_image(image, threshold=0.7):
    image_hist = cv2.calcHist([image], [0], None, [256], [0, 256])
    image_hist = cv2.normalize(image_hist, image_hist).flatten()
    scores = [cv2.compareHist(image_hist, ref, cv2.HISTCMP_CORREL) for ref in reference_histograms]
    return max(scores) >= threshold

def detect_tumor(img_array):
    img = cv2.resize(img_array, (img_size, img_size))
    img = img.reshape(1, img_size, img_size, 1) / 255.0
    prediction = model.predict(img)
    predicted_class = np.argmax(prediction)
    confidence = float(np.max(prediction))
    return categories[predicted_class], confidence

@app.route("/predict", methods=["POST"])
def predict():
    if 'image' not in request.files:
        return jsonify({"error": "No image part in the request"}), 400

    file = request.files['image']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    try:
        file_bytes = np.frombuffer(file.read(), np.uint8)
        img = cv2.imdecode(file_bytes, cv2.IMREAD_GRAYSCALE)

        if img is None:
            return jsonify({"error": "Invalid image file"}), 400

        if not is_mri_image(img):
            return jsonify({"error": "Image is not a valid MRI scan"}), 400

        result, confidence = detect_tumor(img)

        # Update stats
        scan_stats["total_scans"] += 1
        if result == "No Tumor":
            scan_stats["no_tumor"] += 1
        else:
            scan_stats["tumor_detected"] += 1

        return jsonify({
            "tumor_type": result,
            "confidence": round(confidence, 2),
            "stats": scan_stats
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)