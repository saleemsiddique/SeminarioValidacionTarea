import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminariovalidacion/providers/register_form_provider.dart';
import 'package:seminariovalidacion/services/auth_service.dart';
import 'package:seminariovalidacion/services/notification_service.dart';
import 'package:seminariovalidacion/ui/input_decorations.dart';
import 'package:seminariovalidacion/widgets/widgets.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Registro',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => RegisterFormProvider(),
                      child: RegisterForm(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              IniciarCuenta(),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'John',
                labelText: 'Nombre',
                prefixIcon: Icons.person,
              ),
              onChanged: (value) {
                registerForm.nombres = value;
              },
            ),
            TextFormField(
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Doe',
                labelText: 'Apellidos',
                prefixIcon: Icons.person,
              ),
              onChanged: (value) {
                registerForm.apellidos = value;
              },
            ),
            TextFormField(
                validator: (value) {
                  if (value == null || value.length < 9) {
                    return 'El numero debe contener 9 numeros';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Teléfono',
                  labelText: 'Teléfono',
                  prefixIcon: Icons.phone,
                ),
                onChanged: (value) {
                  // Asignar el valor del teléfono al provider
                  // registerForm.telefono = value;
                }),
            TextFormField(
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Introduce un email valido';
              },
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Correo electrónico',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.email,
              ),
              onChanged: (value) {
                registerForm.email = value;
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                'Fecha nacimiento',
                style: TextStyle(fontSize: 16),
              ),
              trailing: Text(
                // Aquí muestra la fecha seleccionada o un mensaje predeterminado si no se ha seleccionado aún
                registerForm.fechaNacimiento != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(registerForm.fechaNacimiento!)
                    : '',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                // Abre el DatePicker y actualiza la fecha seleccionada
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  registerForm.fechaNacimiento = pickedDate;
                }
              },
            ),
            DropdownButton<String>(
              value: registerForm.sexo,
              items: ['Masculino', 'Femenino', 'Otro', 'Selecciona sexo']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  registerForm.sexo = newValue;
                }
              },
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'La contraseña debe contener al menos 6 caracteres';
                }
                return null;
              },
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              obscureText: true, // Oculta el texto de la contraseña
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Contraseña',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock,
              ),
              onChanged: (value) {
                registerForm.password = value;
              },
            ),
            SizedBox(height: 30),
            RegisterBtn(),
          ],
        ),
      ),
    );
  }
}

class RegisterBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    final authService = Provider.of<AuthService>(context);
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.deepPurple,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        child: Text(
          registerForm.isLoading ? 'Espere' : 'Registrarse',
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: registerForm.isLoading
          ? null
          : () async {
              FocusScope.of(context).unfocus();
              if (!registerForm.isValidForm()) return;

              registerForm.isLoading = true;

              final String? errorMessage = await authService.createUser(
                  registerForm.email, registerForm.password);

              if (errorMessage == null) {
                Navigator.pushReplacementNamed(context, 'home');
              } else {
                NotificationService.showSnackbar(errorMessage);
                registerForm.isLoading = false;
              }
            },
    );
  }
}

class IniciarCuenta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, '/'),
      style: ButtonStyle(
        overlayColor:
            MaterialStatePropertyAll<Color>(Colors.indigo.withOpacity(0.2)),
        shape: MaterialStatePropertyAll<OutlinedBorder>(
          StadiumBorder(),
        ),
      ),
      child: const Text(
        'Ya tienes cuenta?',
        style: TextStyle(fontSize: 18, color: Colors.black87),
      ),
    );
  }
}
