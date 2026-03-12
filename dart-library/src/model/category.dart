class Category {
  final int? id;
  final String name;

  Category({
    this.id,
    required this.name,
  });

  @override
  String toString() => 'Category(id: $id, name: $name)';
}
