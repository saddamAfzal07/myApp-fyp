class SavingsCategories {
  int? percentage;
  num? assigned;
  String? description;

  SavingsCategories({this.percentage, this.assigned, this.description});

  SavingsCategories.fromJson(Map<dynamic, dynamic> json) {
    percentage = json['percentage'];
    assigned = json['assigned'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['percentage'] = this.percentage;
    data['assigned'] = this.assigned;
    data['description'] = this.description;
    return data;
  }
}
