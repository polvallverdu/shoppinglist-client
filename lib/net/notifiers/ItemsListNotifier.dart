import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/net/Item.dart';

class ItemsListNotifier extends StateNotifier<List<Item>> {
  ItemsListNotifier() : super([]);

  void addItem(Item item, [int index = 0]) {
    state = List.from(state)..insert(index, item);
  }

  void removeItem(String uuid) {
    state = [
      for (var item in state)
        if (item.uuid != uuid) item
    ];
  }

  void refresh(List<Item> items) {
    state = items;
  }

  void changeIndex(String uuid, int newIndex) {
    List<Item> newState = [...state];
    Item item = newState.firstWhere((item) => item.uuid == uuid);
    int oldIndex = newState.indexOf(item);
    newState.removeAt(oldIndex);
    if (newIndex > oldIndex) {
      newIndex--;
    }
    newState.insert(newIndex, item);
    state = newState;
  }
}
