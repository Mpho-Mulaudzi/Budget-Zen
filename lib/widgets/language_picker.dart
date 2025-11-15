import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../language_provider.dart';
import 'app_localizations.dart';

Future<void> showLanguagePicker(BuildContext context) async {
  final theme = Theme.of(context);
  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
  final localizations = AppLocalizations.of(context);

  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          localizations.selectLanguage,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: LanguageProvider.supportedLanguages.length,
            itemBuilder: (_, i) {
              final lang = LanguageProvider.supportedLanguages[i];
              final isSelected = languageProvider.locale.languageCode == lang['code'];

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
                  leading: Text(
                    lang['flag']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(
                    lang['name']!,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                      : null,
                  onTap: () {
                    languageProvider.setLanguage(lang['code']!);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
      );
    },
  );
}