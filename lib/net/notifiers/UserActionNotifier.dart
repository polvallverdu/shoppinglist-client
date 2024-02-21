import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/net/Item.dart';
import 'package:shoppinglistclient/net/socket.dart';

class UserActionNotifier
    extends StateNotifier<List<UserActionNotificationData>> {
  UserActionNotifier() : super([]);

  void addNotification(UserActionNotificationData noti) {
    state = state..add(noti);
  }
}
