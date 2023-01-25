class Goals {
  int? id;
  String? description;
  int? targetTotal;
  int? currentTotal;
  String? status;
  bool? dayOverdue;
  String? daysDescription;

  Goals(
      {this.id,
      this.description,
      this.targetTotal,
      this.currentTotal,
      this.status,
      this.dayOverdue,
      this.daysDescription});

  Goals.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    description = json['description'];
    targetTotal = json['target_total'];
    currentTotal = json['current_total'];
    status = json['status'];
    dayOverdue = json['dayOverdue'];
    daysDescription = json['daysDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['target_total'] = this.targetTotal;
    data['current_total'] = this.currentTotal;
    data['status'] = this.status;
    data['dayOverdue'] = this.dayOverdue;
    data['daysDescription'] = this.daysDescription;
    return data;
  }
}
