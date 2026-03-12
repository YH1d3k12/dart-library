import '../model/user.dart';

class UserService {
  final List<User> _users = [
    User(
      id: 1,
      name: 'Ana Paula',
      email: 'ana@email.com',
      createdAt: DateTime(2023, 1, 10),
    ),
    User(
      id: 2,
      name: 'Carlos Silva',
      email: 'carlos@email.com',
      createdAt: DateTime(2023, 3, 22),
    ),
    User(
      id: 3,
      name: 'Mariana Costa',
      email: 'mari@email.com',
      createdAt: DateTime(2024, 7, 5),
    ),
    User(
      id: 4,
      name: 'Pedro Nunes',
      email: 'pedro@email.com',
      createdAt: DateTime(2024, 11, 18),
    ),
  ];

  int _nextId = 5;

  List<User> getAll() => List.unmodifiable(_users);

  User? getById(int id) {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  User add(String name, String email) {
    final user = User(id: _nextId++, name: name, email: email);
    _users.add(user);
    return user;
  }

  bool delete(int id) {
    final index = _users.indexWhere((u) => u.id == id);
    if (index == -1) return false;
    _users.removeAt(index);
    return true;
  }

  void printAll() {
    if (_users.isEmpty) {
      print('  Nenhum usuário cadastrado.');
      return;
    }
    for (final u in _users) {
      print('  [${u.id}] ${u.name} | ${u.email}');
    }
  }
}
