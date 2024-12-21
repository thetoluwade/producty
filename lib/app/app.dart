import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../screens/todo/todo_list_screen.dart';

class ProductyApp extends StatelessWidget {
  const ProductyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Producty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const TodoListScreen(),
    );
  }
}
