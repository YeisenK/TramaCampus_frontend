import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/database/database_service.dart';
import '../../core/database/schema.dart';

/// Result of a register / login attempt. Either a successful account
/// reference or a human-readable error.
class AuthResult {
  const AuthResult.ok(this.email) : error = null;
  const AuthResult.fail(this.error) : email = null;

  final String? email;
  final String? error;

  bool get isOk => error == null && email != null;
}

/// Demo-grade authentication: SHA-256(password + per-account salt)
/// stored in SQLite. Single-source of truth for "who is logged in" so
/// the rest of the app can read `current` synchronously after
/// `AuthRepository.instance.load()` ran during boot.
///
/// NOT production. Replace with the user-service when it lands.
class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  static const _kCurrentEmailMetaKey = 'auth.current_email';

  String? _currentEmail;
  String? get currentEmail => _currentEmail;
  bool get isAuthenticated => _currentEmail != null;

  /// Warm the cache from the `meta` table during boot.
  Future<void> load() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query(
      Tables.meta,
      where: '${MetaColumns.key} = ?',
      whereArgs: [_kCurrentEmailMetaKey],
      limit: 1,
    );
    if (rows.isNotEmpty) {
      _currentEmail = rows.first[MetaColumns.value] as String;
    }
  }

  /// Create a new account. Fails if the email already exists or the
  /// password is too short. On success the new account becomes the
  /// current session.
  Future<AuthResult> register({
    required String email,
    required String password,
  }) async {
    final emailLc = email.trim().toLowerCase();
    final emailError = _validateEmail(emailLc);
    if (emailError != null) return AuthResult.fail(emailError);
    final pwdError = _validatePassword(password);
    if (pwdError != null) return AuthResult.fail(pwdError);

    final db = await DatabaseService.instance.database;
    final existing = await db.query(
      Tables.accounts,
      where: '${AccountColumns.email} = ?',
      whereArgs: [emailLc],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      return const AuthResult.fail('Ya existe una cuenta con ese correo');
    }

    final salt = _generateSalt();
    final hash = _hash(password, salt);
    await db.insert(Tables.accounts, {
      AccountColumns.email: emailLc,
      AccountColumns.passwordHash: hash,
      AccountColumns.salt: salt,
      AccountColumns.createdAt: DateTime.now().toIso8601String(),
    });
    await _setCurrentEmail(emailLc);
    return AuthResult.ok(emailLc);
  }

  /// Verify password and establish the session on success.
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final emailLc = email.trim().toLowerCase();
    if (emailLc.isEmpty || password.isEmpty) {
      return const AuthResult.fail('Completá ambos campos');
    }

    final db = await DatabaseService.instance.database;
    final rows = await db.query(
      Tables.accounts,
      where: '${AccountColumns.email} = ?',
      whereArgs: [emailLc],
      limit: 1,
    );
    if (rows.isEmpty) {
      return const AuthResult.fail('No existe una cuenta con ese correo');
    }
    final row = rows.first;
    final salt = row[AccountColumns.salt] as String;
    final expected = row[AccountColumns.passwordHash] as String;
    if (_hash(password, salt) != expected) {
      return const AuthResult.fail('Contraseña incorrecta');
    }
    await _setCurrentEmail(emailLc);
    return AuthResult.ok(emailLc);
  }

  Future<void> logout() async {
    final db = await DatabaseService.instance.database;
    await db.delete(
      Tables.meta,
      where: '${MetaColumns.key} = ?',
      whereArgs: [_kCurrentEmailMetaKey],
    );
    _currentEmail = null;
  }

  Future<void> _setCurrentEmail(String email) async {
    _currentEmail = email;
    final db = await DatabaseService.instance.database;
    await db.insert(
      Tables.meta,
      {MetaColumns.key: _kCurrentEmailMetaKey, MetaColumns.value: email},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Ingresá un correo';
    final ok = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[\w\.\-]+$').hasMatch(email);
    if (!ok) return 'Correo inválido';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
    return null;
  }

  String _generateSalt() {
    final r = Random.secure();
    final bytes = List<int>.generate(16, (_) => r.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _hash(String password, String salt) {
    final bytes = utf8.encode('$salt:$password');
    return sha256.convert(bytes).toString();
  }
}
