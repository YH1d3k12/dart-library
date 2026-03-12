import '../model/category.dart';

class CategoryService {
  final List<Category> _categories = [
    Category(id: 1, name: 'Romance'),
    Category(id: 2, name: 'Ficção Científica'),
    Category(id: 3, name: 'Terror'),
    Category(id: 4, name: 'Biografia'),
    Category(id: 5, name: 'Filosofia'),
  ];

  int _nextId = 6;

  List<Category> getAll() => List.unmodifiable(_categories);

  Category? getById(int id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Category add(String name) {
    final category = Category(id: _nextId++, name: name);
    _categories.add(category);
    return category;
  }

  bool delete(int id) {
    final index = _categories.indexWhere((c) => c.id == id);
    if (index == -1) return false;
    _categories.removeAt(index);
    return true;
  }

  void printAll() {
    if (_categories.isEmpty) {
      print('  Nenhuma categoria cadastrada.');
      return;
    }
    for (final c in _categories) {
      print('  [${c.id}] ${c.name}');
    }
  }
}
