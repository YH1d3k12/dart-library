import 'dart:io';
import 'service/author.dart';
import 'service/book.dart';
import 'service/category.dart';
import 'service/loan.dart';
import 'service/user.dart';

// ─── Instâncias globais dos serviços ────────────────────────────────────────
final authorService = AuthorService();
final categoryService = CategoryService();
final bookService = BookService(authorService, categoryService);
final userService = UserService();
final loanService = LoanService(bookService, userService);

// ─── Utilitários de I/O ─────────────────────────────────────────────────────
String prompt(String msg) {
  stdout.write(msg);
  return stdin.readLineSync()?.trim() ?? '';
}

int? promptInt(String msg) => int.tryParse(prompt(msg));

void pause() {
  prompt('\nPressione Enter para continuar...');
}

void separator() => print('\n${'─' * 50}');

// ─── MAIN ────────────────────────────────────────────────────────────────────
void main() {
  loanService.seedLoans(); // popula empréstimos iniciais

  print('\n╔══════════════════════════════════╗');
  print('║   📚  SISTEMA DE BIBLIOTECA      ║');
  print('╚══════════════════════════════════╝');

  bool running = true;
  while (running) {
    running = showMainMenu();
  }

  print('\nAté logo! 👋\n');
}

// ─── MENU PRINCIPAL ──────────────────────────────────────────────────────────
bool showMainMenu() {
  separator();
  print('\n  MENU PRINCIPAL\n');
  print('  1. Livros');
  print('  2. Autores');
  print('  3. Categorias');
  print('  4. Usuários');
  print('  5. Empréstimos');
  print('  0. Sair\n');

  final option = prompt('  Escolha uma opção: ');
  switch (option) {
    case '1':
      menuBooks();
      break;
    case '2':
      menuAuthors();
      break;
    case '3':
      menuCategories();
      break;
    case '4':
      menuUsers();
      break;
    case '5':
      menuLoans();
      break;
    case '0':
      return false;
    default:
      print('\n  ⚠ Opção inválida.');
  }
  return true;
}

// ─── MENU LIVROS ─────────────────────────────────────────────────────────────
void menuBooks() {
  bool back = false;
  while (!back) {
    separator();
    print('\n  📖 LIVROS\n');
    print('  1. Listar todos');
    print('  2. Listar disponíveis');
    print('  3. Buscar por ID');
    print('  4. Cadastrar livro');
    print('  5. Remover livro');
    print('  0. Voltar\n');

    switch (prompt('  Opção: ')) {
      case '1':
        separator();
        print('\n  Todos os livros:\n');
        bookService.printAll();
        pause();
        break;
      case '2':
        separator();
        print('\n  Livros disponíveis:\n');
        bookService.printAvailable();
        pause();
        break;
      case '3':
        final id = promptInt('\n  ID do livro: ');
        if (id == null) {
          print('  ID inválido.');
          break;
        }
        final book = bookService.getById(id);
        if (book == null) {
          print('  Livro não encontrado.');
        } else {
          final author = authorService.getById(book.authorId);
          final category = categoryService.getById(book.categoryId);
          print('\n  Título   : ${book.title}');
          print('  ISBN     : ${book.isbn}');
          print('  Ano      : ${book.year}');
          print('  Autor    : ${author?.name ?? '?'}');
          print('  Categoria: ${category?.name ?? '?'}');
          print('  Cópias   : ${book.availableCopies}');
        }
        pause();
        break;
      case '4':
        separator();
        print('\n  Autores disponíveis:');
        authorService.printAll();
        print('\n  Categorias disponíveis:');
        categoryService.printAll();
        print('');
        final title = prompt('  Título            : ');
        final isbn = prompt('  ISBN              : ');
        final year = promptInt('  Ano               : ') ?? 0;
        final copies = promptInt('  Cópias disponíveis: ') ?? 1;
        final authorId = promptInt('  ID do autor       : ');
        final categoryId = promptInt('  ID da categoria   : ');
        if (authorId == null || categoryId == null) {
          print('  IDs inválidos.');
          break;
        }
        if (authorService.getById(authorId) == null) {
          print('  Autor não encontrado.');
          break;
        }
        if (categoryService.getById(categoryId) == null) {
          print('  Categoria não encontrada.');
          break;
        }
        final book = bookService.add(
          title: title,
          isbn: isbn,
          year: year,
          availableCopies: copies,
          authorId: authorId,
          categoryId: categoryId,
        );
        print('\n  ✓ Livro "${book.title}" cadastrado com ID ${book.id}.');
        pause();
        break;
      case '5':
        bookService.printAll();
        final id = promptInt('\n  ID do livro a remover: ');
        if (id == null) break;
        print(
          bookService.delete(id)
              ? '  ✓ Livro removido.'
              : '  Livro não encontrado.',
        );
        pause();
        break;
      case '0':
        back = true;
        break;
      default:
        print('  ⚠ Opção inválida.');
    }
  }
}

// ─── MENU AUTORES ────────────────────────────────────────────────────────────
void menuAuthors() {
  bool back = false;
  while (!back) {
    separator();
    print('\n  ✍️  AUTORES\n');
    print('  1. Listar todos');
    print('  2. Cadastrar autor');
    print('  3. Remover autor');
    print('  0. Voltar\n');

    switch (prompt('  Opção: ')) {
      case '1':
        separator();
        print('\n  Autores cadastrados:\n');
        authorService.printAll();
        pause();
        break;
      case '2':
        final name = prompt('\n  Nome          : ');
        final birthYear = promptInt('  Ano nascimento: ') ?? 0;
        final author = authorService.add(name, birthYear);
        print('\n  ✓ Autor "${author.name}" cadastrado com ID ${author.id}.');
        pause();
        break;
      case '3':
        authorService.printAll();
        final id = promptInt('\n  ID do autor a remover: ');
        if (id == null) break;
        print(
          authorService.delete(id)
              ? '  ✓ Autor removido.'
              : '  Autor não encontrado.',
        );
        pause();
        break;
      case '0':
        back = true;
        break;
      default:
        print('  ⚠ Opção inválida.');
    }
  }
}

