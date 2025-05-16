import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/transaction_provider.dart';
import '../providers/budget_provider.dart';
import '../utils/utils.dart';
import '../screens/transaction_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedCategory;
  late AnimationController _animationController;
  Animation<double>? _tryAnimation;
  Animation<double>? _usdAnimation;
  double _displayedTryBalance = 0;
  double _displayedUsdBalance = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _tryAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _usdAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations(double tryBalance, double usdBalance) {
    if (_displayedTryBalance != tryBalance ||
        _displayedUsdBalance != usdBalance) {
      _tryAnimation = Tween<double>(
        begin: _displayedTryBalance,
        end: tryBalance,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));

      _usdAnimation = Tween<double>(
        begin: _displayedUsdBalance,
        end: usdBalance,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));

      _displayedTryBalance = tryBalance;
      _displayedUsdBalance = usdBalance;
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FinTrack',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: () => _showAddTransactionSheet(context),
          ),
        ],
      ),
      body: Consumer2<TransactionProvider, BudgetProvider>(
        builder: (context, transactionProvider, budgetProvider, child) {
          final tryBalance = transactionProvider.getBalanceByCurrency('TRY');
          final usdBalance = transactionProvider.getBalanceByCurrency('USD');

          // Setup animations for balance values
          _setupAnimations(tryBalance, usdBalance);

          // Filter transactions by category if selected
          final filteredTransactions = _selectedCategory != null
              ? transactionProvider
                  .getTransactionsByCategory(_selectedCategory!)
              : transactionProvider.transactions;

          // Get budgets for the category chips
          final budgets = budgetProvider.budgets;

          return RefreshIndicator(
            onRefresh: () async {
              // Simulating a refresh operation
              await Future.delayed(const Duration(seconds: 1));
              setState(() {
                // Refresh UI
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'İşlemler yenilendi',
                    style: GoogleFonts.poppins(),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TL Bakiye',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '₺${_tryAnimation?.value.toStringAsFixed(2) ?? '0.00'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: tryBalance >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn().slideX(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'USD Bakiye',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${_usdAnimation?.value.toStringAsFixed(2) ?? '0.00'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: usdBalance >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn().slideX(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bütçe Kategorileri
                  if (budgets.isNotEmpty) _buildBudgetCategories(budgets),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Son İşlemler',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedCategory != null)
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = null;
                            });
                          },
                          icon: const Icon(Icons.filter_list_off),
                          label: const Text('Filtreyi Kaldır'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 16),
                  if (filteredTransactions.isEmpty)
                    Center(
                      child: Text(
                        _selectedCategory != null
                            ? 'Bu kategoride işlem bulunmuyor'
                            : 'Henüz işlem bulunmuyor',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                        ),
                      ),
                    ).animate().fadeIn()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return Dismissible(
                          key: Key(transaction.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'İşlemi Sil',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                    '${transaction.title} işlemini silmek istediğinizden emin misiniz?',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('İptal',
                                          style: GoogleFonts.poppins()),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Sil',
                                        style: GoogleFonts.poppins(
                                            color: Colors.red),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            Provider.of<TransactionProvider>(context,
                                    listen: false)
                                .removeTransaction(transaction.id);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${transaction.title} silindi',
                                  style: GoogleFonts.poppins(),
                                ),
                                action: SnackBarAction(
                                  label: 'GERI AL',
                                  onPressed: () {
                                    Provider.of<TransactionProvider>(context,
                                            listen: false)
                                        .addTransaction(transaction);
                                  },
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: transaction.type == 'income'
                                    ? Colors.green[100]
                                    : Colors.red[100],
                                child: Icon(
                                  transaction.type == 'income'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: transaction.type == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              title: Text(
                                transaction.title,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    transaction.category,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  // Eğer işlem bir bütçe kategorisine aitse, bütçe simgesi göster
                                  if (budgets.any((b) =>
                                      b.category == transaction.category))
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Icon(
                                        Icons.account_balance_wallet,
                                        size: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                ],
                              ),
                              trailing: Text(
                                '${transaction.currency == 'TRY' ? '₺' : '\$'}${transaction.amount.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: transaction.type == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn().slideX();
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Bütçe kategorilerini chips olarak gösteren widget
  Widget _buildBudgetCategories(List<dynamic> budgets) {
    if (budgets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bütçe Kategorileri',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Tüm kategorileri gösteren chip
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  avatar: const Icon(Icons.category, size: 18),
                  label: Text(
                    'Tümü',
                    style: GoogleFonts.poppins(
                      fontWeight: _selectedCategory == null
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  backgroundColor: _selectedCategory == null
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : null,
                  onPressed: () {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                ),
              ),
              ...budgets.map((budget) {
                // Her bir bütçe için kalan miktarı hesapla
                final remaining = budget.limit - budget.spent;
                final isOverBudget = remaining < 0;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    avatar: Icon(
                      isOverBudget
                          ? Icons.warning
                          : Icons.account_balance_wallet,
                      size: 18,
                      color: isOverBudget ? Colors.red : Colors.green,
                    ),
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.category,
                          style: GoogleFonts.poppins(
                            fontWeight: _selectedCategory == budget.category
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          '₺${remaining.toStringAsFixed(0)} kaldı',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: isOverBudget ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: _selectedCategory == budget.category
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                        : isOverBudget
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                    onPressed: () {
                      setState(() {
                        _selectedCategory = budget.category;
                      });
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const TransactionFormScreen(),
      ),
    );
  }
}
