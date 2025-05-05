#include <amxmodx>
#include <reapi>
#include <sockets>

new const HOST[] = "127.0.0.1";
new const PORT = 1337;
new const MAX_RETRIES = 3;

public plugin_init() {
    register_plugin("sayBridge", "0.01", "Lukas Olson");
    register_message(get_user_msgid("SayText"), "onSayText");
}

public onSayText(msgid, dest, id) {
    static message[192];
    get_msg_arg_string(2, message, charsmax(message));

    send_to_python(message);
    return PLUGIN_CONTINUE;
}

send_to_python(const text[]) {
    new error, sock, retries = 0;
    while (retries < MAX_RETRIES) {
        sock = socket_open(HOST, PORT, SOCKET_TCP, error);

        if (sock > 0 && socket_is_writable(sock)) {
            log_amx("[sayBridge] Connected to %s:%d (attempt %d)", HOST, PORT, retries + 1);
            if (socket_send(sock, text, strlen(text)) < 0) {
                log_amx("[sayBridge] Failed to send data.");
            }
            socket_close(sock);
            return;
        } else {
            log_amx("[sayBridge] Attempt %d: Socket not writable or failed to connect. Error code: %d", retries + 1, error);
            if (sock > 0) {
                socket_close(sock);
            }
            retries++;
        }
    }
    log_amx("[sayBridge] All retry attempts failed.");
}
