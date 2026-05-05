#!/usr/bin/env python3
"""
Resize app icon for iOS - generate all required sizes
"""

from PIL import Image
import os
import json

input_image_path = "assets/images/Icon-1024.png"

if not os.path.exists(input_image_path):
    print(f"Error: {input_image_path} not found!")
    exit(1)

# Open the image
img = Image.open(input_image_path)
print(f"Original image size: {img.size}")

# iOS icon sizes based on Contents.json
ios_sizes = {
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png": (20, 20),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png": (40, 40),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png": (60, 60),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png": (29, 29),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png": (58, 58),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png": (87, 87),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png": (40, 40),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png": (80, 80),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png": (120, 120),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png": (120, 120),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png": (180, 180),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png": (76, 76),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png": (152, 152),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png": (167, 167),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png": (1024, 1024),
}

print("\nGenerating iOS icons...")
for path, size in ios_sizes.items():
    # Create directory if it doesn't exist
    os.makedirs(os.path.dirname(path), exist_ok=True)
    
    # Resize image
    resized_img = img.resize(size, Image.Resampling.LANCZOS)
    
    # Save
    resized_img.save(path, "PNG")
    print(f"✓ Created {os.path.basename(path)} ({size[0]}x{size[1]})")

print("\n✅ All iOS icons created successfully!")
