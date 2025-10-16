import tkinter as tk
from tkinter import filedialog, Label, Button, ttk
from PIL import Image, ImageTk
import detect  # Import the tumor detection function

# Dictionary for tumor symptoms and treatments
tumor_info = {
    "Meningiomas": {
        "Symptoms": "- Headaches\n- Vision problems\n- Seizures\n- Memory loss",
        "Treatment": "- Surgery\n- Radiation therapy\n- Medication",
    },
    "Pituitary": {
        "Symptoms": "- Hormonal imbalance\n- Fatigue\n- Vision loss\n- Nausea",
        "Treatment": "- Surgery\n- Hormone therapy\n- Radiation therapy",
    },
    "Gliomas": {
        "Symptoms": "- Persistent headaches\n- Seizures\n- Speech difficulty\n- Weakness",
        "Treatment": "- Surgery\n- Chemotherapy\n- Radiation therapy",
    },
    "No Tumor": {
        "Symptoms": "No tumor detected.",
        "Treatment": "No treatment required.",
    },
}

# Function to upload image and perform tumor detection
def upload_image():
    file_path = filedialog.askopenfilename(filetypes=[("Image Files", "*.jpg;*.png;*.jpeg")])
    if file_path:
        # Open and resize image
        img = Image.open(file_path)
        img = img.resize((300, 300))
        img = ImageTk.PhotoImage(img)

        # Update GUI with selected image
        panel.config(image=img)
        panel.image = img

        # Perform tumor detection
        result, confidence = detect.detect_tumor(file_path)
        
        # Update label with prediction
        result_label.config(text=f"Tumor Type: {result}", 
                            fg="green" if result == "No Tumor" else "red")
        
        # Update Learn section
        learn_text.set(f"SYMPTOMS:\n{tumor_info[result]['Symptoms']}\n\n"
                       f"TREATMENTS:\n{tumor_info[result]['Treatment']}")

# Create GUI window
root = tk.Tk()
root.title("Brain Tumor Detection")
root.geometry("550x650")

# Set background image
bg_image = Image.open("background.jpg")  # Add a suitable background image
bg_image = bg_image.resize((550, 650))
bg_photo = ImageTk.PhotoImage(bg_image)
bg_label = Label(root, image=bg_photo)
bg_label.place(relwidth=1, relheight=1)

# Create tabbed interface
notebook = ttk.Notebook(root)
notebook.pack(expand=True, fill="both", pady=10)

# Scan Tab
scan_frame = tk.Frame(notebook, bg="white")
notebook.add(scan_frame, text="Scan")

upload_btn = Button(scan_frame, text="Upload MRI Image", command=upload_image, font=("Arial", 12), bg="#4CAF50", fg="white")
upload_btn.pack(pady=10)

panel = Label(scan_frame, bg="white")
panel.pack()

result_label = Label(scan_frame, text="Tumor Type: ", font=("Arial", 14), bg="White")
result_label.pack(pady=10)

# Learn Tab
learn_frame = tk.Frame(notebook, bg="white")
notebook.add(learn_frame, text="Learn")

learn_text = tk.StringVar()
learn_label = Label(learn_frame, textvariable=learn_text, font=("Arial", 12), justify="left", bg="White")
learn_label.pack(pady=20, padx=20)

# Buttons at the bottom
button_frame = tk.Frame(root, bg="white")
button_frame.pack(side="bottom", pady=20)

scan_btn = Button(button_frame, text="Scan", command=lambda: notebook.select(scan_frame), font=("Arial", 14, "bold"), bg="#008CBA", fg="white", width=10, height=2)
scan_btn.pack(side="left", padx=20)

learn_btn = Button(button_frame, text="Learn", command=lambda: notebook.select(learn_frame), font=("Arial", 14, "bold"), bg="#f39c12", fg="white", width=10, height=2)
learn_btn.pack(side="right", padx=20)

root.mainloop()
