import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../providers/budget_provider.dart';
import '../models/budget.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedType = 'expense';
  String _selectedCategory = 'Diğer';
  String _selectedCurrency = 'TRY';
  
  List<String> _categories = [
    'Yemek',
    'Ulaşım',
    'Alışveriş',
    'Eğlence',
    'Sağlık',
    'Eğitim',
    'Fatura',
    'Kuaför',
    'Diğer',
  ];

  final List<String> _currencies = ['TRY', 'USD'];

  @override
  void initState() {
    super.initState();
    // Providers initialize edildiğinde bütçe kategorilerini al
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBudgetCategories();
    });
  }

  // Bütçe kategorilerini yükle
  void _loadBudgetCategories() {
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    final budgets = budgetProvider.budgets;
    
    // Bütçe kategorilerini set ile birleştirip uniq olanları al
    final budgetCategories = budgets.map((b) => b.category).toList();
    
    // Eğer bütçeler varsa, kategorileri güncelle
    if (budgetCategories.isNotEmpty) {
      // Önce mevcut sabit kategorileri ve bütçe kategorilerini birleştir
      final Set<String> uniqueCategories = {..._categories, ...budgetCategories};
      
      setState(() {
        _categories = uniqueCategories.toList();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        id: DateTime.now().toString(),
        title: _titleController.text,
        category: _selectedCategory,
        amount: double.parse(_amountController.text),
        type: _selectedType,
        date: DateTime.now(),
        currency: _selectedCurrency,
      );

      // İşlemi ekle
      context.read<TransactionProvider>().addTransaction(transaction);
      
      // Kullanıcıya başarılı mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('İşlem kaydedildi'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.of(context).pop();
    }
  }

  // Seçilen kategorinin bir bütçesi olup olmadığını kontrol et
  Widget _buildBudgetInfo() {
    if (_selectedType != 'expense') return const SizedBox.shrink();
    
    return Consumer2<BudgetProvider, TransactionProvider>(
      builder: (context, budgetProvider, transactionProvider, _) {
        // Seçilen kategori için bütçe bilgisini al
        final budget = budgetProvider.budgets.firstWhere(
          (b) => b.category == _selectedCategory,
          orElse: () => Budget(
            id: '', 
            category: _selectedCategory,
            limit: 0,
            spent: 0,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 30)),
          ),
        );
        
        if (budget.id.isEmpty) {
          return const SizedBox.shrink();
        }
        
        final amount = double.tryParse(_amountController.text) ?? 0;
        final remainingBudget = budget.limit - budget.spent - (_selectedType == 'expense' ? amount : 0);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: remainingBudget < 0 ? Colors.red[50] : Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: remainingBudget < 0 ? Colors.red : Colors.green,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_selectedCategory} Bütçe Bilgisi',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: remainingBudget < 0 ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Toplam Bütçe: ₺${budget.limit.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    Text(
                      'Harcanan: ₺${budget.spent.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'İşlem Sonrası Kalan: ₺${remainingBudget.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: remainingBudget < 0 ? Colors.red : Colors.green,
                  ),
                ),
                if (remainingBudget < 0)
                  Text(
                    'Bu işlem bütçe limitini aşacak!',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Yeni İşlem',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir başlık girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Miktar',
                      border: const OutlineInputBorder(),
                      prefixText: _selectedCurrency == 'TRY' ? '₺' : '\$',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir miktar girin';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Geçerli bir sayı girin';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Değer değiştiğinde state'i güncelle ki bütçe bilgisi güncellensin
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCurrency,
                    underline: const SizedBox(),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCurrency = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                // Bütçeli kategorileri işaretle
                final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
                final hasBudget = budgetProvider.budgets.any((b) => b.category == category);
                
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Text(category),
                      if (hasBudget)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.account_balance_wallet, size: 16, color: Colors.green),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Gider'),
                    value: 'expense',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Gelir'),
                    value: 'income',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            _buildBudgetInfo(),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
} 