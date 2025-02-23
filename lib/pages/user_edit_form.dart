import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vets_uo308831_flutter_app/src/user.dart';

class UserEditForm extends StatefulWidget {
  final User user;
  const UserEditForm({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => StateUserEditForm();
}

class StateUserEditForm extends State<UserEditForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    User user = widget.user;
    nameController.text = user.name;
    surnameController.text = user.surname;
    emailController.text = user.email;
    phoneController.text = user.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modificar datos usuario")),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Introduce tu nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor digite el nombre';
                }
                return null;
              },
              onSaved: (value) => nameController.text = value ?? '',
            ),
            TextFormField(
              controller: surnameController,
              decoration: const InputDecoration(
                labelText: 'Apellidos',
                hintText: 'Introduce tus apellidos',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor digite los apellidos';
                }
                return null;
              },
              onSaved: (value) => surnameController.text = value ?? '',
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Introduce tu email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor digite el email';
                }
                // Validación del formato del email
                String emailPattern =
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                RegExp regex = RegExp(emailPattern);
                if (!regex.hasMatch(value)) {
                  return 'Por favor ingrese un email válido';
                }
                return null;
              },
              onSaved: (value) => emailController.text = value ?? '',
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                hintText: 'Introduce tu teléfono',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(14), // Limita a 14 caracteres
                _PhoneInputFormatter(), // Aplica el formato
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor digite el teléfono';
                }
                // Validación del formato de teléfono
                String phonePattern = r'^\d{3}-\d{3}-\d{3}-\d{3}$';
                RegExp regex = RegExp(phonePattern);
                if (!regex.hasMatch(value)) {
                  return 'Por favor ingrese un teléfono válido (999-999-999-999)';
                }
                return null;
              },
              onSaved: (value) => phoneController.text = value ?? '',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    _formKey.currentState!.save();
                    User user = User(
                      nameController.text,
                      surnameController.text,
                      emailController.text,
                      phoneController.text,
                    );
                    Navigator.pop(context, user);
                  }
                },
                child: const Text('Guardar cambios'),
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
