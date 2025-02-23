import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../src/user.dart';

class UserSignUpForm extends StatefulWidget {
  const UserSignUpForm({super.key});

  @override
  UserSignUpFormState createState() => UserSignUpFormState();
}

class UserSignUpFormState extends State<UserSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _surname = "";
  String _email = "";
  String _phone = "";

  // Expresión regular para validar el correo electrónico
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Expresión regular para validar el teléfono (formato: 999-999-999-999)
  final RegExp _phoneRegex = RegExp(r'^\d{3}-\d{3}-\d{3}-\d{3}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de usuarios")),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Introduce tu nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor digite el nombre';
                }
                if (value.length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                if (value.length > 50) {
                  return 'El nombre no debe exceder los 50 caracteres';
                }
                return null;
              },
              onSaved: (value) => _name = value ?? '',
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Apellidos',
                hintText: 'Introduce tus apellidos',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor digite los apellidos';
                }
                if (value.length < 3) {
                  return 'Los apellidos deben tener al menos 3 caracteres';
                }
                if (value.length > 100) {
                  return 'Los apellidos no deben exceder los 100 caracteres';
                }
                return null;
              },
              onSaved: (value) => _surname = value ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Introduce tu email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor digite el email';
                }
                if (!_emailRegex.hasMatch(value)) {
                  return 'Por favor introduce un email válido (ej. email@email.com)';
                }
                return null;
              },
              onSaved: (value) => _email = value ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                hintText: 'Introduce tu teléfono',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Permite solo dígitos
                LengthLimitingTextInputFormatter(14), // Limita a 14 caracteres
                _PhoneInputFormatter(), // Añade guiones automáticamente
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor digite el teléfono';
                }
                if (!_phoneRegex.hasMatch(value)) {
                  return 'Por favor introduce un teléfono válido (ej. 999-999-999-999)';
                }
                return null;
              },
              onSaved: (value) => _phone = value ?? '',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    User user = User(_name, _surname, _email, _phone);
                    Navigator.pop(context, user);
                  }
                },
                child: const Text('Registrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Formateador personalizado para el teléfono
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Si el valor es vacío o si no contiene números, retornamos el valor original
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Eliminar todo lo que no sean números
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Añadir los guiones en los lugares correspondientes
    if (newText.length >= 10) {
      newText = newText.replaceRange(3, 3, '-');
      newText = newText.replaceRange(7, 7, '-');
      newText = newText.replaceRange(11, 11, '-');
    } else if (newText.length >= 7) {
      newText = newText.replaceRange(3, 3, '-');
      newText = newText.replaceRange(7, 7, '-');
    } else if (newText.length >= 3) {
      newText = newText.replaceRange(3, 3, '-');
    }

    // Devolver el nuevo valor con los guiones
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
