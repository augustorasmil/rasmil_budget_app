import 'package:rasmil_budget_app/screens/item_page.dart';
import 'package:rasmil_budget_app/model/model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CategoryList extends StatelessWidget {
  final List<Category> _categoryList;
  final Function _editCategory;
  final Function _deleteCategory;

  CategoryList(this._categoryList, this._editCategory, this._deleteCategory);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.6,
      child: _categoryList.isEmpty
          ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    'No Category added yet!',
                    style: TextStyle(
                      fontSize: 21.0,
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: _categoryList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ItemScreen(
                              _categoryList[index].categoryID,
                              _categoryList[index].categoryName,
                              _categoryList[index].categoryLimit,
                              _categoryList[index].categoryTotal))),
                      child: Card(
                        margin: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            color: Colors.white,
                            child: ListTile(
                              title: Row(children: <Widget>[
                                Text(
                                  _categoryList[index].categoryName,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.black,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ]),
                              subtitle: LinearPercentIndicator(
                                lineHeight: 14.0,
                                percent: _categoryList[index].categoryTotal /
                                    _categoryList[index].categoryLimit,
                                center: Text(
                                  '₱' +
                                      _categoryList[index]
                                          .categoryTotal
                                          .toString() +
                                      "/" +
                                      _categoryList[index]
                                          .categoryLimit
                                          .toString(),
                                  style: new TextStyle(fontSize: 14.0),
                                ),
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: Colors.blue,
                              ),
                            ),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Edit',
                              color: Colors.blue,
                              icon: Icons.edit,
                              onTap: () {
                                _editCategory(
                                    context, _categoryList[index].categoryID);
                              },
                            ),
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                _deleteCategory(
                                    context, _categoryList[index].categoryID);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
    );
  }
}
