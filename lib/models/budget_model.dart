class Budgets {
  int? id;
  String? date;
  int? totalIncome;
  int? totalExpenses;

  Budgets({this.id, this.date, this.totalIncome, this.totalExpenses});

  Budgets.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    date = json['date'];
    totalIncome = json['totalIncome'];
    totalExpenses = json['totalExpenses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['totalIncome'] = this.totalIncome;
    data['totalExpenses'] = this.totalExpenses;
    return data;
  }
}
