#!/usr/bin/env python3
"""
Resize app icon to all required sizes for Flutter app (Android, iOS, Web)
"""

from PIL import Image
import os
import shutil

# Input image - you'll need to place your image here
input_image_path = "assets/images/app_icon_original.png"

# Check if input image exists
if not os.path.exists(input_image_path):
    print(f"Error: {input_image_path} not found!")
    print("Please make sure you've saved your icon image to: assets/images/app_icon_original.png")
    exit(1)

# Open the image
try:
    img = Image.open(input_image_path)
    print(f"Original image size: {img.size}")
except Exception as e:
    print(f"Error opening image: {e}")
    exit(1)

# Define all sizes needed
icon_sizes = {
    # Android
    "android/app/src/main/res/mipmap-mdpi/ic_launcher.png": (48, 48),
    "android/app/src/main/res/mipmap-hdpi/ic_launcher.png": (72, 72),
    "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png": (96, 96),
    "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png": (144, 144),
    "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png": (192, 192),
    # Web
    "web/icons/Icon-192.png": (192, 192),
    "web/icons/Icon-512.png": (512, 512),
    "web/icons/Icon-maskable-192.png": (192, 192),
    "web/icons/Icon-maskable-512.png": (512, 512),
}

# Resize and save
print("\nResizing and saving icons...")
for path, size in icon_sizes.items():
    # Create directory if it doesn't exist
    os.makedirs(os.path.dirname(path), exist_ok=True)
    
    # Resize image
    resized_img = img.resize(size, Image.Resampling.LANCZOS)
    
    # Save
    resized_img.save(path, "PNG")
    print(f"✓ Created {path} ({size[0]}x{size[1]})")

print("\n✅ All icons created successfully!")
print("\nNext step: For iOS, you'll need to upload the 1024x1024 image manually to Xcode")
print("Or place: Icon-1024.png in web/icons/Icon-1024.png")

# Also create a 1024x1024 for iOS/reference
ios_size = (1024, 1024)
resized_img_ios = img.resize(ios_size, Image.Resampling.LANCZOS)
resized_img_ios.save("assets/images/Icon-1024.png", "PNG")
print("✓ Created assets/images/Icon-1024.png (1024x1024) - for iOS reference")
