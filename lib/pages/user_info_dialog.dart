import 'package:flutter/material.dart';
import '../src/user.dart';

class UserInfoDialog {
  static void show(BuildContext context, User user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Detalles de ${user.name}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nombre: ${user.name} ${user.surname}"),
                Text("Email: ${user.email}"),
                Text("Teléfono: ${user.phone}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cerrar"),
              ),
            ],
          ),
    );
  }
}
