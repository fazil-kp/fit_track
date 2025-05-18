import 'package:fit_track/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class NoRouteScreen extends StatelessWidget {
  const NoRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.red, Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 100, color: Colors.red),
                const SizedBox(height: 20),
                const Text("Oops! Something went wrong.", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                const Text("This page does not exist.", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 30),
                ElevatedButton(onPressed: () => context.go("/"), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), textStyle: const TextStyle(fontSize: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))), child: const Text("Back to Home")),
              ],
            ),
          ),
        ).center(),
      ),
    );
  }
}
