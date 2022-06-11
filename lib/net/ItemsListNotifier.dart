import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/net/Item.dart';

class ItemsListNotifier extends StateNotifier<List<Item>> {
  ItemsListNotifier() : super([]);

  void addItem(Item item) {
    state = [...state, item];
  }

  void removeItem(Item item) {
    state = [
      for (final todo in state)
        if (todo.uuid != item.uuid) todo,
    ];
  }

  void refresh(List<Item> items) {
    state = items;
  }
}
