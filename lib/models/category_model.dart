class Categories {
  List<CategoryDetails>? categoryDetails;

  Categories({this.categoryDetails});

  Categories.fromJson(Map<String, dynamic> json) {
    if (json['categoryDetails'] != null) {
      categoryDetails = <CategoryDetails>[];
      json['categoryDetails'].forEach((v) {
        categoryDetails!.add(CategoryDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categoryDetails != null) {
      data['categoryDetails'] =
          categoryDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryDetails {
  int? id;
  String? description;

  CategoryDetails({this.id, this.description});

  CategoryDetails.fromJson(Map<dynamic, dynamic> json) {
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
