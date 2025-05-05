#include <amxmodx>
#include <reapi>
#include <sockets>

new const HOST[] = "127.0.0.1";
new const PORT = 1337;

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
    new error
	new sock = socket_open(HOST, PORT, SOCKET_TCP, error);
    if (sock > 0 && socket_is_writable(sock)) {
        socket_send(sock, text, strlen(text));
        socket_close(sock);
    }
	else {
		if (sock > 0) {
			socket_close(sock);
		}
	}
}