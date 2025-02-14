import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class TranslationService extends Translations {
  // Locales prises en charge
  static const locale = Locale('en', 'US');
  static const fallbackLocale = Locale('en', 'US');
  late Box<String> _box;
  static const String _boxName = 'Language';

  // Variable observable pour suivre la langue sélectionnée
  RxString selectedLanguage = ''.obs;

  // Liste des langues supportées
  static final langs = ['En', 'Fr', 'Ar'];

  // Liste des locales correspondantes
  static final locales = [
    const Locale('en', 'US'),
    const Locale('fr', 'FR'),
    const Locale('ar', 'SA'),
  ];

  /// Initialise Hive et ouvre la boîte
  Future<void> _initHive() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<String>(_boxName);
    } else {
      _box = Hive.box<String>(_boxName);
    }
  }

  /// Méthode pour configurer la langue initiale
  Future<void> setInitialLocale() async {
    await _initHive();
    final savedLang = _box.get('selectedLanguage');

    if (savedLang != null) {
      // Si une langue est sauvegardée, l'utiliser
      selectedLanguage.value = savedLang;
      final locale = _getLocaleFromLanguage(savedLang);
      Get.updateLocale(locale);
    } else {
      // Sinon, détecter la langue de l'appareil
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale != null) {
        final locale = _getLocaleFromDeviceLocale(deviceLocale);
        Get.updateLocale(locale);
        _saveLocale(locale.languageCode);
        selectedLanguage.value = locale.languageCode;
      } else {
        // Utiliser la locale par défaut si aucune détection possible
        Get.updateLocale(fallbackLocale);
        selectedLanguage.value = fallbackLocale.languageCode;
      }
    }
  }

  /// Détection de la locale en fonction de la langue de l'appareil
  Locale _getLocaleFromDeviceLocale(Locale deviceLocale) {
    for (int i = 0; i < locales.length; i++) {
      if (deviceLocale.languageCode == locales[i].languageCode) {
        return locales[i];
      }
    }
    return fallbackLocale;
  }

  /// Change la langue manuellement et sauvegarde dans Hive
  Future<void> changeLocale(String lang) async {
    await _initHive();
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
    await _saveLocale(lang);
    selectedLanguage.value = lang;
    printInfo(info: "Langue sauvegardée : ${_box.get('selectedLanguage')}");
  }

  /// Sauvegarde la langue sélectionnée dans Hive
  Future<void> _saveLocale(String lang) async {
    await _box.put('selectedLanguage', lang);
  }

  /// Récupère la locale en fonction de la langue
  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale ?? fallbackLocale;
  }

  /// Traductions
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'appTitle': 'Iqra Maai',
          'welcomeMessage': 'Welcome to Iqra Maai App!',
        },
        'fr_FR': {
          'appTitle': 'Iqra Maai',
          'welcomeMessage': "Bienvenue dans l'application Iqra Maai!",
        },
        'ar_SA': {
          'appTitle': 'مشروع Iqra Maai',
          'welcomeMessage': 'مرحبًا بكم في مشروع Iqra Maai!',
        },
      };
}
