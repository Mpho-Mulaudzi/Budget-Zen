import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'BudgetZen',
      'current_balance': 'Current Balance',
      'add_income': 'Add Income',
      'add_expense': 'Add Expense',
      'monthly_summary': 'Monthly Summary',
      'recent_expenses': 'Recent Expenses',
      'about': 'About',
      'privacy_policy': 'Privacy Policy',
      'clear_all_data': 'Clear All Data',
      'amount': 'Amount',
      'category': 'Category',
      'cancel': 'Cancel',
      'save': 'Save',
      'insufficient_balance': 'Insufficient balance for this expense!',
      'select_language': 'Select Language',
      'rent': 'Rent',
      'transport': 'Transport',
      'groceries': 'Groceries',
      'food': 'Food',
      'health': 'Health',
      'entertainment': 'Entertainment',
      'utilities': 'Utilities',
      'other': 'Other',
      'select_currency': 'Select Currency',
      'search_by_country': 'Search by country...',
      'about_budgetzen': 'About BudgetZen',
      'version': 'Version 1.2.0',
      'about_description': 'BudgetZen helps you track expenses and maintain financial mindfulness. Built with Flutter, integrating Huawei Ads to support development.',
      'privacy_policy_title': 'Privacy Policy',
      'privacy_policy_content': 'Your privacy is important to us. BudgetZen collects certain non-personal information, including device identifiers and usage patterns, only to enhance your experience and serve relevant ads through Huawei Ads. By using this app, you agree to this policy. No data is sold or shared with unauthorized parties.',
    },
    'zh': {
      'app_name': '预算禅',
      'current_balance': '当前余额',
      'add_income': '添加收入',
      'add_expense': '添加支出',
      'monthly_summary': '月度总结',
      'recent_expenses': '最近支出',
      'about': '关于',
      'privacy_policy': '隐私政策',
      'clear_all_data': '清除所有数据',
      'amount': '金额',
      'category': '类别',
      'cancel': '取消',
      'save': '保存',
      'insufficient_balance': '余额不足！',
      'select_language': '选择语言',
      'rent': '租金',
      'transport': '交通',
      'groceries': '杂货',
      'food': '食品',
      'health': '健康',
      'entertainment': '娱乐',
      'utilities': '公用事业',
      'other': '其他',
      'select_currency': '选择货币',
      'search_by_country': '按国家搜索...',
      'about_budgetzen': '关于预算禅',
      'version': '版本 1.2.0',
      'about_description': '预算禅帮助您跟踪支出并保持财务正念。使用Flutter构建，集成华为广告以支持开发。',
      'privacy_policy_title': '隐私政策',
      'privacy_policy_content': '您的隐私对我们很重要。预算禅仅收集某些非个人信息，包括设备标识符和使用模式，以增强您的体验并通过华为广告提供相关广告。使用此应用即表示您同意此政策。数据不会出售或与未经授权的方共享。',
    },
    'hi': {
      'app_name': 'बजट ज़ेन',
      'current_balance': 'वर्तमान शेष',
      'add_income': 'आय जोड़ें',
      'add_expense': 'खर्च जोड़ें',
      'monthly_summary': 'मासिक सारांश',
      'recent_expenses': 'हाल के खर्चे',
      'about': 'के बारे में',
      'privacy_policy': 'गोपनीयता नीति',
      'clear_all_data': 'सभी डेटा साफ़ करें',
      'amount': 'राशि',
      'category': 'श्रेणी',
      'cancel': 'रद्द करें',
      'save': 'सहेजें',
      'insufficient_balance': 'इस खर्च के लिए अपर्याप्त शेष!',
      'select_language': 'भाषा चुनें',
      'rent': 'किराया',
      'transport': 'परिवहन',
      'groceries': 'किराना',
      'food': 'भोजन',
      'health': 'स्वास्थ्य',
      'entertainment': 'मनोरंजन',
      'utilities': 'उपयोगिताएँ',
      'other': 'अन्य',
      'select_currency': 'मुद्रा चुनें',
      'search_by_country': 'देश द्वारा खोजें...',
      'about_budgetzen': 'बजट ज़ेन के बारे में',
      'version': 'संस्करण 1.2.0',
      'about_description': 'बजट ज़ेन आपको खर्चों को ट्रैक करने और वित्तीय सचेतनता बनाए रखने में मदद करता है। Flutter के साथ बनाया गया, विकास का समर्थन करने के लिए Huawei Ads को एकीकृत करता है।',
      'privacy_policy_title': 'गोपनीयता नीति',
      'privacy_policy_content': 'आपकी गोपनीयता हमारे लिए महत्वपूर्ण है। बजट ज़ेन केवल आपके अनुभव को बढ़ाने और Huawei Ads के माध्यम से प्रासंगिक विज्ञापन प्रदान करने के लिए डिवाइस पहचानकर्ताओं और उपयोग पैटर्न सहित कुछ गैर-व्यक्तिगत जानकारी एकत्र करता है। इस ऐप का उपयोग करके, आप इस नीति से सहमत हैं। डेटा बेचा नहीं जाता है या अनधिकृत पक्षों के साथ साझा नहीं किया जाता है।',
    },
    'es': {
      'app_name': 'BudgetZen',
      'current_balance': 'Saldo Actual',
      'add_income': 'Agregar Ingreso',
      'add_expense': 'Agregar Gasto',
      'monthly_summary': 'Resumen Mensual',
      'recent_expenses': 'Gastos Recientes',
      'about': 'Acerca de',
      'privacy_policy': 'Política de Privacidad',
      'clear_all_data': 'Borrar Todos los Datos',
      'amount': 'Cantidad',
      'category': 'Categoría',
      'cancel': 'Cancelar',
      'save': 'Guardar',
      'insufficient_balance': '¡Saldo insuficiente para este gasto!',
      'select_language': 'Seleccionar Idioma',
      'rent': 'Alquiler',
      'transport': 'Transporte',
      'groceries': 'Comestibles',
      'food': 'Comida',
      'health': 'Salud',
      'entertainment': 'Entretenimiento',
      'utilities': 'Servicios',
      'other': 'Otro',
      'select_currency': 'Seleccionar Moneda',
      'search_by_country': 'Buscar por país...',
      'about_budgetzen': 'Acerca de BudgetZen',
      'version': 'Versión 1.2.0',
      'about_description': 'BudgetZen le ayuda a rastrear gastos y mantener la atención financiera. Construido con Flutter, integrando Huawei Ads para apoyar el desarrollo.',
      'privacy_policy_title': 'Política de Privacidad',
      'privacy_policy_content': 'Su privacidad es importante para nosotros. BudgetZen recopila cierta información no personal, incluidos identificadores de dispositivos y patrones de uso, solo para mejorar su experiencia y ofrecer anuncios relevantes a través de Huawei Ads. Al usar esta aplicación, acepta esta política. Los datos no se venden ni se comparten con partes no autorizadas.',
    },
    'fr': {
      'app_name': 'BudgetZen',
      'current_balance': 'Solde Actuel',
      'add_income': 'Ajouter un Revenu',
      'add_expense': 'Ajouter une Dépense',
      'monthly_summary': 'Résumé Mensuel',
      'recent_expenses': 'Dépenses Récentes',
      'about': 'À propos',
      'privacy_policy': 'Politique de Confidentialité',
      'clear_all_data': 'Effacer Toutes les Données',
      'amount': 'Montant',
      'category': 'Catégorie',
      'cancel': 'Annuler',
      'save': 'Enregistrer',
      'insufficient_balance': 'Solde insuffisant pour cette dépense!',
      'select_language': 'Sélectionner la Langue',
      'rent': 'Loyer',
      'transport': 'Transport',
      'groceries': 'Épicerie',
      'food': 'Nourriture',
      'health': 'Santé',
      'entertainment': 'Divertissement',
      'utilities': 'Services Publics',
      'other': 'Autre',
      'select_currency': 'Sélectionner la Devise',
      'search_by_country': 'Rechercher par pays...',
      'about_budgetzen': 'À propos de BudgetZen',
      'version': 'Version 1.2.0',
      'about_description': 'BudgetZen vous aide à suivre les dépenses et à maintenir la pleine conscience financière. Construit avec Flutter, intégrant Huawei Ads pour soutenir le développement.',
      'privacy_policy_title': 'Politique de Confidentialité',
      'privacy_policy_content': 'Votre vie privée est importante pour nous. BudgetZen collecte certaines informations non personnelles, y compris les identifiants de l\'appareil et les modèles d\'utilisation, uniquement pour améliorer votre expérience et diffuser des annonces pertinentes via Huawei Ads. En utilisant cette application, vous acceptez cette politique. Les données ne sont pas vendues ni partagées avec des parties non autorisées.',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Convenience getters - ALL DEFINED HERE
  String get appName => translate('app_name');
  String get currentBalance => translate('current_balance');
  String get addIncome => translate('add_income');
  String get addExpense => translate('add_expense');
  String get monthlySummary => translate('monthly_summary');
  String get recentExpenses => translate('recent_expenses');
  String get about => translate('about');
  String get privacyPolicy => translate('privacy_policy');
  String get clearAllData => translate('clear_all_data');
  String get amount => translate('amount');
  String get category => translate('category');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get insufficientBalance => translate('insufficient_balance');
  String get selectLanguage => translate('select_language');
  String get rent => translate('rent');
  String get transport => translate('transport');
  String get groceries => translate('groceries');
  String get food => translate('food');
  String get health => translate('health');
  String get entertainment => translate('entertainment');
  String get utilities => translate('utilities');
  String get other => translate('other');
  String get selectCurrency => translate('select_currency');
  String get searchByCountry => translate('search_by_country');
  String get aboutBudgetzen => translate('about_budgetzen');
  String get version => translate('version');
  String get aboutDescription => translate('about_description');
  String get privacyPolicyTitle => translate('privacy_policy_title');
  String get privacyPolicyContent => translate('privacy_policy_content');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh', 'hi', 'es', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}