class Author {
  final int? id;
  final String name;
  final int birthYear;

  Author({
    this.id,
    required this.name,
    required this.birthYear,
  });

  @override
  String toString() => 'Author(id: $id, name: $name, birthYear: $birthYear)';
}
