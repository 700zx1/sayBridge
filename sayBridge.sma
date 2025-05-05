#include <amxmodx>
#include <reapi>

new const HOST[] = "127.0.0.1";
new const PORT = 1337;

public plugin_init() {
    register_plugin("sayBridge", "0.01", "Lukas Olson");
    register_message(get_user_msgid("SayText"), "onSayText");
}

public onSayText(msgid, dest, id) {
    static message[192];
    get_user_msg_arg_string(2, message, charsmax(message));

    send_to_python(message);
    return PLUGIN_CONTINUE;
}

send_to_python(const text[]) {
    new socket = socket_open(HOST, PORT, SOCKET_TCP, SOCKET_NBIO);
    if (socket > 0) {
        socket_send(socket, text, strlen(text));
        socket_close(socket);
    }
}
