import 'package:flutter/material.dart';
import '../xmpp/xmpp_client.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late XmppClient client;
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    client = XmppClient(
      jid: 'tucuenta@jabber.de',
      password: 'tuclave',
      domain: 'jabber.de',
      websocketUrl: 'wss://jabber.de:443/xmpp-websocket',
    );

    client.connect();
  }

  void sendMessage() {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      client.sendMessage('otro@jabber.hot-chilli.net', message);
      messageController.clear();
    }
  }

  @override
  void dispose() {
    client.disconnect();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('XMPP Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Mensaje'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendMessage,
              child: const Text('Enviar'),
            )
          ],
        ),
      ),
    );
  }
}
