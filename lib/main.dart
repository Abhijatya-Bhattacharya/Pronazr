import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// MAKE SURE THESE TWO LINES ARE CORRECT
import 'package:proanzr/screens/chat_screen.dart';
import 'package:proanzr/utils/theme.dart';

void main() {
  // Reduce accessibility update frequency to prevent errors
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proanzr',
      theme: neobrutalistTheme, // Neobrutalism black & white theme
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
