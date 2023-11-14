import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  String _nombres = '';
  String _apellidos = '';
  String _email = '';
  String _password = '';
  DateTime? _fechaNacimiento; // Variable para la fecha de nacimiento
  String _sexo = 'Selecciona sexo'; // Variable para el sexo

  bool _isLoading = false;

  String get nombres => _nombres;
  String get apellidos => _apellidos;
  String get email => _email;
  String get password => _password;
  DateTime? get fechaNacimiento => _fechaNacimiento; // Getter para la fecha de nacimiento
  String get sexo => _sexo; // Getter para el sexo

  bool get isLoading => _isLoading;

  set nombres(String value) {
    _nombres = value;
    notifyListeners();
  }

  set apellidos(String value) {
    _apellidos = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set fechaNacimiento(DateTime? value) { // Setter para la fecha de nacimiento
    _fechaNacimiento = value;
    notifyListeners();
  }

  set sexo(String value) { // Setter para el sexo
    _sexo = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Método para validar el formulario
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
