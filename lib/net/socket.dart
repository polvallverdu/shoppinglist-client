import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/localDb/DBClient.dart';
import 'package:shoppinglistclient/net/Item.dart';
import 'package:shoppinglistclient/net/Message.dart';
import 'package:shoppinglistclient/net/notifiers/ItemsListNotifier.dart';
import 'package:shoppinglistclient/net/notifiers/SocketStatusNotifier.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum MessageType {
  CONNECTED,
  AUTH,
  LOGGED,
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
  DISCONNECT,
}

enum SocketStatus {
  CONNECTING,
  CONNECTED,
  LOGGED,
  DISCONNECTED,
  FAILED_CONNECTION,
}

extension SocketStatusExtension on SocketStatus {
  String get message {
    switch (this) {
      case SocketStatus.CONNECTING:
        return 'Conectando...';
      case SocketStatus.CONNECTED:
        return 'Conectado';
      case SocketStatus.LOGGED:
        return 'Logeado';
      case SocketStatus.DISCONNECTED:
        return 'Desconectado';
      case SocketStatus.FAILED_CONNECTION:
        return 'Fallo en la conexión';
    }
  }

  Color get color {
    switch (this) {
      case SocketStatus.CONNECTING:
        return Colors.yellow;
      case SocketStatus.CONNECTED:
        return Colors.green;
      case SocketStatus.LOGGED:
        return Colors.green;
      case SocketStatus.DISCONNECTED:
        return Colors.red;
      case SocketStatus.FAILED_CONNECTION:
        return Colors.red;
    }
  }
}

final socketStatusNotifier = SocketStatusNotifier();
final _socketStatusProvider =
    StateNotifierProvider<SocketStatusNotifier, SocketStatus>((ref) {
  return socketStatusNotifier;
});

final itemNotifier = ItemsListNotifier();
final _itemsProvider =
    StateNotifierProvider<ItemsListNotifier, List<Item>>((ref) {
  return itemNotifier;
});

class ClientSocket {
  WebSocketChannel? channel = null;
  bool connected = false;

  static final ClientSocket _instance = ClientSocket._internal();

  factory ClientSocket() {
    return _instance;
  }

  ClientSocket._internal();

  void _handleMessage(dynamic rawmessage) {
    var demsg = json.decode(rawmessage);
    final message = Message.fromJson(demsg);

    switch (message.type) {
      case MessageType.CONNECTED:
        connected = true;
        socketStatusNotifier.setStatus(SocketStatus.CONNECTED);
        break;
      case MessageType.LOGGED:
        socketStatusNotifier.setStatus(SocketStatus.LOGGED);
        sendMessage(MessageType.REQUEST_REFRESH);
        break;
      case MessageType.REFRESH:
        List<dynamic> items = message.data!['items'];
        List<Item> newItems = items.map((item) => Item.fromJson(item)).toList();
        itemNotifier.refresh(newItems);
        break;
      case MessageType.REMOVE_ITEM:
        itemNotifier.removeItem(message.data!['uuid']);
        break;
      case MessageType.ADD_ITEM:
        itemNotifier.addItem(
            Item.fromJson(message.data!), message.data!["index"]);
        break;
      case MessageType.REORDER_ITEM:
        itemNotifier.changeIndex(message.data!['uuid'], message.data!['index']);
        break;
      case MessageType.DISCONNECT:
        connected = false;
        socketStatusNotifier.setStatus(SocketStatus.DISCONNECTED);
    }
  }

  void connect() {
    if (channel != null) {
      channel!.sink.close(status.normalClosure);
    }

    socketStatusNotifier.setStatus(SocketStatus.CONNECTING);

    final url = dotenv.get("WEBSOCKET_URL", fallback: "ws://localhost:3000");
    print(url);
    channel = WebSocketChannel.connect(Uri.parse(url));
    channel!.stream.listen(_handleMessage,
        cancelOnError: true,
        onDone: () => disconnect(true),
        onError: (e) {
          print('here: $e');
          socketStatusNotifier.setStatus(SocketStatus.FAILED_CONNECTION);
          Future.delayed(const Duration(seconds: 5), connect);
        });
  }

  void disconnect([bool force = false]) {
    if (channel == null) {
      return;
    }

    if (!force) {
      sendMessage(MessageType.DISCONNECT);
    }
    channel!.sink.close(status.normalClosure);
    channel = null;
    connected = false;
    socketStatusNotifier.setStatus(SocketStatus.DISCONNECTED);
    Future.delayed(const Duration(seconds: 5), connect);
  }

  void sendPing() async {
    sendMessage(MessageType.PING);
  }

  Future<void> sendAuth(String password) async {
    sendMessage(
        MessageType.AUTH, {'name': Settings.getName(), 'password': password});
  }

  Future<void> sendNameChange(String newName) async {
    await sendMessage(MessageType.NAME_CHANGE, {'name': newName});
  }

  Future<void> sendAddItem(String name, [int index = 0]) async {
    await sendMessage(MessageType.REQUEST_ADD_ITEM,
        {'name': name, 'addedBy': Settings.getName(), 'index': index});
  }

  Future<void> sendUpdateItem(Item item) async {
    await sendMessage(MessageType.REQUEST_UPDATE_ITEM, {'item': item.toJson()});
  }

  Future<void> sendRemoveItem(Item item) async {
    await sendMessage(MessageType.REQUEST_REMOVE_ITEM, {"uuid": item.uuid});
  }

  Future<void> sendIndexChange(Item item, int newIndex) async {
    await sendMessage(MessageType.REQUEST_REORDER_ITEM, {
      'uuid': item.uuid,
      'index': newIndex,
    });
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

    channel!.sink.add(json.encode(message));
  }

  StateNotifierProvider<ItemsListNotifier, List<Item>> get itemsProvider =>
      _itemsProvider;

  StateNotifierProvider<SocketStatusNotifier, SocketStatus>
      get socketStatusProvider => _socketStatusProvider;

  int getIndexOfItem(Item item) {
    return itemNotifier.state.indexOf(item);
  }
}
