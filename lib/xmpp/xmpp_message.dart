import 'dart:convert';
import 'package:xml/xml.dart';

class XmppMessage {
  static String buildStreamOpen(String domain) {
    return "<open xmlns='urn:ietf:params:xml:ns:xmpp-framing' to='$domain' version='1.0'/>";
  }

  static String buildAuthPlain(String jid, String password) {
    final username = jid.split('@')[0];
    final authStr = '\u0000$username\u0000$password';
    final authB64 = base64Encode(utf8.encode(authStr));

    final builder = XmlBuilder();
    builder.element('auth', nest: () {
      builder.attribute('xmlns', 'urn:ietf:params:xml:ns:xmpp-sasl');
      builder.attribute('mechanism', 'PLAIN');
      builder.text(authB64);
    });
    return builder.buildDocument().toXmlString();
  }

  static String buildMessage(String to, String text) {
    final builder = XmlBuilder();
    builder.element('message', nest: () {
      builder.attribute('to', to);
      builder.attribute('type', 'chat');
      builder.element('body', nest: text);
    });
    return builder.buildDocument().toXmlString();
  }
}
