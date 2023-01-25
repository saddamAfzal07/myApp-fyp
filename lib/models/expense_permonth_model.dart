class Expensemodel {
  int? totalIncome;
  int? totalExpenses;
  int? totalBalance;
  List<Categories>? categories;
  List<Expenses>? expenses;

  Expensemodel(
      {this.totalIncome,
      this.totalExpenses,
      this.totalBalance,
      this.categories,
      this.expenses});

  Expensemodel.fromJson(Map<String, dynamic> json) {
    totalIncome = json['totalIncome'];
    totalExpenses = json['totalExpenses'];
    totalBalance = json['totalBalance'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['expenses'] != null) {
      expenses = <Expenses>[];
      json['expenses'].forEach((v) {
        expenses!.add(new Expenses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalIncome'] = this.totalIncome;
    data['totalExpenses'] = this.totalExpenses;
    data['totalBalance'] = this.totalBalance;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.expenses != null) {
      data['expenses'] = this.expenses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? categoryId;
  String? description;
  int? total;
  int? percentage;

  Categories({this.categoryId, this.description, this.total, this.percentage});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    description = json['description'];
    total = json['total'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    data['total'] = this.total;
    data['percentage'] = this.percentage;
    return data;
  }
}

class Expenses {
  int? id;
  String? description;
  String? date;
  int? total;
  String? type;
  int? memberId;
  int? categoryId;
  int? budgetId;
  String? createdAt;
  String? updatedAt;
  Category? category;

  Expenses(
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

  Expenses.fromJson(Map<dynamic, dynamic> json) {
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
  Null? createdAt;
  Null? updatedAt;

  Category(
      {this.id,
      this.description,
      this.percentage,
      this.type,
      this.smartCategory,
      this.basic,
      this.createdAt,
      this.updatedAt});

  Category.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    description = json['description'];
    percentage = json['percentage'];
    type = json['type'];
    smartCategory = json['smart_category'];
    basic = json['basic'];
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
