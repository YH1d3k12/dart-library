import '../model/book.dart';
import 'author.dart';
import 'category.dart';

class BookService {
  final AuthorService _authorService;
  final CategoryService _categoryService;

  BookService(this._authorService, this._categoryService);

  final List<Book> _books = [
    Book(
      id: 1,
      title: 'Dom Casmurro',
      isbn: '978-85-359-0277-5',
      year: 1899,
      availableCopies: 3,
      authorId: 1,
      categoryId: 1,
    ),
    Book(
      id: 2,
      title: 'A Hora da Estrela',
      isbn: '978-85-359-0278-2',
      year: 1977,
      availableCopies: 2,
      authorId: 2,
      categoryId: 1,
    ),
    Book(
      id: 3,
      title: 'Gabriela Cravo e Canela',
      isbn: '978-85-359-0279-9',
      year: 1958,
      availableCopies: 1,
      authorId: 3,
      categoryId: 1,
    ),
    Book(
      id: 4,
      title: 'Ensaio sobre a Cegueira',
      isbn: '978-85-359-0280-5',
      year: 1995,
      availableCopies: 4,
      authorId: 4,
      categoryId: 5,
    ),
    Book(
      id: 5,
      title: '1984',
      isbn: '978-85-359-0281-2',
      year: 1949,
      availableCopies: 5,
      authorId: 5,
      categoryId: 2,
    ),
  ];

  int _nextId = 6;

  List<Book> getAll() => List.unmodifiable(_books);

  Book? getById(int id) {
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Book> getAvailable() => _books.where((b) => b.isAvailable()).toList();

  Book add({
    required String title,
    required String isbn,
    required int year,
    required int availableCopies,
    required int authorId,
    required int categoryId,
  }) {
    final book = Book(
      id: _nextId++,
      title: title,
      isbn: isbn,
      year: year,
      availableCopies: availableCopies,
      authorId: authorId,
      categoryId: categoryId,
    );
    _books.add(book);
    return book;
  }

  bool decreaseCopy(int bookId) {
    final index = _books.indexWhere((b) => b.id == bookId);
    if (index == -1) return false;
    final book = _books[index];
    if (book.availableCopies <= 0) return false;
    _books[index] = Book(
      id: book.id,
      title: book.title,
      isbn: book.isbn,
      year: book.year,
      availableCopies: book.availableCopies - 1,
      authorId: book.authorId,
      categoryId: book.categoryId,
    );
    return true;
  }

  bool increaseCopy(int bookId) {
    final index = _books.indexWhere((b) => b.id == bookId);
    if (index == -1) return false;
    final book = _books[index];
    _books[index] = Book(
      id: book.id,
      title: book.title,
      isbn: book.isbn,
      year: book.year,
      availableCopies: book.availableCopies + 1,
      authorId: book.authorId,
      categoryId: book.categoryId,
    );
    return true;
  }

  bool delete(int id) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index == -1) return false;
    _books.removeAt(index);
    return true;
  }

  void printAll() {
    if (_books.isEmpty) {
      print('  Nenhum livro cadastrado.');
      return;
    }
    for (final b in _books) {
      final author = _authorService.getById(b.authorId);
      final category = _categoryService.getById(b.categoryId);
      final status = b.isAvailable()
          ? '✓ ${b.availableCopies} cópia(s)'
          : '✗ Indisponível';
      print(
        '  [${b.id}] "${b.title}" | ${author?.name ?? '?'} | ${category?.name ?? '?'} | $status',
      );
    }
  }

  void printAvailable() {
    final available = getAvailable();
    if (available.isEmpty) {
      print('  Nenhum livro disponível no momento.');
      return;
    }
    for (final b in available) {
      final author = _authorService.getById(b.authorId);
      final category = _categoryService.getById(b.categoryId);
      print(
        '  [${b.id}] "${b.title}" | ${author?.name ?? '?'} | ${category?.name ?? '?'} | ${b.availableCopies} cópia(s)',
      );
    }
  }
}
