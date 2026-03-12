import '../model/author.dart';

class AuthorService {
  final List<Author> _authors = [
    Author(id: 1, name: 'Machado de Assis', birthYear: 1839),
    Author(id: 2, name: 'Clarice Lispector', birthYear: 1920),
    Author(id: 3, name: 'Jorge Amado', birthYear: 1912),
    Author(id: 4, name: 'José Saramago', birthYear: 1922),
    Author(id: 5, name: 'George Orwell', birthYear: 1903),
  ];

  int _nextId = 6;

  List<Author> getAll() => List.unmodifiable(_authors);

  Author? getById(int id) {
    try {
      return _authors.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Author add(String name, int birthYear) {
    final author = Author(id: _nextId++, name: name, birthYear: birthYear);
    _authors.add(author);
    return author;
  }

  bool delete(int id) {
    final index = _authors.indexWhere((a) => a.id == id);
    if (index == -1) return false;
    _authors.removeAt(index);
    return true;
  }

  void printAll() {
    if (_authors.isEmpty) {
      print('Nenhum autor cadastrado.');
      return;
    }
    for (final a in _authors) {
      a.toString();
    }
  }
}
