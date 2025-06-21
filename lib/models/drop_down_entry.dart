class DropDownEntry {
  dynamic value;
  String? label;

  DropDownEntry({required this.value, required this.label});

  DropDownEntry.fromJson(Map<String, dynamic> json) {
    value = json['id'].toString();
    label = json['name'];
  }
}