import 'package:budget_tracker/Screens/login_screen.dart';
import 'package:budget_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/utils/appvalidator.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _showPassword = ValueNotifier<bool>(true);
 final AuthService _authService = AuthService(); 
final Appvalidator _appValidator = Appvalidator();  
  bool _isLoading = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _showPassword.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    var data = {
      "username": _userNameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _phoneController.text.trim(),
      "password": _passwordController.text,
      'remainingAmount': 0,
      'totalCredit': 0,
      'totalDebit': 0,
    };

    await _authService.createUser(data, context);

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ListView(
        physics: BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 80.0),
          Center(
            child: Text(
              'Create New \nAccount',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 40),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                    _userNameController, 'Username', Icons.person, _appValidator.validateUsername),
                SizedBox(height: 16),
                _buildTextField(
                    _emailController, 'Email', Icons.email, _appValidator.validateEmail),
                SizedBox(height: 16),
                _buildTextField(
                    _phoneController, 'Phone Number', Icons.call, _appValidator.validatePhoneNumber),
                SizedBox(height: 16),
                _buildPasswordField(),
                SizedBox(height: 40.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator(color: Colors.white))
                        : Text(
                            'Create',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                ),
                SizedBox(height: 30.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      String? Function(String?) validator) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(color: Colors.black),
      decoration: _buildInputDecoration(label, icon),
      validator: validator,
    );
  }

  Widget _buildPasswordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showPassword,
      builder: (context, showPassword, child) {
        return TextFormField(
          obscureText: showPassword,
          controller: _passwordController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: "Password",
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.shade900)),
            labelStyle: TextStyle(color: Colors.blue.shade900),
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => _showPassword.value = !showPassword,
              color: Colors.blue.shade800,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          ),
          validator: _appValidator.validatePassword,
        );
      },
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.shade900)),
      labelStyle: TextStyle(color: Colors.blue.shade900),
      filled: true,
      suffixIcon: Icon(suffixIcon, color: Colors.blue.shade800),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
    );
  }
}
