import socket
from TTS.api import TTS

tts = TTS(model_name="tts_models/en/ljspeech/tacotron2-DDC", progress_bar=False)

HOST = '127.0.0.1'
PORT = 1337

def speak_text(text):
    print(f"[TTS] {text}")
    tts.tts_to_file(text=text, file_path="say.wav")
    os.system("aplay say.wav")

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    print("TTS Backend Listening...")
    while True:
        conn, _ = s.accept()
        with conn:
            data = conn.recv(1024)
            if data:
                speak_text(data.decode())
