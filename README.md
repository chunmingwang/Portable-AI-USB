# 🔒 Portable Uncensored AI — Runs Entirely from a USB Drive

A **fully private, portable, uncensored AI assistant** that runs 100% from a USB flash drive. No internet needed after setup. No data leaves the USB. Works on both **Windows** and **Mac**.

## 📺 Watch the Tutorial

[![Portable AI USB Tutorial](https://img.youtube.com/vi/cqrMfO6AZRU/maxresdefault.jpg)](https://youtu.be/cqrMfO6AZRU)


## ⚡ What's Inside

| Component | Purpose |
|-----------|---------|
| **Dolphin 2.9 LLaMA 3 8B** | Uncensored AI model (~5.7 GB) |
| **Ollama** | Lightweight AI engine that runs the model |
| **AnythingLLM** | Beautiful chat interface |

## 🚀 Setup (One Time Only)

### What You Need
- A USB flash drive with **at least 16 GB** of free space (32 GB recommended)
- Format the USB as **exFAT** (works on both Windows and Mac)
- An internet connection for the initial download (~6 GB total)

### Steps

1. **Download this repo** and copy ALL files to your USB drive
2. **Double-click `install.bat`** on the USB drive
3. Wait for everything to download (~15-30 minutes depending on internet speed)
4. **Done!** Your portable AI is ready to use

### ⚠️ If the Model Download Fails

The AI model (~5.7 GB) is the largest download. If it fails or gets interrupted:

1. **Download the model manually** from HuggingFace:  
   👉 [dolphin-2.9-llama3-8b-Q5_K_M.gguf](https://huggingface.co/bartowski/dolphin-2.9-llama3-8b-GGUF/resolve/main/dolphin-2.9-llama3-8b-Q5_K_M.gguf)

2. **Place the downloaded file** into the `models\` folder on your USB:
   ```
   USB Drive\
   └── models\
       └── dolphin-2.9-llama3-8b-Q5_K_M.gguf   ← put it here
   ```

3. **Re-run `install.bat`** — it will detect the model and skip the download automatically

## ▶️ How to Use

### On Windows
- Double-click **`start-windows.bat`** on the USB drive
- The AnythingLLM chat window will open automatically
- Keep the black terminal window open while chatting
- Press any key in the terminal to safely shut down

### On Mac
- Double-click **`start-mac.command`** on the USB drive  
- First time: It will automatically download the Mac engine (~2 min)
- The AnythingLLM window will open automatically
- Press ENTER in the terminal to safely shut down

## 🔐 Privacy

- **All chats & settings stay on the USB** — never saved to the host PC
- A shortcut (junction link) is created in `AppData` on first run to redirect AnythingLLM's data path to the USB — this is the only trace left on the host computer
- Works completely offline after initial setup
- No telemetry, no cloud, no tracking

## 📁 USB Drive Structure (After Setup)

```
USB Drive/
├── install.bat             ← Run this first (one time only)
├── install-core.ps1        ← Setup script (called by install.bat)
├── start-windows.bat       ← Windows launcher
├── start-mac.command       ← Mac launcher
├── ollama/                 ← AI engine (Windows)
├── ollama_mac/             ← AI engine (Mac, auto-downloaded)
├── models/                 ← AI model files
├── anythingllm/            ← Chat interface installer
├── anythingllm_app/        ← Chat interface app (extracted on first run)
└── anythingllm_data/       ← Your chats & settings (portable!)
```

## ⚠️ Important Notes

- **First launch ever** — AnythingLLM needs to be extracted to the USB. This takes:
  - ⚡ Fast USB (USB 3.0+): **1–3 minutes**
  - 🐢 Slow USB (USB 2.0): **up to 30–40 minutes** — do NOT close the window!
- **First launch on a new computer** after extraction may take 30–60 seconds to load
- The AI runs on your **CPU** — responses take 10–30 seconds depending on hardware
- If you have a **GPU**, responses will be much faster
- Always **safely eject** the USB before unplugging

## 📜 License

MIT License — See [LICENSE](LICENSE) for details.
