import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import '../widgets/brand_header.dart';
import 'scan.dart';

const _demoPassword = 'pass123';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _plateController = TextEditingController();

  bool _isNewUser = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_phoneController.text.trim().length < 10) {
      setState(() => _error = 'Enter a valid 10-digit phone number');
      return;
    }
    if (_isNewUser && _plateController.text.trim().isEmpty) {
      setState(() => _error = 'Enter your vehicle number plate');
      return;
    }
    if (_passwordController.text != _demoPassword) {
      setState(() => _error = 'Incorrect password, try pass123 for this demo');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).push(slideRoute(const QrScanScreen()));
  }

  void _selectMode(bool isNewUser) {
    setState(() {
      _isNewUser = isNewUser;
      _error = null;
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
              Text(
                'Phone number',
                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
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
              if (_isNewUser) ...[
                const SizedBox(height: 16),
                Text(
                  'Vehicle number plate',
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMuted),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _plateController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'MH 04 AB 1234',
                    prefixIcon: Icon(Icons.directions_car_filled_rounded),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Demo password is pass123',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
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
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
