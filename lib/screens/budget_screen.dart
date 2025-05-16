import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import '../models/budget.dart';
import '../providers/budget_provider.dart';
import '../providers/transaction_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen>
    with SingleTickerProviderStateMixin {
  bool _isGridView = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  final _categoryController = TextEditingController();
  String _selectedCategory = 'Diğer';

  final List<String> _categories = [
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _limitController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _showBudgetDetails(BuildContext context, Budget budget, double spent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${budget.category} Bütçe Detayı',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(color: Colors.black),
                  children: [
                    const TextSpan(
                      text: 'Toplam Bütçe: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '₺${budget.limit.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(color: Colors.black),
                  children: [
                    const TextSpan(
                      text: 'Harcanan: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '₺${spent.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: spent > budget.limit ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(color: Colors.black),
                  children: [
                    const TextSpan(
                      text: 'Kalan: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '₺${(budget.limit - spent).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: budget.limit - spent < 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: budget.limit > 0 ? spent / budget.limit : 1,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  spent > budget.limit ? Colors.red : const Color(0xFF1D5C42),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Kapat', style: GoogleFonts.poppins()),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bütçe Yönetimi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: _toggleView,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: () => _showAddBudgetForm(context),
          ),
        ],
      ),
      body: Consumer2<BudgetProvider, TransactionProvider>(
        builder: (context, budgetProvider, transactionProvider, child) {
          final budgets = budgetProvider.budgets;

          if (budgets.isEmpty) {
            return Center(
              child: Text(
                'Henüz bütçe tanımı yok',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Implement refresh logic here
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _BudgetOverviewCard(
                    totalBudget: budgetProvider.getTotalBudget(),
                    totalSpent: budgetProvider.getTotalSpent(),
                  ),
                  if (budgets.length > 1) _BudgetPieChart(budgets: budgets),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isGridView
                        ? _BudgetGrid(
                            budgets: budgets,
                            animation: _animation,
                            onBudgetDetailTap: _showBudgetDetails,
                          )
                        : _BudgetList(
                            budgets: budgets,
                            animation: _animation,
                            onBudgetDetailTap: _showBudgetDetails,
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddBudgetForm(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _AddBudgetDialog(
        initialCategory: _selectedCategory,
        categories: _categories,
        onBudgetAdded: (category) {
          if (mounted) {
            setState(() {
              _selectedCategory = category;
            });
          }
        },
      ),
    );
  }
}

class _AddBudgetDialog extends StatefulWidget {
  final String initialCategory;
  final List<String> categories;
  final Function(String) onBudgetAdded;

  const _AddBudgetDialog({
    required this.initialCategory,
    required this.categories,
    required this.onBudgetAdded,
  });

  @override
  State<_AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<_AddBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Yeni Bütçe Ekle',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: widget.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir kategori seçin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _limitController,
                decoration: const InputDecoration(
                  labelText: 'Bütçe Limiti',
                  border: OutlineInputBorder(),
                  prefixText: '₺',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir limit girin';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir sayı girin';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'İptal',
            style: GoogleFonts.poppins(color: Colors.grey[700]),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                final budget = Budget(
                  id: DateTime.now().toString(),
                  category: _selectedCategory,
                  limit: double.parse(_limitController.text),
                  spent: 0,
                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(const Duration(days: 30)),
                );

                final budgetProvider =
                    Provider.of<BudgetProvider>(context, listen: false);
                await budgetProvider.addBudget(budget);
                widget.onBudgetAdded(_selectedCategory);
                Navigator.of(context).pop();
              } catch (e) {
                print("Budget eklenirken hata: $e");
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bütçe eklenemedi: $e')),
                  );
                }
              }
            }
          },
          child: Text(
            'Ekle',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _BudgetOverviewCard extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;

  const _BudgetOverviewCard({
    required this.totalBudget,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    final remainingBudget = totalBudget - totalSpent;
    final spentPercentage =
        totalBudget > 0 ? (totalSpent / totalBudget * 100) : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Toplam Bütçe',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₺${totalBudget.toStringAsFixed(2)}',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (spentPercentage > 90)
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '%${spentPercentage.toStringAsFixed(1)} kullanıldı',
                    style: TextStyle(
                      color: (spentPercentage > 90) ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: totalBudget > 0 ? totalSpent / totalBudget : 0,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  spentPercentage > 90 ? Colors.red : Colors.green,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BudgetStatItem(
                  title: 'Harcanan',
                  amount: totalSpent,
                  color: Colors.orange,
                ),
                _BudgetStatItem(
                  title: 'Kalan',
                  amount: remainingBudget,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetStatItem extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;

  const _BudgetStatItem({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                border: Border.all(color: color, width: 2),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '₺${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BudgetPieChart extends StatelessWidget {
  final List<Budget> budgets;

  const _BudgetPieChart({required this.budgets});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending Distribution',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 35,
                        sections: budgets.map((budget) {
                          final index = budgets.indexOf(budget);
                          final color =
                              Colors.primaries[index % Colors.primaries.length];
                          return PieChartSectionData(
                            color: color,
                            value: budget.spent,
                            title:
                                '${(budget.spentPercentage).toStringAsFixed(0)}%',
                            radius: 90,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: budgets.map((budget) {
                        final index = budgets.indexOf(budget);
                        final color =
                            Colors.primaries[index % Colors.primaries.length];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  budget.category,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetGrid extends StatelessWidget {
  final List<Budget> budgets;
  final Animation<double> animation;
  final Function(BuildContext, Budget, double) onBudgetDetailTap;

  const _BudgetGrid({
    required this.budgets,
    required this.animation,
    required this.onBudgetDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: budgets.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final budget = budgets[index];
        final color = Colors.primaries[index % Colors.primaries.length];

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.2),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Interval(
                index * 0.1,
                1.0,
                curve: Curves.easeOut,
              ),
            )),
            child: Dismissible(
              key: Key(budget.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Budget'),
                      content: Text(
                          'Are you sure you want to delete ${budget.category} budget?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('DELETE'),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                Provider.of<BudgetProvider>(context, listen: false)
                    .deleteBudget(budget.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${budget.category} budget deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        Provider.of<BudgetProvider>(context, listen: false)
                            .addBudget(budget);
                      },
                    ),
                  ),
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: GestureDetector(
                onDoubleTap: () {
                  onBudgetDetailTap(context, budget, budget.spent);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.2),
                                border: Border.all(color: color, width: 2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                budget.category,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onDoubleTap: () {
                                onBudgetDetailTap(
                                    context, budget, budget.spent);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          '₺${budget.spent.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Text(
                          'Toplam: ₺${budget.limit.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: budget.spent / budget.limit,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      budget.isOverBudget ? Colors.red : color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: budget.isOverBudget
                                ? Colors.red.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${budget.spentPercentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: budget.isOverBudget
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BudgetList extends StatelessWidget {
  final List<Budget> budgets;
  final Animation<double> animation;
  final Function(BuildContext, Budget, double) onBudgetDetailTap;

  const _BudgetList({
    required this.budgets,
    required this.animation,
    required this.onBudgetDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        final budget = budgets[index];
        final color = Colors.primaries[index % Colors.primaries.length];

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.2, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Interval(
                index * 0.1,
                1.0,
                curve: Curves.easeOut,
              ),
            )),
            child: Dismissible(
              key: Key(budget.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Budget'),
                      content: Text(
                          'Are you sure you want to delete ${budget.category} budget?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('DELETE'),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                Provider.of<BudgetProvider>(context, listen: false)
                    .deleteBudget(budget.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${budget.category} budget deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        Provider.of<BudgetProvider>(context, listen: false)
                            .addBudget(budget);
                      },
                    ),
                  ),
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: GestureDetector(
                onDoubleTap: () {
                  onBudgetDetailTap(context, budget, budget.spent);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.2),
                                    border: Border.all(color: color, width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  budget.category,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: budget.isOverBudget
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${budget.spentPercentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: budget.isOverBudget
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: budget.spent / budget.limit,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      budget.isOverBudget ? Colors.red : color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Harcanan: ₺${budget.spent.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Limit: ₺${budget.limit.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        if (budget.isOverBudget) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Over budget by ₺${(budget.spent - budget.limit).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
