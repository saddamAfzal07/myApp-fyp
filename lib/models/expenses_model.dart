class ExpensesModel {
  Member? member;
  List<ExpenseData> expense = [ExpenseData()];
  List<ExpensesAllMonth>? expensesAllMonth;

  ExpensesModel({this.member, required this.expense, this.expensesAllMonth});

  ExpensesModel.fromJson(Map<String, dynamic> json) {
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    if (json['expense'] != null) {
      expense = <ExpenseData>[];
      json['expense'].forEach((v) {
        expense.add(ExpenseData.fromJson(v));
      });
    }
    if (json['expensesAllMonth'] != null) {
      expensesAllMonth = <ExpensesAllMonth>[];
      json['expensesAllMonth'].forEach((v) {
        expensesAllMonth!.add(ExpensesAllMonth.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (member != null) {
      data['member'] = member!.toJson();
    }
    data['expense'] = expense.map((v) => v.toJson()).toList();
    if (expensesAllMonth != null) {
      data['expensesAllMonth'] =
          expensesAllMonth!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Member {
  int? id;
  String? name;
  int? mobile;
  String? email;
  String? password;
  int? budgetMode;
  String? createdAt;
  String? updatedAt;
  int? isEmailVerified;
  String? emailVerifiedAt;
  int? displayNotification;
  int? notificationId;
  int? currencyId;

  Member(
      {this.id,
      this.name,
      this.mobile,
      this.email,
      this.password,
      this.budgetMode,
      this.createdAt,
      this.updatedAt,
      this.isEmailVerified,
      this.emailVerifiedAt,
      this.displayNotification,
      this.notificationId,
      this.currencyId});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    budgetMode = json['budget_mode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isEmailVerified = json['is_email_verified'];
    emailVerifiedAt = json['email_verified_at'];
    displayNotification = json['display_notification'];
    notificationId = json['notification_id'];
    currencyId = json['currency_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['password'] = password;
    data['budget_mode'] = budgetMode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_email_verified'] = isEmailVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['display_notification'] = displayNotification;
    data['notification_id'] = notificationId;
    data['currency_id'] = currencyId;
    return data;
  }
}

class ExpenseData {
  String? date;
  int? total;

  ExpenseData({
    this.date,
    this.total,
  });

  ExpenseData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['total'] = total;
    return data;
  }
}

class ExpensesAllMonth {
  int? categoryId;
  int? id;
  String? formatted_date;
  int? total;
  String? description;
  Category? category;

  ExpensesAllMonth(
      {this.categoryId,
      this.id,
      this.formatted_date,
      this.total,
      this.description,
      this.category});

  ExpensesAllMonth.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    id = json['id'];
    formatted_date = json['formatted_date'];
    total = json['total'];
    description = json['description'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : category;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['id'] = id;
    data['formatted_date'] = formatted_date;
    data['total'] = total;
    data['description'] = description;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? description;

  Category({this.id, this.description});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    return data;
  }
}
