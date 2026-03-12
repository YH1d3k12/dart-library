import '../model/loan.dart';
import 'book.dart';
import 'user.dart';

class LoanService {
  final BookService _bookService;
  final UserService _userService;

  LoanService(this._bookService, this._userService);

  final List<Loan> _loans = [];
  int _nextId = 1;

  // Seed: alguns empréstimos já existentes
  void seedLoans() {
    _createLoan(bookId: 1, userId: 1, daysAgo: 5);
    _createLoan(bookId: 3, userId: 2, daysAgo: 20); // atrasado
    _createLoan(bookId: 5, userId: 3, daysAgo: 2);
  }

  void _createLoan({
    required int bookId,
    required int userId,
    int daysAgo = 0,
  }) {
    final loanDate = DateTime.now().subtract(Duration(days: daysAgo));
    final loan = Loan(
      id: _nextId++,
      bookId: bookId,
      userId: userId,
      loanDate: loanDate,
      dueDate: loanDate.add(const Duration(days: 14)),
    );
    _loans.add(loan);
    _bookService.decreaseCopy(bookId);
  }

  List<Loan> getAll() => List.unmodifiable(_loans);

  List<Loan> getActive() => _loans.where((l) => !l.isReturned).toList();

  List<Loan> getOverdue() => _loans.where((l) => l.isOverdue).toList();

  List<Loan> getByUser(int userId) =>
      _loans.where((l) => l.userId == userId).toList();

  Loan? getById(int id) {
    try {
      return _loans.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  String? borrow(int bookId, int userId) {
    final book = _bookService.getById(bookId);
    if (book == null) return 'Livro não encontrado.';
    if (!book.isAvailable()) return 'Livro sem cópias disponíveis.';

    final user = _userService.getById(userId);
    if (user == null) return 'Usuário não encontrado.';

    // Verifica se o usuário já tem esse livro emprestado
    final alreadyBorrowed = _loans.any(
      (l) => l.bookId == bookId && l.userId == userId && !l.isReturned,
    );
    if (alreadyBorrowed) return 'Usuário já possui este livro emprestado.';

    _bookService.decreaseCopy(bookId);
    _loans.add(Loan(id: _nextId++, bookId: bookId, userId: userId));
    return null; // null = sucesso
  }

  String? returnBook(int loanId) {
    final index = _loans.indexWhere((l) => l.id == loanId);
    if (index == -1) return 'Empréstimo não encontrado.';

    final loan = _loans[index];
    if (loan.isReturned) return 'Este empréstimo já foi devolvido.';

    _loans[index] = Loan(
      id: loan.id,
      bookId: loan.bookId,
      userId: loan.userId,
      loanDate: loan.loanDate,
      dueDate: loan.dueDate,
      returnedDate: DateTime.now(),
    );
    _bookService.increaseCopy(loan.bookId);
    return null; // null = sucesso
  }

  void printAll() {
    if (_loans.isEmpty) {
      print('  Nenhum empréstimo registrado.');
      return;
    }
    for (final l in _loans) {
      _printLoan(l);
    }
  }

  void printActive() {
    final active = getActive();
    if (active.isEmpty) {
      print('  Nenhum empréstimo ativo.');
      return;
    }
    for (final l in active) {
      _printLoan(l);
    }
  }

  void printOverdue() {
    final overdue = getOverdue();
    if (overdue.isEmpty) {
      print('  Nenhum empréstimo em atraso. 🎉');
      return;
    }
    for (final l in overdue) {
      _printLoan(l);
    }
  }

  void _printLoan(Loan l) {
    final book = _bookService.getById(l.bookId);
    final user = _userService.getById(l.userId);
    final status = l.isReturned
        ? '✓ Devolvido em ${_fmt(l.returnedDate!)}'
        : l.isOverdue
        ? '⚠ ATRASADO (venceu ${_fmt(l.dueDate)})'
        : '● Ativo até ${_fmt(l.dueDate)}';
    print(
      '  [${l.id}] "${book?.title ?? '?'}" → ${user?.name ?? '?'} | $status',
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
