import 'package:rasmil_budget_app/screens/home_page.dart';
import 'package:rasmil_budget_app/list/item.dart';
import 'package:rasmil_budget_app/model/model.dart';
import 'package:rasmil_budget_app/service/category_service.dart';
import 'package:rasmil_budget_app/service/item_service.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemScreen extends StatefulWidget {
  final int itemID;
  String itemName;
  int categoryLimit;
  int categoryTotal;

  ItemScreen(
      this.itemID, this.itemName, this.categoryLimit, this.categoryTotal);

  @override
  ItemScreenState createState() => ItemScreenState();
}

class ItemScreenState extends State<ItemScreen> {
  var item;
  var category;
  var totalSum = 0;
  List<Item> _itemList = List<Item>();
  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  getAllItems() async {
    _itemList = List<Item>();
    var items = await _itemService.readItem(widget.itemID);
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
    totalSum = 0;
    for (var i = 0; i < _itemList.length; i++) {
      setState(() {
        totalSum += _itemList[i].itemAmount;
      });
    }

    updateBudget();
  }

  var _category = Category();
  updateBudget() async {
    _category.categoryID = widget.itemID;
    _category.categoryName = widget.itemName;
    _category.categoryLimit = widget.categoryLimit;
    _category.categoryTotal = widget.categoryLimit - totalSum;
    var result = await _categoryService.updateCategory(_category);
    print(_category.categoryLimit);
    print(_category.categoryTotal);
  }

  var _itemService = ItemService();
  var _item = Item();
  var itemNameController = TextEditingController();
  var itemAmountController = TextEditingController();
  var editItemNameController = TextEditingController();
  var editItemAmountController = TextEditingController();
  DateTime chosenDate;
  var _categoryService = CategoryService();

  _deleteItem(BuildContext context, itemId) async {
    _deleteFormDialog(context, itemId);
  }

  _editItem(BuildContext context, itemId) async {
    item = await _itemService.readItemById(itemId);
    setState(() {
      editItemNameController.text = item[0]['item_name'] ?? 'No Name';
      editItemAmountController.text =
          item[0]['item_amount'].toString() ?? 'No Budget';
      chosenDate =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(item[0]['item_date']);
    });
    _editFormDialog(context);
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Item'),
              content: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  TextField(
                    style: TextStyle(),
                    decoration: InputDecoration(
                      labelText: 'New Item Name',
                    ),
                    controller: editItemNameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'New Budget',
                    ),
                    controller: editItemAmountController,
                    keyboardType: TextInputType.number,
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            chosenDate == null
                                ? 'No Date Chosen'
                                : DateFormat.yMd().format(chosenDate),
                          ),
                        ),
                        FlatButton(
                          child: Text(
                            'Choose Date',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            var pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1999),
                                lastDate: DateTime.now());
                            if (pickedDate != null) {
                              chosenDate = pickedDate;
                              setState(() {
                                chosenDate = pickedDate;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                      color: Colors.black,
                      child: Text('Update'),
                      textColor: Colors.white,
                      onPressed: () async {
                        if (editItemNameController.text.isEmpty ||
                            editItemAmountController.text.isEmpty ||
                            chosenDate == null) {
                          return;
                        } else if (widget.categoryTotal <= 0 ||
                            int.parse(editItemAmountController.text) >
                                widget.categoryTotal) {
                          return;
                        } else {
                          _item.itemID = item[0]['itemID'];
                          _item.itemName = editItemNameController.text;
                          _item.itemAmount =
                              int.parse(editItemAmountController.text);
                          _item.itemDate = chosenDate.toString();
                          _item.categoryID = item[0]['categoryID'];
                          print(_item.itemID);
                          print(_item.itemName);
                          print(_item.itemAmount);
                          var result = await _itemService.updateItem(_item);
                          Navigator.of(context).pop();
                          getAllItems();
                        }
                      })
                ],
              )),
            );
          });
        });
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Item'),
              content: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  TextField(
                    style: TextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    controller: itemNameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                    controller: itemAmountController,
                    keyboardType: TextInputType.number,
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            chosenDate == null
                                ? 'No Date Chosen'
                                : DateFormat.yMd().format(chosenDate),
                          ),
                        ),
                        FlatButton(
                          child: Text(
                            'Choose Date',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            var pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1999),
                                lastDate: DateTime.now());
                            if (pickedDate != null) {
                              chosenDate = pickedDate;
                              setState(() {
                                chosenDate = pickedDate;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                      color: Colors.black,
                      child: Text('Add Item'),
                      textColor: Colors.white,
                      onPressed: () async {
                        if (itemNameController.text.isEmpty ||
                            itemAmountController.text.isEmpty ||
                            chosenDate == null) {
                          return;
                        } else if (widget.categoryTotal <= 0 ||
                            int.parse(itemAmountController.text) >
                                widget.categoryTotal) {
                          return;
                        } else {
                          _item.itemName = itemNameController.text;
                          _item.itemAmount =
                              int.parse(itemAmountController.text);
                          _item.itemDate = chosenDate.toString();
                          _item.categoryID = widget.itemID;
                          var result = await _itemService.saveItem(_item);
                          Navigator.of(context).pop();
                          getAllItems();
                          itemNameController.text = '';
                          itemAmountController.text = '';
                          chosenDate = null;
                        }
                      })
                ],
              )),
            );
          });
        });
  }

  _deleteFormDialog(BuildContext context, itemId) {
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
                    var result = await _itemService.deleteItem(itemId);
                    Navigator.pop(context);
                    getAllItems();
                  }),
              RaisedButton(
                  color: Colors.blue,
                  child: Text('Cancel'),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            title: Text('Delete Item?'),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _showFormDialog(context),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Home())),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: () {
                  _showFormDialog(context);
                })
          ],
          title: Text(
            widget.itemName,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SizedBox.expand(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    width: 250,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircularPercentIndicator(
                      lineWidth: 15.0,
                      radius: 200.0,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 1000,
                      percent: (widget.categoryLimit - totalSum) /
                          widget.categoryLimit,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '₱' +
                                    (widget.categoryLimit - totalSum)
                                        .toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              Text("/",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  )),
                              Text(widget.categoryLimit.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ))
                            ],
                          ),
                        ],
                      ),
                      progressColor: Colors.blue,
                      circularStrokeCap: CircularStrokeCap.round,
                    )),
              ),
              ItemList(_itemList, _deleteItem, _editItem),
            ],
          ),
        ));
  }
}
