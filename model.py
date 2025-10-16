import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import numpy as np
import os
import cv2
from sklearn.model_selection import train_test_split
# Define dataset directory
data_dir = "dataset/"
categories = ["glioma", "meningioma", "no_tumor", "pituitary"]
img_size = 256

X = []
y = []

# Load images and labels
for category in categories:
    path = os.path.join(data_dir, category)
    label = categories.index(category)

    for img_name in os.listdir(path):
        try:
            img_path = os.path.join(path, img_name)
            img = cv2.imread(img_path, cv2.IMREAD_GRAYSCALE)  # Read as grayscale
            img = cv2.resize(img, (img_size, img_size))  # Resize
            X.append(img)
            y.append(label)
        except Exception as e:
            print(f"Error loading image {img_name}: {e}")

# Convert lists to numpy arrays
X = np.array(X).reshape(-1, img_size, img_size, 1) / 255.0  # Normalize
y = np.array(y)

# Split dataset into training and validation sets
X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=42)
model = keras.Sequential([
    layers.Conv2D(64, (3,3), activation='relu', input_shape=(img_size, img_size, 1)),
    layers.MaxPooling2D(2,2),

    layers.Conv2D(128, (3,3), activation='relu'),
    layers.MaxPooling2D(2,2),

    layers.Conv2D(256, (3,3), activation='relu'),
    layers.MaxPooling2D(2,2),

    layers.Flatten(),
    layers.Dense(256, activation='relu'),
    layers.Dropout(0.5),  # Prevent overfitting
    layers.Dense(4, activation='softmax')  # 4 classes
])

model.compile(optimizer='adam', 
              loss='sparse_categorical_crossentropy', 
              metrics=['accuracy'])
model.fit(X_train, y_train, epochs=20, validation_data=(X_val, y_val))
model.save("brain_tumor_model.h5")
