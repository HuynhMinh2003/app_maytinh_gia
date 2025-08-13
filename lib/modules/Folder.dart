class Folder {
  final String id;
  final String name;
  final String path; // thêm đường dẫn để đọc thời gian

  Folder({required this.id, required this.name, required this.path});

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      path: map['path'],
    );
  }
}
