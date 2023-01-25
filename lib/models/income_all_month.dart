class IncomeAllMonth {
  int? categoryId;
  int? id;
  String? formattedDate;
  dynamic? total;
  String? description;
  Categories? category;

  IncomeAllMonth(
      {this.categoryId,
      this.id,
      this.formattedDate,
      this.total,
      this.description,
      this.category});

  IncomeAllMonth.fromJson(Map<dynamic, dynamic> json) {
    categoryId = json['category_id'];
    id = json['id'];
    formattedDate = json['formatted_date'];
    total = json['total'];
    description = json['description'];
    category = json['category'] != null
        ? new Categories.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['id'] = this.id;
    data['formatted_date'] = this.formattedDate;
    data['total'] = this.total;
    data['description'] = this.description;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? description;

  Categories({this.id, this.description});

  Categories.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    return data;
  }
}
