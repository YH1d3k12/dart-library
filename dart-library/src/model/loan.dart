class Loan {
  final int? id;
  final int bookId;
  final int userId;
  final DateTime loanDate;
  final DateTime dueDate;
  final DateTime? returnedDate;

  Loan({
    this.id,
    required this.bookId,
    required this.userId,
    DateTime? loanDate,
    DateTime? dueDate,
    this.returnedDate,
  })  : loanDate = loanDate ?? DateTime.now(),
        dueDate = dueDate ?? DateTime.now().add(const Duration(days: 14));

  bool get isReturned => returnedDate != null;
  bool get isOverdue => !isReturned && DateTime.now().isAfter(dueDate);
  
  @override
  String toString() =>
      'Loan(id: $id, bookId: $bookId, userId: $userId, loanDate: ${loanDate.toIso8601String()}, returned: $isReturned)';
}
