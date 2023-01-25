class Income {
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

  Income(
      {this.id,
      this.description,
      this.date,
      this.total,
      this.type,
      this.memberId,
      this.categoryId,
      this.budgetId,
      this.createdAt,
      this.updatedAt});

  Income.fromJson(Map<dynamic, dynamic> json) {
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
    return data;
  }
}
