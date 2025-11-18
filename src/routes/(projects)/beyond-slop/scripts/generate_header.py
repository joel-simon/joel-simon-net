import torch
from diffusers import AutoencoderTiny
from PIL import Image
import numpy as np
from pathlib import Path
import argparse


def round_to_nearest(x, multiple):
    return round(x / multiple) * multiple


def image_to_tensor(img, device):
    """Convert PIL image to tensor for VAE"""
    img = img.convert("RGB")
    width = round_to_nearest(img.width, 16)
    height = round_to_nearest(img.height, 16)
    img = img.resize((width, height))  # Resize to standard size
    img_array = np.array(img).astype(np.float32) / 255.0
    img_array = img_array * 2.0 - 1.0  # Normalize to [-1, 1]
    img_tensor = torch.from_numpy(img_array).permute(2, 0, 1).unsqueeze(0)
    return img_tensor.to(device)


def tensor_to_image(tensor):
    """Convert tensor back to PIL image"""
    img_array = tensor.squeeze(0).permute(1, 2, 0).cpu().numpy()
    img_array = (img_array + 1.0) / 2.0  # Denormalize from [-1, 1] to [0, 1]
    img_array = np.clip(img_array * 255.0, 0, 255).astype(np.uint8)
    return Image.fromarray(img_array)


def encode_decode_cycle(vae, img_tensor):
    """One encode/decode cycle through the VAE"""
    with torch.no_grad():
        latent = vae.encode(img_tensor).latents
        reconstructed = vae.decode(latent).sample
    return reconstructed


def create_degradation_sequence(input_image_path, num_cycles=10, output_dir="output"):
    """Create sequence of increasingly degraded images"""

    # Setup
    # Check for MPS, CUDA, then fallback to CPU
    if torch.backends.mps.is_available():
        device = "mps"
    elif torch.cuda.is_available():
        device = "cuda"
    else:
        device = "cpu"
    print(f"Using device: {device}")

    # Load TinyVAE
    print("Loading TinyVAE...")
    vae = AutoencoderTiny.from_pretrained(
        "madebyollin/taesdxl",
        torch_dtype=torch.float16 if device == "cuda" else torch.float32,
    )
    vae = vae.to(device)
    vae.eval()

    # Load and prepare input image
    print(f"Loading image: {input_image_path}")
    input_img = Image.open(input_image_path)
    img_tensor = image_to_tensor(input_img, device)

    # Create output directory
    output_path = Path(output_dir)
    output_path.mkdir(exist_ok=True)

    # Generate degradation sequence
    frames = []
    print(f"Generating {num_cycles} degradation cycles...")

    # Save original
    original_pil = tensor_to_image(img_tensor)
    frames.append(original_pil)
    original_pil.save(output_path / "frame_000.png")

    current_tensor = img_tensor

    for i in range(num_cycles):
        print(f"Cycle {i+1}/{num_cycles}")
        current_tensor = encode_decode_cycle(vae, current_tensor)

        # Convert to PIL and save
        frame = tensor_to_image(current_tensor)
        frames.append(frame)
        frame.save(output_path / f"frame_{i+1:03d}.png")

    print(f"\nSaved {len(frames)} frames to {output_path}")

    # Create video with forward and reverse (loop)
    print("Creating video loop...")
    create_video_loop(frames, output_path / "degradation_loop.mp4", fps=10)

    return frames


def create_video_loop(frames, output_path, fps=10):
    """Create a looping video from frames (forward then reverse)"""
    try:
        import cv2

        # Create forward + reverse sequence for seamless loop
        all_frames = frames + frames[-2:0:-1]  # Exclude first/last to avoid duplicate

        # Get dimensions from first frame
        height, width = np.array(all_frames[0]).shape[:2]

        # Create video writer
        fourcc = cv2.VideoWriter_fourcc(*"mp4v")
        out = cv2.VideoWriter(str(output_path), fourcc, fps, (width, height))

        for frame in all_frames:
            # Convert PIL to OpenCV format (RGB to BGR)
            frame_array = cv2.cvtColor(np.array(frame), cv2.COLOR_RGB2BGR)
            out.write(frame_array)

        out.release()
        print(f"Video saved to {output_path}")

    except ImportError:
        print("OpenCV not available, skipping video creation")
        print("Install with: pip install opencv-python")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Demonstrate VAE encoding loss")
    parser.add_argument("input_image", type=str, help="Path to input image")
    parser.add_argument(
        "--cycles", type=int, default=10, help="Number of encode/decode cycles"
    )
    parser.add_argument("--output", type=str, default="output", help="Output directory")

    args = parser.parse_args()

    create_degradation_sequence(args.input_image, args.cycles, args.output)
