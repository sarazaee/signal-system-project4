# signal-system-project4
Advanced MATLAB pipeline for LSB image steganography (data concealment) and dynamic IR video object tracking using morphological filters and kinematic centroid validation.

# Signals and Systems — Computer Assignment 4: Steganography & Dynamic Object Tracking

This repository contains the advanced MATLAB implementations, datasets, and complete documentation for Computer Assignment 4 of the **Signals and Systems** course at the **University of Tehran, Faculty of Electrical and Computer Engineering** (Spring 2026), under the instruction of **Dr. Saeid Akhavan**.

**Author:** Seyed Ali Rezaei  
**Student ID:** 810103432  

---

## 📂 Repository Structure & Direct Links

Navigate through the steganography and tracking modules using the links below:

* **Documentation:**
  * 📄 [ca4.pdf](./ca4.pdf) — Comprehensive technical report containing deep algorithmic analyses, morphological processing workflows, and result discussions.
* **Part 1: Digital Steganography (Data Concealment):**
  * 📜 [coding.m](./coding.m) — The core encoding function that injects binary text streams into the least significant bits of a carrier image.
  * 📊 [my_mapset.mat](./my_mapset.mat) — The 5-bit binary dictionary mapping alphanumeric characters for encoding/decoding.
* **Part 2: Dynamic Video Object Tracking:**
  * 📜 [main.m](./main.m) — The master script executing the background subtraction and morphological tracking loops.

---

## 🎬 Video Tracking Outputs

Below are the dynamic execution results of the object tracking system. The bounding boxes dynamically lock onto the aerial target, navigating through high-frequency background clutter and sensor noise.

<div align="center">
  <video src="./tracked_airplane.mp4" controls="controls" width="80%"></video>
  <br><br>
  <video src="./tracked_airplane_2.mp4" controls="controls" width="80%"></video>
  <br><br>
  <video src="./tracked_airplane_3.mp4" controls="controls" width="80%"></video>
</div>

---

## 🛠️ System Configuration & Requirements

To execute this digital image processing and computer vision pipeline locally:
- **Environment:** MATLAB R2022a or newer.
- **Required Toolboxes:**
  - *Image Processing Toolbox* (Crucial for morphological operations like `strel`, `imclose`, and spatial analysis via `regionprops`).

---

## 📋 Comprehensive Technical Breakdown

This project tackles two highly complex domains of modern signal processing: covert data transmission and computer vision-based tracking.

### Part 1: Digital Steganography (Least Significant Bit Encoding)
This section explores how to securely hide textual information within a digital image without visibly altering the image to the human eye.
- **Dictionary Generation (`my_mapset.mat`):** The system first initializes a specialized $2 \times 32$ cell array. Using the `dec2bin` function, it assigns a unique 5-bit binary identifier to 26 lowercase English letters and specific punctuation marks. This 5-bit quantization optimally compresses the text data prior to injection.
- **Message Injection (`coding.m`):** The algorithm converts a target string (e.g., a secret message) into a continuous 1D binary sequence. It then iterates over the pixels of a normalized Grayscale carrier image (`myGrayImage`). 
- **LSB Manipulation:** Instead of changing primary pixel intensities, the code overwrites only the **Least Significant Bits (LSB)** of the pixel values with the message bits. Since the LSB contributes minimally to the overall color value (changing a pixel's intensity by only $\pm 1$ on a $0-255$ scale), the steganographic image looks perfectly identical to the original, masking the data securely in plain sight.

### Part 2: Dynamic Target Tracking & Morphological Noise Suppression
This section implements a highly robust object tracker designed to follow a moving target (e.g., an airplane) in an Infrared (IR) video sequence, heavily filtering out sensor artifacts and environmental noise.
- **High-Frequency Noise Removal:** Infrared sensors frequently generate random thermal noise. The algorithm first targets these artifacts by stripping away any isolated pixel clusters smaller than 15 pixels using area-opening techniques.
- **Structural Integrity & Morphological Closing:** Moving objects often appear fragmented in binary masks due to inconsistent lighting. The pipeline utilizes a circular structuring element (`strel('disk', 3)`) coupled with the `imclose` function. This specific topological filter effectively bridges gaps and fills holes within the target's binary silhouette, transforming scattered dots into a single, cohesive solid object.
- **Feature Extraction (`regionprops`):** Once the image is morphologically cleaned, the code extracts precise geometric properties for all remaining white regions—specifically their area (`Area`) and exact spatial center of mass (`Centroid`).
- **Kinematic Validation & Bounding Box Logic:** This is the most intelligent component of the pipeline. A `for` loop iterates through all detected objects in the current frame and applies a rigorous dual-filter logic:
  1. **Dimensional Consistency:** The object's `Area` must fall within a pre-defined logical bracket (`minArea` to `maxArea`). This prevents the tracker from locking onto massive background changes (like moving clouds) or tiny missed noise artifacts.
  2. **Spatial Distance Limit (Norm Validation):** The algorithm computes the Euclidean distance ($L_2$ norm) between the new object's `Centroid` and the previous known position of the target. If the distance exceeds `maxMovement`, the object is rejected as a false positive, preventing the tracker from erratically jumping across the screen.
- **Continuous Tracking (`trackBox`):** Once an object passes both filters, it is declared the `bestMatch`. The system updates its coordinate memory and draws a clean tracking rectangle over the target, maintaining a locked trajectory across the entire video timeline.

---

## 🎓 Acknowledgments
This advanced framework was developed as part of the academic curriculum for the Signals and Systems course at the **University of Tehran**. Special thanks to **Dr. Saeid Akhavan** for providing the foundational structure for these algorithms.
