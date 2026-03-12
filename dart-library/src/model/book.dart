class Book {
  final int? id;
  final String title;
  final String isbn;
  final int year;
  final int availableCopies;
  final int authorId;
  final int categoryId;

  Book({
    this.id,
    required this.title,
    required this.isbn,
    required this.year,
    required this.availableCopies,
    required this.authorId,
    required this.categoryId,
  });

  bool isAvailable() => availableCopies > 0;

  @override
  String toString() =>
      'Book(id: $id, title: "$title", isbn: $isbn, year: $year, copies: $availableCopies)';
}
