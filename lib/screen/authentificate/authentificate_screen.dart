import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/authentification.dart';
import 'package:bigtitlss_management/common/constants.dart';
import 'package:bigtitlss_management/common/loading.dart';
import 'package:flutter/material.dart';

class AuthentificateScreen extends StatefulWidget {
  @override
  _AuthentificateScreenState createState() => _AuthentificateScreenState();
}

class _AuthentificateScreenState extends State<AuthentificateScreen> {
  final AuthtificationService _auth = AuthtificationService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool darkmode = false;
  dynamic savedThemeMode;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      _formKey.currentState.reset();
      error = '';
      emailController.text = '';
      nameController.text = '';
      passwordController.text = '';
      showSignIn = !showSignIn;
    });
  }

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Colors.black,
              elevation: 0.0,
              title: Text(showSignIn ? 'Sign in BM' : 'register BM'),
              actions: <Widget>[
                TextButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(
                    showSignIn ? 'Register' : 'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => toggleView(),
                )
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      !showSignIn
                          ? TextFormField(
                              controller: nameController,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'name'),
                              validator: (value) =>
                                  value.isEmpty ? "Enter an email" : null,
                            )
                          : Container(),
                      !showSignIn ? SizedBox(height: 10.0) : Container(),
                      TextFormField(
                        controller: emailController,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'email'),
                        validator: (value) =>
                            value.isEmpty ? "Enter a name" : null,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: passwordController,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'password',
                        ),
                        obscureText: true,
                        validator: (value) => value.length < 6
                            ? "Enter a password with at leat 4 char"
                            : null,
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        child: Text(
                          showSignIn ? "Sign In" : "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);

                            var password = passwordController.value.text;
                            var email = emailController.value.text;
                            var name = nameController.value.text;

                            dynamic result = showSignIn
                                ? await _auth.signInWithEmailAndPassword(
                                    email, password)
                                : await _auth.registerInWithEmailAndPassword(
                                    name, email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please supply a valid email';
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )),
          );
  }
}
