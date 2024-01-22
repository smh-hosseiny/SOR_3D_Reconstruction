import sys
from PIL import Image
import os
from rembg import remove
import numpy as np


def remove_bg():
    # Check if the correct number of command-line arguments is provided
    if len(sys.argv) != 3:
        print("Usage: python remove_bg.py <input_image_path> <output_directory>")
        sys.exit(1)

    # Extract command-line arguments
    img_path = sys.argv[1]
    output_dir = sys.argv[2]

    # Load the input image
    input_image = Image.open(img_path)

    # Remove background
    output_image = remove(input_image)
    binary_mask = (np.array(output_image) > 0).any(axis=2)
    binary_mask_pil = Image.fromarray(binary_mask.astype('uint8') * 255)

    # output_image = output_image.convert("RGB")

    # Construct the output image path
    img_name = os.path.basename(img_path)
    img_name_no_ext, img_ext = os.path.splitext(img_name)
    output_img_path = os.path.join(output_dir, f"{img_name_no_ext}_mask{img_ext}")
    print(output_img_path)
    # Save the output image
    binary_mask_pil.save(output_img_path)

if __name__ == '__main__':
    remove_bg()
