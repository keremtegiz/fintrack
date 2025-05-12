import 'package:flutter/foundation.dart';
import '../models/budget.dart';
import '../db/database_helper.dart';

class BudgetProvider with ChangeNotifier {
  // final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Budget> _budgets = [];

  List<Budget> get budgets => _budgets;

  // Uygulamayı başlattığında veriler yüklenir
  BudgetProvider() {
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    // SQLite kullanımı kapalı olduğu için örnek veriler kullanıyoruz
    // _budgets = await _dbHelper.getBudgets();
    
    // Not: Artık örnek verileri burada tanımlamıyoruz
    // TransactionProvider'dan senkronize edilerek alınacak
    notifyListeners();
  }

  Future<void> addBudget(Budget budget) async {
    // SQLite veritabanına kaydet
    // await _dbHelper.insertBudget(budget);
    
    // Belleğe ekle
    int existingIndex = _budgets.indexWhere((b) => b.category == budget.category);
    if (existingIndex != -1) {
      _budgets[existingIndex] = budget;
    } else {
      _budgets.add(budget);
    }
    
    notifyListeners();
  }

  Future<void> deleteBudget(String id) async {
    // SQLite veritabanından sil
    // await _dbHelper.deleteBudget(id);
    
    // Belleğden sil
    _budgets.removeWhere((budget) => budget.id == id);
    
    notifyListeners();
  }

  double getTotalBudget() {
    return _budgets.fold(0, (total, budget) => total + budget.limit);
  }

  double getTotalSpent() {
    return _budgets.fold(0, (total, budget) => total + budget.spent);
  }

  void updateBudget(Budget budget) {
    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) {
      _budgets[index] = budget;
      notifyListeners();
    } else {
      // Eğer bütçe yoksa ekleyelim
      addBudget(budget);
    }
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
  
  // Tüm bütçeleri temizle ve yenilerini ayarla
  void setBudgets(List<Budget> budgets) {
    _budgets = [...budgets];
    notifyListeners();
  }
  
  // Kategori adına göre bütçe bilgisini al
  Budget? getBudgetForCategory(String category) {
    try {
      return _budgets.firstWhere((b) => b.category == category);
    } catch (e) {
      return null;
    }
  }
} 