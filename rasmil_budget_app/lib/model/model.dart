class Category {
  int categoryID;
  String categoryName;
  int categoryLimit;
  int categoryTotal;

  Category({
    this.categoryID,
    this.categoryName,
    this.categoryLimit,
    this.categoryTotal,
  });

  categoryMap() {
    var mapping = Map<String, dynamic>();
    mapping['categoryID'] = categoryID;
    mapping['categoryName'] = categoryName;
    mapping['categoryLimit'] = categoryLimit;
    mapping['categoryTotal'] = categoryTotal;

    return mapping;
  }
}

class Item {
  int itemID;
  String itemName;
  int itemAmount;
  String itemDate;
  int categoryID;

  Item({
    this.itemID,
    this.itemName,
    this.itemAmount,
    this.itemDate,
    this.categoryID,
  });

  itemMap() {
    var mapping = Map<String, dynamic>();
    mapping['itemID'] = itemID;
    mapping['itemName'] = itemName;
    mapping['itemAmount'] = itemAmount;
    mapping['itemDate'] = itemDate;
    mapping['categoryID'] = categoryID;

    return mapping;
  }
}
