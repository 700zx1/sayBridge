import socket
import threading
import simpleaudio as sa
from pystray import Icon, MenuItem, Menu
from PIL import Image, ImageDraw

def speak_text(text):
    try:
        wave_obj = sa.WaveObject.from_wave_file("say.wav")
        play_obj = wave_obj.play()
        play_obj.wait_done()
    except Exception as e:
        print("[TTS Playback Error]", e)

def run_server():
    sock = socket.socket()
    sock.bind(("127.0.0.1", 1337))
    sock.listen(1)
    print("[TTS] Backend Listening...")
    while True:
        conn, _ = sock.accept()
        data = conn.recv(1024)
        if not data:
            continue
        print("[TTS]", data.decode())
        # your TTS logic here, e.g., generate say.wav
        speak_text(data.decode())
        conn.close()

def create_image():
    # Simple black/white circle icon
    img = Image.new('RGB', (64, 64), color="white")
    draw = ImageDraw.Draw(img)
    draw.ellipse((16, 16, 48, 48), fill="black")
    return img

def on_quit(icon, item):
    icon.stop()

def tray_app():
    menu = Menu(MenuItem("Quit", on_quit))
    icon = Icon("sayBridge", create_image(), "sayBridge TTS", menu)
    server_thread = threading.Thread(target=run_server, daemon=True)
    server_thread.start()
    icon.run()

if __name__ == "__main__":
    tray_app()
