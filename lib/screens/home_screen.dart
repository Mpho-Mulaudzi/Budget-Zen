import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_logo.dart';
import '../widgets/monthly_summary.dart';
import '../widgets/currency_picker.dart';
import '../services/ad_service.dart';
import '../theme_provider.dart';
import '../widgets/about_page.dart';
import '../widgets/privacy_policy_page.dart';
import 'package:huawei_ads/huawei_ads.dart' as hms;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0;
  List<Map<String, dynamic>> expenses = [];
  String currency = "\$";
  bool adShownForIncome = false;
  bool adShownForExpense = false;
  hms.BannerView? _banner;

  final List<Map<String, dynamic>> categories = [
    {"name": "Rent", "icon": Icons.home, "color": Colors.orange},
    {"name": "Transport", "icon": Icons.directions_car, "color": Colors.blue},
    {"name": "Groceries", "icon": Icons.shopping_cart, "color": Colors.green},
    {"name": "Food", "icon": Icons.fastfood, "color": Colors.pinkAccent},
    {"name": "Health", "icon": Icons.health_and_safety, "color": Colors.red},
    {"name": "Entertainment", "icon": Icons.movie, "color": Colors.purple},
    {"name": "Utilities", "icon": Icons.lightbulb, "color": Colors.yellow},
    {"name": "Other", "icon": Icons.wallet, "color": Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadPrefs();
    await AdManager().initialize();
    _banner = hms.BannerView(
      adSlotId:'testw6vs28auh3', //'o00thys67r',
      size: hms.BannerAdSize.s320x50,
    );
    setState(() {});
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    balance = prefs.getDouble("balance") ?? 0;
    currency = prefs.getString("currency") ?? "\$";
    expenses = (prefs.getStringList("expenses") ?? [])
        .map((e) => _decodeExpense(e))
        .toList();
    setState(() {});
  }

  Map<String, dynamic> _decodeExpense(String s) {
    final p = s.split("|");
    return {"date": p[0], "category": p[1], "amount": double.parse(p[2])};
  }

  String _encode(Map<String, dynamic> e) =>
      "${e["date"]}|${e["category"]}|${e["amount"]}";

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
      ..setDouble("balance", balance)
      ..setString("currency", currency)
      ..setStringList("expenses", expenses.map((e) => _encode(e)).toList());
  }

  void _addTransaction(String type) {
    final controller = TextEditingController();
    String selectedCategory = categories.first["name"];

    showDialog(
      context: context,
      builder: (_) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          // 💎 always white background
          title: Text(
            "Add ${type == "income" ? "Income" : "Expense"}",
            style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount ($currency)",
                    border: const OutlineInputBorder(),
                  ),
                ),
                if (type == "expense") ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                    items: categories
                        .map((c) => DropdownMenuItem<String>(
                      value: c["name"],
                      child: Text(c["name"]),
                    ))
                        .toList(),
                    onChanged: (v) => selectedCategory = v!,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: theme.colorScheme.secondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final amount = double.tryParse(controller.text.trim());
                if (amount == null || amount <= 0) return;
                Navigator.pop(context);

                if (type == "income") {
                  balance += amount;
                  if (!adShownForIncome) {
                    adShownForIncome = true;
                    AdManager().showAdIfAvailable();
                  }
                } else {
                  if (amount > balance) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Insufficient balance for this expense!"),
                      ),
                    );
                    return;
                  }
                  balance -= amount;
                  expenses.insert(0, {
                    "date": DateTime.now().toString().substring(0, 16),
                    "category": selectedCategory,
                    "amount": amount,
                  });
                  if (!adShownForExpense) {
                    adShownForExpense = true;
                    AdManager().showAdIfAvailable();
                  }
                }
                _savePrefs();
                setState(() {});
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _chooseCurrency() async {
    final result = await showCurrencyPicker(context, currency);
    if (result != null) {
      setState(() => currency = result["symbol"]!);
      _savePrefs();
    }
  }

  Future<void> _resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      balance = 0;
      expenses.clear();
      currency = "\$";
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDark = themeProvider.isDarkTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            AppLogo(size: 36),
            SizedBox(width: 8),
            Text("BudgetZen",
            style: TextStyle(
              fontSize: 14
            ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _chooseCurrency,
            icon: const Icon(Icons.currency_exchange_rounded),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          )
        ],
      ),
      drawer: _buildDrawer(context, theme),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Current Balance",
                            style:
                            TextStyle(fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(
                          "$currency${balance.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : theme.colorScheme.tertiary,
                    ),
                    onPressed: () => _addTransaction("income"),
                    icon:  Icon(Icons.add,
                        color: Theme.of(context).brightness == Brightness.light
                        ? theme.colorScheme.primary
                        : Colors.white,
                    ),
                    label: Text("Add Income",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? theme.colorScheme.primary
                            : Colors.white,
                        fontSize: 11
                      ),

                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                    ),
                    onPressed: () => _addTransaction("expense"),
                    icon: const Icon(Icons.remove,color: Colors.white),
                    label: const Text("Add Expense",
                      style: TextStyle(
                        color: Colors.white, fontSize: 11)

                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 30),
              // 🟢 Monthly summary title visible in light mode
              Text(
                "Monthly Summary",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  // Use adaptive color for better visibility on light mode
                  color: Theme.of(context).brightness == Brightness.light
                      ? theme.colorScheme.secondary
                      : Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              MonthlySummary(expenses: expenses, currency: currency),
              const SizedBox(height: 30),
              Text("Recent Expenses",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.light
                        ? theme.colorScheme.secondary
                        : Colors.white,)),
              const SizedBox(height: 10),
              ...expenses.map((e) {
                final cat = categories.firstWhere(
                        (c) => c["name"] == e["category"],
                    orElse: () => categories.last);
                return Card(
                  color: theme.cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cat["color"],
                      child: Icon(cat["icon"], color: Colors.white, size: 20),
                    ),
                    title: Text(
                      e["category"],
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black87
                            : Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      e["date"],
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black54
                            : Colors.grey[300],
                      ),
                    ),
                    trailing: Text(
                      "-$currency${e["amount"].toStringAsFixed(2)}",
                      style: TextStyle(
                        color: cat["color"],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              if (_banner != null) SizedBox(height: 50, child: _banner),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, ThemeData theme) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  AppLogo(size: 70),
                  SizedBox(height: 10),
                  Text("BudgetZen",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 22))
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.info,
              color: theme.colorScheme.primary),
              title: Text(
                "About",
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip,
                  color: theme.colorScheme.primary),
              title: Text(
                "Privacy Policy",
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.refresh,
                  color: theme.colorScheme.primary
              ),
              title: Text(
                "Clear All Data",
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
              onTap: _resetAll,
            ),
          ],
        ),
      ),
    );
  }
}