// ─── MENU CATEGORIAS ─────────────────────────────────────────────────────────
void menuCategories() {
  bool back = false;
  while (!back) {
    separator();
    print('\n  🏷️  CATEGORIAS\n');
    print('  1. Listar todas');
    print('  2. Cadastrar categoria');
    print('  3. Remover categoria');
    print('  0. Voltar\n');

    switch (prompt('  Opção: ')) {
      case '1':
        separator();
        print('\n  Categorias cadastradas:\n');
        categoryService.printAll();
        pause();
        break;
      case '2':
        final name = prompt('\n  Nome da categoria: ');
        final category = categoryService.add(name);
        print(
          '\n  ✓ Categoria "${category.name}" cadastrada com ID ${category.id}.',
        );
        pause();
        break;
      case '3':
        categoryService.printAll();
        final id = promptInt('\n  ID da categoria a remover: ');
        if (id == null) break;
        print(
          categoryService.delete(id)
              ? '  ✓ Categoria removida.'
              : '  Categoria não encontrada.',
        );
        pause();
        break;
      case '0':
        back = true;
        break;
      default:
        print('  ⚠ Opção inválida.');
    }
  }
}

// ─── MENU USUÁRIOS ───────────────────────────────────────────────────────────
void menuUsers() {
  bool back = false;
  while (!back) {
    separator();
    print('\n  👤 USUÁRIOS\n');
    print('  1. Listar todos');
    print('  2. Cadastrar usuário');
    print('  3. Ver empréstimos do usuário');
    print('  4. Remover usuário');
    print('  0. Voltar\n');

    switch (prompt('  Opção: ')) {
      case '1':
        separator();
        print('\n  Usuários cadastrados:\n');
        userService.printAll();
        pause();
        break;
      case '2':
        final name = prompt('\n  Nome  : ');
        final email = prompt('  Email : ');
        final user = userService.add(name, email);
        print('\n  ✓ Usuário "${user.name}" cadastrado com ID ${user.id}.');
        pause();
        break;
      case '3':
        userService.printAll();
        final id = promptInt('\n  ID do usuário: ');
        if (id == null) break;
        final user = userService.getById(id);
        if (user == null) {
          print('  Usuário não encontrado.');
          pause();
          break;
        }
        final loans = loanService.getByUser(id);
        print('\n  Empréstimos de ${user.name}:\n');
        if (loans.isEmpty) {
          print('  Nenhum empréstimo encontrado.');
        } else {
          for (final l in loans) {
            final book = bookService.getById(l.bookId);
            final status = l.isReturned
                ? '✓ Devolvido'
                : l.isOverdue
                ? '⚠ ATRASADO'
                : '● Ativo';
            print('  [${l.id}] "${book?.title ?? '?'}" | $status');
          }
        }
        pause();
        break;
      case '4':
        userService.printAll();
        final id = promptInt('\n  ID do usuário a remover: ');
        if (id == null) break;
        print(
          userService.delete(id)
              ? '  ✓ Usuário removido.'
              : '  Usuário não encontrado.',
        );
        pause();
        break;
      case '0':
        back = true;
        break;
      default:
        print('  ⚠ Opção inválida.');
    }
  }
}

// ─── MENU EMPRÉSTIMOS ────────────────────────────────────────────────────────
void menuLoans() {
  bool back = false;
  while (!back) {
    separator();
    print('\n  🔖 EMPRÉSTIMOS\n');
    print('  1. Listar todos');
    print('  2. Listar ativos');
    print('  3. Listar em atraso');
    print('  4. Realizar empréstimo');
    print('  5. Registrar devolução');
    print('  0. Voltar\n');

    switch (prompt('  Opção: ')) {
      case '1':
        separator();
        print('\n  Todos os empréstimos:\n');
        loanService.printAll();
        pause();
        break;
      case '2':
        separator();
        print('\n  Empréstimos ativos:\n');
        loanService.printActive();
        pause();
        break;
      case '3':
        separator();
        print('\n  Empréstimos em atraso:\n');
        loanService.printOverdue();
        pause();
        break;
      case '4':
        separator();
        print('\n  Livros disponíveis:\n');
        bookService.printAvailable();
        print('\n  Usuários:\n');
        userService.printAll();
        final bookId = promptInt('\n  ID do livro   : ');
        final userId = promptInt('  ID do usuário : ');
        if (bookId == null || userId == null) {
          print('  IDs inválidos.');
          break;
        }
        final error = loanService.borrow(bookId, userId);
        if (error != null) {
          print('\n  ✗ $error');
        } else {
          print('\n  ✓ Empréstimo registrado com sucesso!');
        }
        pause();
        break;
      case '5':
        separator();
        print('\n  Empréstimos ativos:\n');
        loanService.printActive();
        final loanId = promptInt('\n  ID do empréstimo a devolver: ');
        if (loanId == null) break;
        final error = loanService.returnBook(loanId);
        if (error != null) {
          print('\n  ✗ $error');
        } else {
          print('\n  ✓ Devolução registrada com sucesso!');
        }
        pause();
        break;
      case '0':
        back = true;
        break;
      default:
        print('  ⚠ Opção inválida.');
    }
  }
}
