import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_logo.dart';
import '../widgets/monthly_summary.dart';
import '../dialogs/ad_dialogs.dart';
import '../widgets/currency_picker.dart';
import '../services/currency_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0;
  List<Map<String, dynamic>> expenses = [];
  bool adShownForIncome = false;
  bool adShownForExpense = false;
  String currency = "\$";

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
    _loadPrefs();
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

  String _encodeExpense(Map<String, dynamic> e) =>
      "${e["date"]}|${e["category"]}|${e["amount"]}";

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs
      ..setDouble("balance", balance)
      ..setString("currency", currency)
      ..setStringList(
          "expenses", expenses.map((e) => _encodeExpense(e)).toList());
  }

  // ------------------------------------------------------------------
  void _addTransaction(String type) {
    final controller = TextEditingController();
    String selectedCategory = categories.first["name"] as String;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: Text("Add ${type == "income" ? "Income" : "Expense"}",
              style: const TextStyle(color: Colors.white)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Amount ($currency)",
                  labelStyle: const TextStyle(color: Colors.white70)),
            ),
            if (type == "expense") ...[
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: const Color(0xFF2C2C2C),
                  style: const TextStyle(color: Colors.white),
                  items: categories
                      .map((c) => DropdownMenuItem<String>(
                      value: c["name"] as String,
                      child: Text(c["name"] as String)))
                      .toList(),
                  onChanged: (v) => selectedCategory = v!,
                  decoration: const InputDecoration(
                      labelText: "Category",
                      labelStyle: TextStyle(color: Colors.white70))),
            ]
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.white))),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676)),
                onPressed: () {
                  final amount = double.tryParse(controller.text.trim());
                  if (amount == null || amount <= 0) return;
                  Navigator.pop(context);

                  if (type == "income") {
                    balance += amount;
                    if (!adShownForIncome) {
                      adShownForIncome = true;
                      _showAdDialog();
                    }
                  } else {
                    if (amount > balance) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Insufficient balance for this expense!")));
                      return;
                    }
                    balance -= amount;
                    final exp = {
                      "date":
                      DateTime.now().toString().substring(0, 16),
                      "category": selectedCategory,
                      "amount": amount
                    };
                    expenses.insert(0, exp);
                    if (!adShownForExpense) {
                      adShownForExpense = true;
                      _showAdDialog();
                    }
                  }
                  _savePrefs();
                  setState(() {});
                },
                child:
                const Text("Save", style: TextStyle(color: Colors.black)))
          ],
        ));
  }

  void _showAdDialog() =>
      showDialog(context: context, barrierDismissible: false, builder: (_) => const AdDialog());

  Future<void> _resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      balance = 0;
      expenses.clear();
      currency = "\$";
    });
  }

  // Drawer Pages ------------------------------------------------------
  void _openAbout() {
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF2C2C2C),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
        builder: (_) => Padding(
            padding: const EdgeInsets.all(24),
            child: SafeArea(
                top: false,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const AppLogo(size: 100),
                  const SizedBox(height: 10),
                  const Text("BudgetZen",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text("Version 1.2.0",
                      style: TextStyle(color: Colors.white54)),
                  const SizedBox(height: 14),
                  const Text(
                    " BudgetZen helps you track expenses, stay mindful of your spending, and bring balance to your finances. Minimalist budget tracking made peaceful.\nBuilt with ❤️ and Flutter.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E676)),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.black),
                      label: const Text("Close",
                          style: TextStyle(color: Colors.black)))
                ]))));
  }

  void _chooseCurrency() async {
    final result = await showCurrencyPicker(context, currency);
    if (result != null) {
      setState(() => currency = result["symbol"]!);
      _savePrefs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF212121),
        appBar: AppBar(
          backgroundColor: const Color(0xFF00E676),
          title: Row(
            children: const [
              AppLogo(size: 40),
              SizedBox(width: 10),
              // Text(
              //   "BudgetZen",
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: _chooseCurrency,
                icon: const Icon(Icons.currency_exchange)),
          ],
        ),

        drawer: Drawer(
            backgroundColor: const Color(0xFF2C2C2C),
            child: SafeArea(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                        decoration:
                        const BoxDecoration(color: Color(0xFF00E676)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            AppLogo(size: 60),
                            SizedBox(height: 10),
                            Text("BudgetZen",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))
                          ],
                        )),
                    ListTile(
                        leading: const Icon(Icons.info, color: Colors.white70),
                        title: const Text("About Zen",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                          _openAbout();
                        }),
                    ListTile(
                        leading: const Icon(Icons.refresh, color: Colors.white70),
                        title: const Text("Clear All",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                          _resetAll();
                        }),
                  ],
                ))),
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Current Balance",
                                    style: TextStyle(color: Colors.white70)),
                                const SizedBox(height: 6),
                                Text("$currency${balance.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: Color(0xFF00E676),
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold))
                              ]))),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00E676)),
                            onPressed: () => _addTransaction("income"),
                            icon: const Icon(Icons.add_circle,
                                color: Colors.black),
                            label: const Text("Add Income",
                                style: TextStyle(color: Colors.black,
                                    fontSize: 12)))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF4081)),
                            onPressed: () => _addTransaction("expense"),
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.black),
                            label: const Text("Add Expense",
                                style: TextStyle(color: Colors.black,
                                fontSize: 12))))
                  ]),
                  const SizedBox(height: 30),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Recent Expenses",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold))),
                  ListView.builder(
                      itemCount: expenses.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        final e = expenses[i];
                        final cat = categories.firstWhere(
                                (c) => c["name"] == e["category"],
                            orElse: () => categories.last);
                        return ListTile(
                            leading: Icon(cat["icon"] as IconData,
                                color: cat["color"] as Color),
                            title: Text("${e["category"]}",
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text("${e["date"]}",
                                style:
                                const TextStyle(color: Colors.white54)),
                            trailing: Text(
                                "-$currency${e["amount"].toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: cat["color"] as Color,
                                    fontWeight: FontWeight.bold)));
                      }),
                  const SizedBox(height: 14),
                  MonthlySummary(
                      expenses: expenses, currency: currency)
                ]))));
  }
}