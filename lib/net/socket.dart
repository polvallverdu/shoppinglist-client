import 'dart:async';
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/localDb/DBClient.dart';
import 'package:shoppinglistclient/net/Item.dart';
import 'package:shoppinglistclient/net/ItemsListNotifier.dart';
import 'package:shoppinglistclient/net/Message.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

enum MessageType {
  CONNECTED,
  AUTH,
  NAME_CHANGE,
  PING,
  PONG,
  REFRESH,
  REQUEST_REFRESH,
  REQUEST_REORDER_ITEM,
  REORDER_ITEM,
  REQUEST_REMOVE_ITEM,
  REMOVE_ITEM,
  REQUEST_ADD_ITEM,
  ADD_ITEM,
  REQUEST_UPDATE_ITEM,
  UPDATE_ITEM,
}

List<Item> _items = [];
final notifier = ItemsListNotifier();
final _itemsProvider =
    StateNotifierProvider<ItemsListNotifier, List<Item>>((ref) {
  return notifier;
});

class ClientSocket {
  IOWebSocketChannel? channel = null;
  bool connected = false;

  static final ClientSocket _instance = ClientSocket._internal();

  factory ClientSocket() {
    return _instance;
  }

  ClientSocket._internal();

  void connect() {
    if (channel != null) {
      channel!.sink.close(status.normalClosure);
    }
    channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.1.41:3000'));

    channel!.stream.listen((rawmessage) {
      var demsg = json.decode(rawmessage);
      final message = Message.fromJson(demsg);

      switch (message.type) {
        case MessageType.CONNECTED:
          connected = true;
          sendMessage(MessageType.AUTH, {'name': Settings.getName()});
          sendMessage(MessageType.REQUEST_REFRESH);
          break;
        case MessageType.REFRESH:
          List<dynamic> items = message.data!['items'];
          List<Item> newItems =
              items.map((item) => Item.fromJson(item)).toList();
          notifier.refresh(newItems);
          break;
      }
    });
  }

  void sendPing() async {
    sendMessage(MessageType.PING);
  }

  Future<void> sendNameChange(String newName) async {
    await sendMessage(MessageType.NAME_CHANGE, {'name': newName});
  }

  Future<void> sendAddItem(String name) async {
    await sendMessage(MessageType.REQUEST_ADD_ITEM, {
      'name': name,
      'addedBy': Settings.getName(),
    });
  }

  Future<void> sendUpdateItem(Item item) async {
    await sendMessage(MessageType.REQUEST_UPDATE_ITEM, {'item': item.toJson()});
  }

  Future<void> sendRemoveItem(Item item) async {
    await sendMessage(MessageType.REQUEST_REMOVE_ITEM, {"uuid": item.uuid});
  }

  Future<void> sendMessage(MessageType type,
      [Map<String, dynamic> data = const {}]) async {
    if (!connected) {
      // TE JODES
      return;
    }

    var message = {
      'type': type.index,
      'data': data,
    };

    print("Sending: $message");

    channel!.sink.add(json.encode(message));
  }

  StateNotifierProvider<ItemsListNotifier, List<Item>> get itemsProvider =>
      _itemsProvider;
}
