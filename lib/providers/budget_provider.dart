import 'package:flutter/foundation.dart';
import '../models/budget.dart';

class BudgetProvider with ChangeNotifier {
  List<Budget> _budgets = [];

  List<Budget> get budgets => _budgets;

  void addBudget(Budget budget) {
    int existingIndex = _budgets.indexWhere((b) => b.category == budget.category);
    if (existingIndex != -1) {
      _budgets[existingIndex] = budget;
    } else {
      _budgets.add(budget);
    }
    notifyListeners();
  }

  double getTotalSpent() {
    return _budgets.fold(0, (sum, budget) => sum + budget.spent);
  }

  double getTotalBudget() {
    return _budgets.fold(0, (sum, budget) => sum + budget.limit);
  }

  void updateBudget(Budget budget) {
    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) {
      _budgets[index] = budget;
      notifyListeners();
    }
  }

  void deleteBudget(String id) {
    _budgets.removeWhere((budget) => budget.id == id);
    notifyListeners();
  }

  void updateSpent(String id, double amount) {
    final index = _budgets.indexWhere((b) => b.id == id);
    if (index != -1) {
      _budgets[index] = _budgets[index].copyWith(
        spent: _budgets[index].spent + amount,
      );
      notifyListeners();
    }
  }
} 