import 'package:rasmil_budget_app/repositories/repository.dart';
import 'package:rasmil_budget_app/model/model.dart';

class CategoryService {
  Repository _repository;

  CategoryService() {
    _repository = Repository();
  }

  saveCategory(Category category) async {
    return await _repository.insertData('category', category.categoryMap());
  }

  readCategory() async {
    return await _repository.readData('category');
  }

  readCategoryById(categoryId) async {
    return await _repository.readDataById('category', categoryId);
  }

  updateCategory(Category category) async {
    return await _repository.updateData('category', category.categoryMap());
  }

  deleteCategory(categoryId) async {
    return await _repository.deleteData('category', categoryId);
  }
}
