import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'services/snack_bar_service.dart';
import 'view/home_page.dart';

void main() {
  initializeDateFormatting('ru', null).then(
    (_) => runApp(const MyApp()),
  ); //русификация даты
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: SnackBarService.scaffoldKey,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
