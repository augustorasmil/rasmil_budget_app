import 'package:rasmil_budget_app/repositories/repository.dart';
import 'package:rasmil_budget_app/model/model.dart';

class ItemService {
  Repository _repository;

  ItemService() {
    _repository = Repository();
  }

  saveItem(Item item) async {
    return await _repository.insertItem('item', item.itemMap());
  }

  readItem(categoryId) async {
    return await _repository.readItem('item', categoryId);
  }

  readAllItem() async {
    return await _repository.readAllItem('item');
  }

  readItemById(itemId) async {
    return await _repository.readItemById('item', itemId);
  }

  updateItem(Item item) async {
    return await _repository.updateItem('item', item.itemMap());
  }

  deleteItem(itemId) async {
    return await _repository.deleteItem('item', itemId);
  }
}
