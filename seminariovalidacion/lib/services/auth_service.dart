import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBDX63ybYKNxysLKcNRgOOitx9-HnqGL6c';
  final storage = new FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    print(authData);

    final url = Uri.https(
      _baseUrl,
      '/v1/accounts:signUp',
      {'key': _firebaseToken},
    );

    print(url);

    final resp = await http.post(url, body: json.encode(authData));

    if (resp.statusCode == 200) {
      final Map<String, dynamic> decodedResp = json.decode(resp.body);
      // Handle the decoded response
    } else {
      print('Error: ${resp.statusCode}');
      print('Response body: ${resp.body}');
      // Handle error scenarios
    }

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> logUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    print(authData);

    final url = Uri.https(
      _baseUrl,
      '/v1/accounts:signInWithPassword',
      {'key': _firebaseToken},
    );

    print(url);

    final resp = await http.post(url, body: json.encode(authData));

    if (resp.statusCode == 200) {
      final Map<String, dynamic> decodedResp = json.decode(resp.body);
      // Handle the decoded response
    } else {
      print('Error: ${resp.statusCode}');
      print('Response body: ${resp.body}');
      // Handle error scenarios
    }

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
