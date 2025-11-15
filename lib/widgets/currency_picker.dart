import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../widgets/app_localizations.dart';

/// Convert ISO country code (e.g., "US") → 🇺🇸 emoji flag
String flagFor(String countryCode) {
  final base = 0x1F1E6; // Unicode for regional indicator 'A'
  return countryCode.toUpperCase().runes
      .map((r) => String.fromCharCode(base + (r - 0x41)))
      .join();
}

Future<Map<String, String>?> showCurrencyPicker(
    BuildContext context,
    String currentSymbol,
    ) async {
  final theme = Theme.of(context);
  final loc = AppLocalizations.of(context);
  final allCurrencies = CurrencyService().getAllCurrencies();

  // Local state for search
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filtered = List.from(allCurrencies);

  return showDialog<Map<String, String>>(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          void updateSearch(String query) {
            query = query.toLowerCase();

            setState(() {
              filtered = allCurrencies.where((c) {
                final name = c["name"]!.toLowerCase();
                final country = c["country"]!.toLowerCase();
                final symbol = c["symbol"]!.toLowerCase();

                return name.contains(query) ||
                    country.contains(query) ||
                    symbol.contains(query);
              }).toList();
            });
          }

          return AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.selectCurrency,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // 🔎 SEARCH FIELD
                TextField(
                  controller: searchController,
                  onChanged: updateSearch,
                  style: const TextStyle(
                      fontSize: 11
                  ),
                  decoration: InputDecoration(
                    hintText: loc.searchByCountry,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: theme.colorScheme.surface.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final c = filtered[i];
                  final isSelected = c["symbol"] == currentSymbol;

                  final flag = flagFor(c["country"]!);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        "$flag  ${c["symbol"]}  ${c["name"]}",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, c),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    },
  );
}