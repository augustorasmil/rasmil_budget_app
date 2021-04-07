import 'package:rasmil_budget_app/service/category_service.dart';
import 'package:rasmil_budget_app/model/model.dart';
import 'package:rasmil_budget_app/service/item_service.dart';
import 'package:rasmil_budget_app/chart/chart.dart';
import 'package:rasmil_budget_app/list/category.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var category;
  var totalSum = 0;

  List<Category> _categoryList = List<Category>();
  List<Item> _itemList = List<Item>();
  List<Item> _itemList2 = List<Item>();

  @override
  void initState() {
    super.initState();
    getAllCategories();
    getAllItems();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.categoryName = category['categoryName'];
        categoryModel.categoryID = category['categoryID'];
        categoryModel.categoryLimit = category['categoryLimit'];
        categoryModel.categoryTotal = category['categoryTotal'];
        _categoryList.add(categoryModel);
      });
    });
  }

  var _itemService = ItemService();
  getAllItems() async {
    _itemList = List<Item>();
    var items = await _itemService.readAllItem();
    items.forEach((item) {
      setState(() {
        var itemModel = Item();
        itemModel.itemName = item['itemName'];
        itemModel.itemID = item['itemID'];
        itemModel.itemAmount = item['itemAmount'];
        itemModel.itemDate = item['itemDate'];
        itemModel.categoryID = item['categoryID'];
        _itemList.add(itemModel);
      });
    });
  }

  var _categoryService = CategoryService();
  var _category = Category();
  var categoryNameController = TextEditingController();
  var categoryBudgetController = TextEditingController();
  var editCategoryNameController = TextEditingController();
  var editCategoryBudgetController = TextEditingController();

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      editCategoryNameController.text =
          category[0]['categoryName'] ?? 'No Name';
      editCategoryBudgetController.text =
          category[0]['categoryLimit'].toString() ?? 'No Budget';
    });
    _editFormDialog(context);
  }

  _deleteCategory(BuildContext context, categoryId) async {
    _deleteFormDialog(context, categoryId);
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Add Category'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  style: TextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  controller: categoryNameController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Budget',
                  ),
                  controller: categoryBudgetController,
                  keyboardType: TextInputType.number,
                ),
                RaisedButton(
                    color: Colors.black,
                    child: Text('Add Category'),
                    textColor: Colors.white,
                    onPressed: () async {
                      if (categoryNameController.text.isEmpty ||
                          categoryBudgetController.text.isEmpty) {
                        return;
                      } else {
                        _category.categoryName = categoryNameController.text;
                        _category.categoryLimit =
                            int.parse(categoryBudgetController.text);
                        _category.categoryTotal =
                            int.parse(categoryBudgetController.text);
                        var result =
                            await _categoryService.saveCategory(_category);
                        print(result);
                        Navigator.of(context).pop();
                        getAllCategories();
                        categoryNameController.text = '';
                        categoryBudgetController.text = '';
                      }
                    })
              ],
            )),
          );
        });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Edit Category'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  style: TextStyle(),
                  decoration: InputDecoration(
                    labelText: 'New Category Name',
                  ),
                  controller: editCategoryNameController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'New Budget',
                  ),
                  controller: editCategoryBudgetController,
                  keyboardType: TextInputType.number,
                ),
                RaisedButton(
                    color: Colors.black,
                    child: Text('Update'),
                    textColor: Colors.white,
                    onPressed: () async {
                      if (editCategoryNameController.text.isEmpty ||
                          editCategoryBudgetController.text.isEmpty) {
                        return;
                      } else {
                        _category.categoryID = category[0]['categoryID'];
                        _category.categoryName =
                            editCategoryNameController.text;
                        _category.categoryLimit =
                            int.parse(editCategoryBudgetController.text);
                        var result =
                            await _categoryService.updateCategory(_category);
                        print(result);
                        Navigator.of(context).pop();
                        getAllCategories();
                        _showSuccessSnackBar(Text("Update Successful"));
                      }
                    })
              ],
            )),
          );
        });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              RaisedButton(
                  color: Colors.red,
                  child: Text('Delete'),
                  textColor: Colors.white,
                  onPressed: () async {
                    var result =
                        await _categoryService.deleteCategory(categoryId);
                    Navigator.pop(context);
                    getAllCategories();
                  }),
              RaisedButton(
                  color: Colors.blue,
                  child: Text('Cancel'),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            title: Text('Delete Category'),
          );
        });
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _globalKey,
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text(
            'BUDGET APP',
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 35.0,
                ),
                onPressed: () {
                  _showFormDialog(context);
                })
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Card(
                margin: EdgeInsets.all(4),
                elevation: 5,
                child: Chart(_itemList),
              ),
            ),
            SingleChildScrollView(
              child: CategoryList(
                _categoryList,
                _editCategory,
                _deleteCategory,
              ),
            ),
          ],
        ));
  }
}
