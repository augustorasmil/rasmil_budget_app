import 'package:rasmil_budget_app/model/model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemList extends StatelessWidget {
  final List<Item> _itemList;
  final Function _deleteItem;
  final Function _editItem;

  ItemList(this._itemList, this._deleteItem, this._editItem);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: _itemList.isEmpty
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'No item added yet!',
                    style: TextStyle(
                      fontSize: 21.0,
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: _itemList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        padding: EdgeInsets.all(7.0),
                        color: Colors.white,
                        child: ListTile(
                          title: Row(children: <Widget>[
                            Text(
                              _itemList[index].itemName,
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.black,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]),
                          subtitle: Text(
                            DateFormat.yMd().format(
                                DateFormat("yyyy-MM-dd hh:mm:ss")
                                    .parse(_itemList[index].itemDate)),
                          ),
                          trailing: Text(
                            "\₱" + _itemList[index].itemAmount.toString(),
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: Colors.blue,
                          icon: Icons.edit,
                          onTap: () {
                            _editItem(context, _itemList[index].itemID);
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            _deleteItem(context, _itemList[index].itemID);
                          },
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
