import 'package:rasmil_budget_app/model/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Item> _itemList;
  var date = DateTime.now();

  Chart(this._itemList);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = date.subtract(Duration(days: index));

      var totalSum = 0.0;

      for (var i = 0; i < _itemList.length; i++) {
        if (weekDay.day ==
                DateFormat("yyyy-MM-dd hh:mm:ss")
                    .parse(_itemList[i].itemDate)
                    .day &&
            weekDay.month ==
                DateFormat("yyyy-MM-dd hh:mm:ss")
                    .parse(_itemList[i].itemDate)
                    .month &&
            weekDay.year ==
                DateFormat("yyyy-MM-dd hh:mm:ss")
                    .parse(_itemList[i].itemDate)
                    .year) {
          totalSum += _itemList[i].itemAmount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'itemAmount': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['itemAmount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Weekly Spendings',
              style: TextStyle(
                fontSize: 21.0,
                color: Colors.black,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      date = date.subtract(new Duration(days: 7));
                    });
                  },
                ),
                Text(
                  " ${DateFormat.yMMMd('en_US').format(date.subtract(Duration(days: 7))).toString()} " +
                      " - "
                          " ${DateFormat.yMMMd('en_US').format(date).toString()}",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      date = date.add(new Duration(days: 7));
                    });
                  },
                ),
              ],
            ),
            Card(
              elevation: 6,
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: groupedTransactionValues.map((expense) {
                    return Container(
                        padding: EdgeInsets.all(2),
                        child: ChartBar(
                            day: expense['day'],
                            categoryLimit: expense['itemAmount'],
                            percentage: maxSpending != 0
                                ? (expense['itemAmount'] as double) /
                                    maxSpending
                                : 0.0));
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ChartBar extends StatelessWidget {
  final String day;
  final double categoryLimit;
  final double percentage;

  ChartBar({this.categoryLimit, this.day, this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FittedBox(
          child: Text(
        '₱' + categoryLimit.toStringAsFixed(0),
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontFamily: 'Gotham',
        ),
      )),
      SizedBox(
        height: 10,
      ),
      RotatedBox(
        quarterTurns: 2,
        child: Container(
          width: 10,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  heightFactor: percentage,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        this.day,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontFamily: 'Gotham',
          fontWeight: FontWeight.bold,
        ),
      )
    ]);
  }
}
