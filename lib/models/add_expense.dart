class AddExpense {
  Member? member;
  String? messageExpense;

  AddExpense({this.member, this.messageExpense});

  AddExpense.fromJson(Map<String, dynamic> json) {
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    messageExpense = json['message_expense'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (member != null) {
      data['member'] = member!.toJson();
    }
    data['message_expense'] = messageExpense;
    return data;
  }
}

class Member {
  int? id;
  String? name;
  String? mobile;
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
