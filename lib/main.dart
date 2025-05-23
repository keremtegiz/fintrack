import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/budget_screen.dart';
// import 'screens/login_screen.dart';
import 'models/budget.dart';
import 'providers/budget_provider.dart';
import 'providers/transaction_provider.dart';
import 'services/auth_service.dart';

void main() async {
  // Flutter Firebase başlatma
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Önce BudgetProvider oluşturuyoruz ve sonra TransactionProvider'a veriyoruz
    final budgetProvider = BudgetProvider();
    final transactionProvider = TransactionProvider();

    // Provider'lar arası entegrasyonu başlatma
    WidgetsBinding.instance.addPostFrameCallback((_) {
      transactionProvider.setBudgetProvider(budgetProvider);
      transactionProvider.syncBudgetsFromProvider();
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider.value(value: transactionProvider),
        ChangeNotifierProvider.value(value: budgetProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FinTrack',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1D5C42),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          cardTheme: CardTheme(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            elevation: 8,
            selectedItemColor: Color(0xFF1D5C42),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedIconTheme: IconThemeData(size: 28),
            unselectedIconTheme: IconThemeData(size: 24),
          ),
        ),
        // Firebase'i devre dışı bıraktık, doğrudan DashboardScreen'i gösteriyoruz
        home: const DashboardScreen(),
        /*
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            // Kullanıcı girişi yapıldıysa DashboardScreen'i, aksi takdirde LoginScreen'i göster
            return authService.isSignedIn ? const DashboardScreen() : const LoginScreen();
          },
        ),
        */
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    BudgetScreen(),
    SettingsScreen(),
  ];

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: "Home"),
    BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet_outlined),
        activeIcon: Icon(Icons.account_balance_wallet),
        label: "Budget"),
    BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        activeIcon: Icon(Icons.settings),
        label: "Currency"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        type: BottomNavigationBarType.fixed,
        items: _navItems,
      ),
    );
  }
}
