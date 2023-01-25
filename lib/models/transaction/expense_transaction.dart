class Transactions {
  int? id;
  String? description;
  String? date;
  int? total;
  String? type;
  int? memberId;
  int? categoryId;
  Null? budgetId;
  String? createdAt;
  String? updatedAt;
  Category? category;

  Transactions(
      {this.id,
      this.description,
      this.date,
      this.total,
      this.type,
      this.memberId,
      this.categoryId,
      this.budgetId,
      this.createdAt,
      this.updatedAt,
      this.category});

  Transactions.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    description = json['description'];
    date = json['date'];
    total = json['total'];
    type = json['type'];
    memberId = json['member_id'];
    categoryId = json['category_id'];
    budgetId = json['budget_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['date'] = this.date;
    data['total'] = this.total;
    data['type'] = this.type;
    data['member_id'] = this.memberId;
    data['category_id'] = this.categoryId;
    data['budget_id'] = this.budgetId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? description;
  int? percentage;
  String? type;
  String? smartCategory;
  int? basic;
  String? icon;
  Null? createdAt;
  Null? updatedAt;

  Category(
      {this.id,
      this.description,
      this.percentage,
      this.type,
      this.smartCategory,
      this.basic,
      this.icon,
      this.createdAt,
      this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    percentage = json['percentage'];
    type = json['type'];
    smartCategory = json['smart_category'];
    basic = json['basic'];
    icon = json['icon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['percentage'] = this.percentage;
    data['type'] = this.type;
    data['smart_category'] = this.smartCategory;
    data['basic'] = this.basic;
    data['icon'] = this.icon;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


// class Transactions {
//   int? id;
//   String? description;
//   String? date;
//   double? total;
//   String? type;
//   int? memberId;
//   int? categoryId;
//   int? budgetId;
//   String? createdAt;
//   String? updatedAt;
//   Category? category;

//   Transactions(
//       {this.id,
//       this.description,
//       this.date,
//       this.total,
//       this.type,
//       this.memberId,
//       this.categoryId,
//       this.budgetId,
//       this.createdAt,
//       this.updatedAt,
//       this.category});

//   Transactions.fromJson(Map<dynamic, dynamic> json) {
//     id = json['id'];
//     description = json['description'];
//     date = json['date'];
//     total = json['total'].to;
//     type = json['type'];
//     memberId = json['member_id'];
//     categoryId = json['category_id'];
//     budgetId = json['budget_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     category = json['category'] != null
//         ? new Category.fromJson(json['category'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['description'] = this.description;
//     data['date'] = this.date;
//     data['total'] = this.total;
//     data['type'] = this.type;
//     data['member_id'] = this.memberId;
//     data['category_id'] = this.categoryId;
//     data['budget_id'] = this.budgetId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.category != null) {
//       data['category'] = this.category!.toJson();
//     }
//     return data;
//   }
// }

// class Category {
//   int? id;
//   String? description;
//   int? percentage;
//   String? type;
//   String? smartCategory;
//   int? basic;
//   String? icon;
//   Null? createdAt;
//   Null? updatedAt;

//   Category(
//       {this.id,
//       this.description,
//       this.percentage,
//       this.type,
//       this.smartCategory,
//       this.basic,
//       this.icon,
//       this.createdAt,
//       this.updatedAt});

//   Category.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     description = json['description'];
//     percentage = json['percentage'];
//     type = json['type'];
//     smartCategory = json['smart_category'];
//     basic = json['basic'];
//     icon = json['icon'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['description'] = this.description;
//     data['percentage'] = this.percentage;
//     data['type'] = this.type;
//     data['smart_category'] = this.smartCategory;
//     data['basic'] = this.basic;
//     data['icon'] = this.icon;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
