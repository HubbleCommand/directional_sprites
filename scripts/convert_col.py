from PIL import Image
import argparse

def convert_color_to_transparency(image_path, output_path, color_from, color_to):
    image = Image.open(image_path).convert("RGBA")
    data = image.getdata()
    
    new_data = []
    
    for item in data:
        if item[:3] == color_from:
            new_data.append(color_to)
        else:
            new_data.append(item)
    image.putdata(new_data)
    image.save(output_path)

convert_color_to_transparency("_sample_doom_firing.png", "sample_doom_firing.png", (0, 255, 255), (255, 255, 255, 0))
convert_color_to_transparency("sample_doom_firing.png", "sample_doom_firing.png", (0, 128, 128), (255, 255, 255, 0))

convert_color_to_transparency("_sample_doom_pain.png", "sample_doom_pain.png", (0, 255, 255), (255, 255, 255, 0))
convert_color_to_transparency("sample_doom_pain.png", "sample_doom_pain.png", (0, 128, 128), (255, 255, 255, 0))

convert_color_to_transparency("_sample_doom_walking.png", "sample_doom_walking.png", (0, 255, 255), (255, 255, 255, 0))
convert_color_to_transparency("sample_doom_walking.png", "sample_doom_walking.png", (0, 128, 128), (255, 255, 255, 0))
