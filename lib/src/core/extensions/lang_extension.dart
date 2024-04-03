import 'package:flutter/material.dart';
import 'package:m7_livelyness_detection/generated/l10n.dart';
import 'package:m7_livelyness_detection/index.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const supportedLocales = [
  Locale('en'),
  Locale('es'),
  Locale('pt'),
];
const localizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  LangLivelyness.delegate,
];
