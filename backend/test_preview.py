"""Simple test script to POST a file to the /preview-only endpoint.
Requires the `requests` package (pip install requests).

If `sample.png` is not found next to this script, it will be generated on the fly
using Pillow so you can run the test without preparing an image file.
"""
import os
import requests

URL = "http://127.0.0.1:8000/preview-only"
FILE_PATH = "sample.png"  # default test image path


def ensure_sample_image(path: str = FILE_PATH):
    if os.path.exists(path):
        return path
    try:
        from PIL import Image, ImageDraw

        img = Image.new("RGB", (256, 256), color=(240, 240, 240))
        d = ImageDraw.Draw(img)
        d.rectangle([32, 32, 224, 224], outline=(255, 0, 0), width=4)
        d.text((60, 116), "Test", fill=(0, 0, 255))
        img.save(path, format="PNG")
        return path
    except Exception as e:
        raise RuntimeError(
            "Failed to generate sample image. Please place a small PNG at 'sample.png'."
        ) from e


def main():
    img_path = ensure_sample_image(FILE_PATH)
    with open(img_path, "rb") as f:
        files = {"file": (os.path.basename(img_path), f, "image/png")}
        data = {"complexity": "0.7", "depth": "7.0"}
        resp = requests.post(URL, files=files, data=data)
        print("Status:", resp.status_code)
        try:
            print(resp.json())
        except Exception:
            print(resp.text)


if __name__ == "__main__":
    main()
