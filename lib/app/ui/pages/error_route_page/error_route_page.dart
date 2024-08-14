import 'package:flutter/material.dart';

class ErrorRoutePage extends StatelessWidget {
  const ErrorRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Hatalı yönlendirilmiş sayfa."),
      ),
    );
  }
}
