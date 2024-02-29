import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:votaciones_app/pages/home_page.dart';
import 'package:votaciones_app/pages/stream_page_marcial.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: StreamPageMarcial(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
