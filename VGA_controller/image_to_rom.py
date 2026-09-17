import sys
from PIL import Image

def image_to_rom_hex(input_image_path, output_hex_path):
    # Target resolution for ROM
    TARGET_WIDTH = 320
    TARGET_HEIGHT = 240

    try:
        # Open and convert image to 24-bit RGB (R, G, B)
        img = Image.open("canada.jpg").convert('RGB')
        
        # Resize image using anti-aliasing resampling
        img = img.resize((TARGET_WIDTH, TARGET_HEIGHT), Image.Resampling.LANCZOS)

        with open(output_hex_path, 'w') as hex_file:
            # Iterate through pixels row by row
            for y in range(TARGET_HEIGHT):
                for x in range(TARGET_WIDTH):
                    r, g, b = img.getpixel((x, y))
                    
                    # Format as 24-bit Hex string: RRRGGGBBB (2 hex chars per channel)
                    hex_val = f"{r:02X}{g:02X}{b:02X}\n"
                    
                    hex_file.write(hex_val)

        print(f"Success: Processed {TARGET_WIDTH}x{TARGET_HEIGHT} image.")
        print(f"Output saved to: {output_hex_path}")

    except Exception as e:
        print(f"Error processing image: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python image_to_rom.py <input_image> <output_hex>")
        sys.exit(1)

    image_to_rom_hex(sys.argv[1], sys.argv[2])