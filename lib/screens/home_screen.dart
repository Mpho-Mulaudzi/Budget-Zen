import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_logo.dart';
import '../widgets/monthly_summary.dart';
import '../widgets/currency_picker.dart';
import '../widgets/language_picker.dart';
import '../services/ad_service.dart';
import '../theme_provider.dart';
import '../widgets/app_localizations.dart';
import '../widgets/about_page.dart';
import '../widgets/privacy_policy_page.dart';
import '../language_provider.dart';
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
  // hms.BannerView? _banner;

  // Categories will be dynamically localized
  List<Map<String, dynamic>> get categories {
    final loc = AppLocalizations.of(context);
    return [
      {"name": loc.rent, "icon": Icons.home, "color": Colors.orange},
      {"name": loc.transport, "icon": Icons.directions_car, "color": Colors.blue},
      {"name": loc.groceries, "icon": Icons.shopping_cart, "color": Colors.green},
      {"name": loc.food, "icon": Icons.fastfood, "color": Colors.pinkAccent},
      {"name": loc.health, "icon": Icons.health_and_safety, "color": Colors.red},
      {"name": loc.entertainment, "icon": Icons.movie, "color": Colors.purple},
      {"name": loc.utilities, "icon": Icons.lightbulb, "color": Colors.yellow},
      {"name": loc.other, "icon": Icons.wallet, "color": Colors.grey},
    ];
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadPrefs();
    await AdManager().initialize();
    // _banner = hms.BannerView(
    //   adSlotId:'o00thys67r',
    //   size: hms.BannerAdSize.s320x50,
    // );
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPrivacyPolicy();
    });
  }


  Future<void> _checkPrivacyPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    bool accepted = prefs.getBool('privacyAccepted') ?? false;
    if (!accepted) {
      _showPrivacyPolicyDialog();
    }
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text("Privacy Policy",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: const Text(
              "Your privacy is important. By using this app, you agree to our Privacy Policy. "
                  "Please read it carefully.",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('privacyAccepted', true);
              Navigator.of(context).pop();
            },
            child: const Text("Accept", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
  // -------------------------------------------------------------------


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
    final loc = AppLocalizations.of(context);
    final controller = TextEditingController();
    String selectedCategory = categories.first["name"];

    showDialog(
      context: context,
      builder: (_) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            type == "income" ? loc.addIncome : loc.addExpense,
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
                    labelText: "${loc.amount} ($currency)",
                    border: const OutlineInputBorder(),
                  ),
                ),
                if (type == "expense") ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: loc.category,
                      border: const OutlineInputBorder(),
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
              child: Text(loc.cancel, style: TextStyle(color: theme.colorScheme.secondary)),
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
                      SnackBar(
                        content: Text(loc.insufficientBalance),
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
              child: Text(loc.save),
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
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 36),
            const SizedBox(width: 8),
            Text(
              loc.appName,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => showLanguagePicker(context),
            icon: const Icon(Icons.language),
            tooltip: loc.selectLanguage,
          ),
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
      drawer: _buildDrawer(context, theme, loc),
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
                        Text(loc.currentBalance,
                            style:
                            const TextStyle(fontSize: 14, color: Colors.grey)),
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
                    label: Text(loc.addIncome,
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
                    label: Text(loc.addExpense,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11)
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 30),
              Text(
                loc.monthlySummary,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.light
                      ? theme.colorScheme.secondary
                      : Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              MonthlySummary(expenses: expenses, currency: currency),
              const SizedBox(height: 30),
              Text(loc.recentExpenses,
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
              SizedBox(
                height: 50,
                child: AdManager().getBanner(),
              ),
              // if (_banner != null) SizedBox(height: 50, child: _banner),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(size: 70),
                  const SizedBox(height: 10),
                  Text(loc.appName,
                      style: const TextStyle(
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
                loc.about,
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
                loc.privacyPolicy,
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
                loc.clearAllData,
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