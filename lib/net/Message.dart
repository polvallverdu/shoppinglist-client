import 'package:shoppinglistclient/net/socket.dart';

class Message {
  MessageType type;
  Map<String, dynamic>? data;

  Message(this.type, [this.data = const {}]);

  Message.fromJson(Map<String, dynamic> json)
      : type = MessageType.values[json['type']],
        data = json['data'];

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'data': data,
      };
}
