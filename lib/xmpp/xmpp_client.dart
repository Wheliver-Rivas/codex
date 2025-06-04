import 'package:web_socket_channel/web_socket_channel.dart';
import 'xmpp_message.dart';

class XmppClient {
  final String jid;
  final String password;
  final String domain;
  final String websocketUrl;

  late WebSocketChannel _channel;

  XmppClient({
    required this.jid,
    required this.password,
    required this.domain,
    required this.websocketUrl,
  });

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(websocketUrl));

    _channel.stream.listen((data) {
      print('[RECEIVED] $data');

      if (data.toString().contains('<stream:features')) {
        final auth = XmppMessage.buildAuthPlain(jid, password);
        _channel.sink.add(auth);
      }

      if (data.toString().contains('<success')) {
        print('[AUTH] Success');
        _channel.sink.add(XmppMessage.buildStreamOpen(domain));
      }
    }, onError: (error) {
      print('[ERROR] $error');
    });

    // Iniciar flujo
    _channel.sink.add(XmppMessage.buildStreamOpen(domain));
  }

  void sendMessage(String toJid, String text) {
    final message = XmppMessage.buildMessage(toJid, text);
    _channel.sink.add(message);
    print('[SEND] Message to $toJid');
  }

  void disconnect() {
    _channel.sink.close();
  }
}
