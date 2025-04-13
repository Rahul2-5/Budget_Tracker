import 'package:budget_tracker/Screens/sign_up.dart';
import 'package:budget_tracker/services/auth_service.dart';
import 'package:budget_tracker/utils/appValidator.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final authservice = AuthService();
  final ValueNotifier<bool> _showPassword =
      ValueNotifier<bool>(true); //* lightweight alternative to setstate()
  bool isLoading = false; // for credintial login
  bool googleIsLoading = false; // for google login

  var appvalidator = Appvalidator();

  // Handle Login
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      var data = {
        "email": _emailController.text.trim(), //*
        "password": _passwordController.text,
      };

      await authservice.login(data, context);

      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevents full screen rebuild when keyboard appears
      backgroundColor: Colors.white,
      body: SafeArea(
        // ensures it adapts properly to different screen sizes.
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 60.0),
                      Text(
                        'Login Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildEmailField(),
                            SizedBox(height: 16),
                            _buildPasswordField(),
                            SizedBox(height: 40.0),
                            _buildLoginButton(),
                            SizedBox(height: 30.0),
                            Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                    color:Colors.black  
                                        
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text('Or Login with'),
                                  ),
                                  Expanded(
                                      child: Divider(
                                  color:Colors.black
                                  ))
                                ],
                              ),
                              SizedBox(
                               // height: mq.height * 0.008,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    splashColor:
                                     Colors.white,
                                    onTap: (){authservice.loginWithGoogle(context);},
                                    child: Image(
                                        width: 28,
                                        image: AssetImage(
                                          'assets/images/google.jpg',
                                        )),
                                  ),
                                  InkWell(
                                    child: CircleAvatar(
                                        child: Image(
                                            width: 30,
                                            image: AssetImage(
                                              'assets/images/facebook.jpg',
                                            )),
                                        backgroundColor: Colors.transparent),
                                  )
                                ],
                              ),
                            SizedBox(height: 30.0),
                            _buildSignUpButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Email Input Field
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: _buildInputDecoration('Email', Icons.email),
      validator: appvalidator.validateEmail,
    );
  }

  // Password Input Field with Toggle
  Widget _buildPasswordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showPassword,
      builder: (context, showPassword, child) {
        return TextFormField(
          controller: _passwordController,
          obscureText: showPassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: 'Password',
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade900),
            ),
            labelStyle: TextStyle(color: Colors.blue.shade900),
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.blue.shade800,
              ),
              onPressed: () {
                _showPassword.value = !showPassword;
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          validator: appvalidator.validatePassword,
        );
      },
    );
  }

  // Login Button with Loader
  Widget _buildLoginButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: isLoading ? null : _submitForm,
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Login',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
      ),
    );
  }

  // Sign-Up Redirect Button
  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpView()),
        );
      },
      child: Text(
        'Create new account',
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 20,
        ),
      ),
    );
  }

  // Input Decorations
  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade900),
      ),
      labelStyle: TextStyle(color: Colors.blue.shade900),
      filled: true,
      suffixIcon: Icon(suffixIcon, color: Colors.blue.shade800),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _showPassword.dispose();
    super.dispose();
  }
}
