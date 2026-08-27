import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import '../widgets/brand_header.dart';
import 'scan.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Existing user fields
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  // New user extra fields
  final _nameController    = TextEditingController();
  final _phoneController   = TextEditingController();
  final _plateController   = TextEditingController();

  bool _isNewUser = false;
  bool _loading   = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = 'Enter a valid email address');
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = 'Enter your password');
      return;
    }
    if (_isNewUser) {
      if (_nameController.text.trim().isEmpty) {
        setState(() => _error = 'Enter your name');
        return;
      }
      if (_phoneController.text.trim().length < 10) {
        setState(() => _error = 'Enter a valid 10-digit phone number');
        return;
      }
      if (_plateController.text.trim().isEmpty) {
        setState(() => _error = 'Enter your vehicle number plate');
        return;
      }
    }

    setState(() {
      _loading = true;
      _error   = null;
    });

    try {
      if (_isNewUser) {
        await CustomerApiService.register(
          name:         _nameController.text.trim(),
          email:        email,
          phone:        _phoneController.text.trim(),
          password:     password,
          licensePlate: _plateController.text.trim().toUpperCase(),
          vehicleType:  'Car',
        );
      }
      // Login (for new users, login right after register)
      await CustomerApiService.login(email, password);

      if (!mounted) return;
      Navigator.of(context).push(slideRoute(const QrScanScreen()));
    } on ApiException catch (e) {
      if (!mounted) return;
      // Map backend error codes to friendly messages
      String msg = e.message;
      if (msg.contains('INVALID_CREDENTIALS') || msg.contains('Invalid email or password')) {
        msg = _isNewUser
            ? 'Registration succeeded but login failed. Please try logging in.'
            : 'Incorrect password. Please try again.';
      } else if (msg.contains('EMAIL_ALREADY_EXISTS')) {
        msg = 'An account with this email already exists. Please log in instead.';
      } else if (msg.contains('USER_NOT_FOUND') || msg.contains('No account')) {
        msg = 'No account found with this email. Please register first.';
      } else if (msg.contains('SocketException') || msg.contains('Connection refused')) {
        msg = 'Cannot connect to server. Make sure the backend is running.';
      }
      setState(() => _error = msg);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Cannot connect to server. Check your connection.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _selectMode(bool isNewUser) {
    setState(() {
      _isNewUser = isNewUser;
      _error     = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandHeader(
                title: 'Welcome',
                subtitle: 'Log in to reserve and access your parking slot',
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: _ModeButton(label: 'Existing User', selected: !_isNewUser, onTap: () => _selectMode(false))),
                  const SizedBox(width: 12),
                  Expanded(child: _ModeButton(label: 'New User', selected: _isNewUser, onTap: () => _selectMode(true))),
                ],
              ),
              const SizedBox(height: 28),

              // ── New user extras ──────────────────────────────
              if (_isNewUser) ...[
                _label('Full name'),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Aditya Kumar',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                _label('Phone number'),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    hintText: '98765 43210',
                    prefixIcon: Icon(Icons.phone_android_rounded),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 16),
                _label('Vehicle number plate'),
                const SizedBox(height: 8),
                TextField(
                  controller: _plateController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'MH 04 AB 1234',
                    prefixIcon: Icon(Icons.directions_car_filled_rounded),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Email ─────────────────────────────────────────
              _label('Email address'),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // ── Password ──────────────────────────────────────
              _label('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),

              if (!_isNewUser) ...[
                const SizedBox(height: 4),
                Text(
                  'Use the email & password you registered with',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],

              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                        )
                      : Text(_isNewUser ? 'Create Account & Continue' : 'Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
  );
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
