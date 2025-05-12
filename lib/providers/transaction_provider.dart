import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/budget.dart';
import '../db/database_helper.dart';
import '../providers/budget_provider.dart';

class TransactionProvider with ChangeNotifier {
  // Mocklamak için _dbHelper'ı yorum satırı yapıyoruz
  // final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Transaction> _transactions = [];
  List<Budget> _budgets = [];
  
  // BudgetProvider referansını tutacak değişken
  BudgetProvider? _budgetProvider;

  List<Transaction> get transactions => _transactions;
  List<Budget> get budgets => _budgets;
  
  // BudgetProvider ile entegrasyon için metod
  void setBudgetProvider(BudgetProvider budgetProvider) {
    _budgetProvider = budgetProvider;
    _syncBudgets();
  }
  
  // BudgetProvider'dan bütçeleri senkronize etme metodu
  void _syncBudgets() {
    if (_budgetProvider != null) {
      _budgets = _budgetProvider!.budgets;
      notifyListeners();
    }
  }
  
  // Main.dart'ta çağrılacak senkronizasyon metodu
  void syncBudgetsFromProvider() {
    _syncBudgets();
  }

  // Tüm verileri veritabanından yükleme
  Future<void> loadData() async {
    // Veritabanını kullanmak yerine örnek veriler ekleyelim
    // _transactions = await _dbHelper.getTransactions();
    // _budgets = await _dbHelper.getBudgets();
    
    // Örnek veriler
    _transactions = [
      Transaction(
        id: '1',
        title: 'Maaş',
        amount: 10000,
        category: 'Maaş',
        type: 'income',
        date: DateTime.now().subtract(const Duration(days: 2)),
        currency: 'TRY',
      ),
      Transaction(
        id: '2',
        title: 'Market Alışverişi',
        amount: 450,
        category: 'Market',
        type: 'expense',
        date: DateTime.now().subtract(const Duration(days: 1)),
        currency: 'TRY',
      ),
      Transaction(
        id: '3',
        title: 'Kira',
        amount: 3500,
        category: 'Konut',
        type: 'expense',
        date: DateTime.now().subtract(const Duration(days: 5)),
        currency: 'TRY',
      ),
      Transaction(
        id: '4',
        title: 'Saç Bakım',
        amount: 200,
        category: 'Kuaför',
        type: 'expense',
        date: DateTime.now().subtract(const Duration(days: 3)),
        currency: 'TRY',
      ),
    ];
    
    // BudgetProvider'dan bütçeleri alacağımız için burada bütçe yüklemeye gerek yok
    if (_budgetProvider != null) {
      _syncBudgets();
    }
    
    notifyListeners();
  }

  // Uygulamayı başlattığında veriler yüklenir
  TransactionProvider() {
    loadData();
  }

  Future<void> addTransaction(Transaction transaction) async {
    // SQLite veritabanına kaydet
    // await _dbHelper.insertTransaction(transaction);
    
    // Belleğe ekle
    _transactions.add(transaction);
    
    // Bütçeyi güncelle
    _updateBudget(transaction);
    
    notifyListeners();
  }

  Future<void> _updateBudget(Transaction transaction) async {
    // Önce BudgetProvider'dan güncel bütçeleri al
    if (_budgetProvider != null) {
      _syncBudgets();
    }
    
    // Bu kategoride bir bütçe var mı kontrol et
    int existingBudgetIndex = _budgets.indexWhere((b) => b.category == transaction.category);
    
    if (existingBudgetIndex != -1) {
      // Eğer bu kategoride bir bütçe varsa, spent değerini güncelle
      Budget existingBudget = _budgets[existingBudgetIndex];
      if (transaction.type == 'expense') {
        Budget updatedBudget = Budget(
          id: existingBudget.id,
          category: existingBudget.category,
          limit: existingBudget.limit,
          spent: existingBudget.spent + transaction.amount,
          startDate: existingBudget.startDate,
          endDate: existingBudget.endDate,
        );
        
        // SQLite veritabanını güncelle
        // await _dbHelper.updateBudgetSpent(
        //  transaction.category, 
        //  existingBudget.spent + transaction.amount
        // );
        
        // Belleği güncelle
        _budgets[existingBudgetIndex] = updatedBudget;
        
        // BudgetProvider'ı da güncelle
        if (_budgetProvider != null) {
          _budgetProvider!.updateBudget(updatedBudget);
        }
      }
      notifyListeners();
    }
  }

  Future<void> addBudget(Budget budget) async {
    int existingIndex = _budgets.indexWhere((b) => b.category == budget.category);
    
    // SQLite veritabanına kaydet
    // await _dbHelper.insertBudget(budget);
    
    // Belleği güncelle
    if (existingIndex != -1) {
      _budgets[existingIndex] = budget;
    } else {
      _budgets.add(budget);
    }
    
    // BudgetProvider'ı da güncelle
    if (_budgetProvider != null) {
      _budgetProvider!.addBudget(budget);
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

  double getBalanceByCurrency(String currency) {
    double balance = 0;
    for (var transaction in _transactions) {
      if (transaction.currency == currency) {
        if (transaction.type == 'income') {
          balance += transaction.amount;
        } else {
          balance -= transaction.amount;
        }
      }
    }
    return balance;
  }

  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  double getBudgetSpent(String category) {
    // Önce BudgetProvider'dan güncel bütçeleri al
    if (_budgetProvider != null) {
      _syncBudgets();
    }
    
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
  
  Future<void> removeTransaction(String id) async {
    int index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      final transaction = _transactions[index];
      
      // SQLite veritabanından sil
      // await _dbHelper.deleteTransaction(id);
      
      // Belleğden sil
      _transactions.removeAt(index);
      
      // Bütçe güncelleme (eğer silinen işlem bir gider ise)
      if (transaction.type == 'expense') {
        // Önce BudgetProvider'dan güncel bütçeleri al
        if (_budgetProvider != null) {
          _syncBudgets();
        }
        
        int budgetIndex = _budgets.indexWhere((b) => b.category == transaction.category);
        if (budgetIndex != -1) {
          Budget existingBudget = _budgets[budgetIndex];
          Budget updatedBudget = Budget(
            id: existingBudget.id,
            category: existingBudget.category,
            limit: existingBudget.limit,
            spent: existingBudget.spent - transaction.amount,
            startDate: existingBudget.startDate,
            endDate: existingBudget.endDate,
          );
          
          // SQLite veritabanını güncelle
          // await _dbHelper.updateBudgetSpent(
          //  transaction.category, 
          //  existingBudget.spent - transaction.amount
          // );
          
          // Belleği güncelle
          _budgets[budgetIndex] = updatedBudget;
          
          // BudgetProvider'ı da güncelle
          if (_budgetProvider != null) {
            _budgetProvider!.updateBudget(updatedBudget);
          }
        }
      }
      
      notifyListeners();
    }
  }
  
  // Bütçeyi sil
  Future<void> deleteBudget(String id) async {
    // SQLite veritabanından sil
    // await _dbHelper.deleteBudget(id);
    
    // Belleğden sil
    _budgets.removeWhere((budget) => budget.id == id);
    
    // BudgetProvider'ı da güncelle
    if (_budgetProvider != null && id.isNotEmpty) {
      _budgetProvider!.deleteBudget(id);
    }
    
    notifyListeners();
  }
} 