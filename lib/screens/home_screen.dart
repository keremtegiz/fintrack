import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/transaction_provider.dart';
import '../utils/utils.dart';
import '../screens/transaction_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final totalBalance = provider.getTotalBalance();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Toplam Bakiye',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Utils.formatCurrency(totalBalance),
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: totalBalance >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 24),
                Text(
                  'Son İşlemler',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 16),
                if (provider.transactions.isEmpty)
                  Center(
                    child: Text(
                      'Henüz işlem bulunmuyor',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                      ),
                    ),
                  ).animate().fadeIn()
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = provider.transactions[index];
                      return Card(
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
                          subtitle: Text(
                            transaction.category,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Text(
                            Utils.formatCurrency(transaction.amount),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: transaction.type == 'income'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ).animate().fadeIn().slideX();
                    },
                  ),
              ],
            ),
          );
        },
      ),
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
