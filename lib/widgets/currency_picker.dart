import 'package:flutter/material.dart';
import '../services/currency_service.dart';

Future<Map<String, String>?> showCurrencyPicker(
    BuildContext context, String currentSymbol) async {
  final service = CurrencyService();
  final currencies = service.getAllCurrencies();
  return showDialog<Map<String, String>>(
      context: context,
      builder: (_) {
        Map<String, String> current = {
          "symbol": currentSymbol,
          "name": service.findBySymbol(currentSymbol)?["name"] ??
              currencies[0]["name"]!
        };
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title:
          const Text("Select Currency", style: TextStyle(color: Colors.white)),
          content: StatefulBuilder(builder: (context, setDialog) {
            return SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (_, i) {
                  final c = currencies[i];
                  final selected = current["symbol"] == c["symbol"];
                  return ListTile(
                      leading: Text(c["symbol"]!,
                          style: const TextStyle(
                              fontSize: 22, color: Colors.white)),
                      title: Text(c["name"]!,
                          style: const TextStyle(color: Colors.white70)),
                      trailing: selected
                          ? const Icon(Icons.check, color: Color(0xFF00E676))
                          : null,
                      onTap: () => setDialog(() => current = c));
                },
              ),
            );
          }),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.white))),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676)),
                onPressed: () => Navigator.pop(context, current),
                child:
                const Text("Save", style: TextStyle(color: Colors.black))),
          ],
        );
      });
}