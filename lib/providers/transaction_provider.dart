import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/budget.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Budget> _budgets = [];

  List<Transaction> get transactions => _transactions;
  List<Budget> get budgets => _budgets;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _updateBudget(transaction);
    notifyListeners();
  }

  void _updateBudget(Transaction transaction) {
    // Bu kategoride bir bütçe var mı kontrol et
    int existingBudgetIndex = _budgets.indexWhere((b) => b.category == transaction.category);
    
    if (existingBudgetIndex != -1) {
      // Eğer bu kategoride bir bütçe varsa, spent değerini güncelle
      Budget existingBudget = _budgets[existingBudgetIndex];
      if (transaction.type == 'expense') {
        _budgets[existingBudgetIndex] = Budget(
          id: existingBudget.id,
          category: existingBudget.category,
          limit: existingBudget.limit,
          spent: existingBudget.spent + transaction.amount,
          startDate: existingBudget.startDate,
          endDate: existingBudget.endDate,
        );
      }
      notifyListeners();
    }
  }

  void addBudget(Budget budget) {
    int existingIndex = _budgets.indexWhere((b) => b.category == budget.category);
    if (existingIndex != -1) {
      _budgets[existingIndex] = budget;
    } else {
      _budgets.add(budget);
    }
    notifyListeners();
  }

  double getTotalBalance() {
    double total = 0;
    for (var transaction in _transactions) {
      if (transaction.type == 'income') {
        total += transaction.amount;
      } else {
        total -= transaction.amount;
      }
    }
    return total;
  }

  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  double getBudgetSpent(String category) {
    final budget = _budgets.firstWhere(
      (b) => b.category == category,
      orElse: () => Budget(
        id: DateTime.now().toString(),
        category: category,
        limit: 0,
        spent: 0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
      ),
    );
    return budget.spent;
  }
} 