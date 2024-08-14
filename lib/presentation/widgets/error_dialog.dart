import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String mensaje, String textoBoton, bool exito, Function() onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: onPressed,
              child: Text(
                textoBoton,
                style: const TextStyle(
                  color: Color.fromARGB(255, 12, 68, 114),
                ),
              ),
            ),
          ],
        );
      },
    );
  }