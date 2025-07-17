import torch

def main():
    print("✅ PyTorch version:", torch.version)
    print("🔍 CUDA available:", torch.cuda.is_available())
    print("🧠 Device count:", torch.cuda.device_count())
    if torch.cuda.is_available():
        print("🚀 Using device:", torch.cuda.get_device_name(0))
    else:
        print("⚠️ CUDA 不可用，请检查驱动或启动参数")

if __name__ == "main":
    main()