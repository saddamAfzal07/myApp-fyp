class Member {
  int? id;
  String? name;
  String? mobile;
  String? email;
  int? currencyId;

  Member({this.id, this.name, this.mobile, this.email, this.currencyId});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    currencyId = json['currency_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['currency_id'] = this.currencyId;
    return data;
  }
}

class Currencies {
  int? id;
  String? code;

  Currencies({this.id, this.code});

  Currencies.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    return data;
  }
}
