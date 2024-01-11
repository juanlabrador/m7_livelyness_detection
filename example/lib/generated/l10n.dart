// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class LangLivelyness {
  LangLivelyness();

  static LangLivelyness? _current;

  static LangLivelyness get current {
    assert(_current != null,
        'No instance of LangLivelyness was loaded. Try to initialize the LangLivelyness delegate before accessing LangLivelyness.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<LangLivelyness> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = LangLivelyness();
      LangLivelyness._current = instance;

      return instance;
    });
  }

  static LangLivelyness of(BuildContext context) {
    final instance = LangLivelyness.maybeOf(context);
    assert(instance != null,
        'No instance of LangLivelyness present in the widget tree. Did you add LangLivelyness.delegate in localizationsDelegates?');
    return instance!;
  }

  static LangLivelyness? maybeOf(BuildContext context) {
    return Localizations.of<LangLivelyness>(context, LangLivelyness);
  }

  /// `Sonríe`
  String get smile {
    return Intl.message(
      'Sonríe',
      name: 'smile',
      desc: '',
      args: [],
    );
  }

  /// `Pestañea`
  String get blink {
    return Intl.message(
      'Pestañea',
      name: 'blink',
      desc: '',
      args: [],
    );
  }

  /// `Gira la cabeza hacia la izquierda`
  String get turnYourHeadLeft {
    return Intl.message(
      'Gira la cabeza hacia la izquierda',
      name: 'turnYourHeadLeft',
      desc: '',
      args: [],
    );
  }

  /// `Gira la cabeza hacia la derecha`
  String get turnYourHeadRight {
    return Intl.message(
      'Gira la cabeza hacia la derecha',
      name: 'turnYourHeadRight',
      desc: '',
      args: [],
    );
  }

  /// `Toma una`
  String get takeSelfie1 {
    return Intl.message(
      'Toma una',
      name: 'takeSelfie1',
      desc: '',
      args: [],
    );
  }

  /// `selfie`
  String get takeSelfie2 {
    return Intl.message(
      'selfie',
      name: 'takeSelfie2',
      desc: '',
      args: [],
    );
  }

  /// `de tu rostro`
  String get takeSelfie3 {
    return Intl.message(
      'de tu rostro',
      name: 'takeSelfie3',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<LangLivelyness> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<LangLivelyness> load(Locale locale) => LangLivelyness.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
