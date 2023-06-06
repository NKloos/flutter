import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpd_ss23/forget_passwort/forget_pass_screen.dart';
import 'package:cpd_ss23/services/global_methods.dart';
import 'package:cpd_ss23/services/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../forget_passwort/forget_pass_screen.dart';
import '../signup_page/signup_screen.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late Animation<double> _animation; // Animation-Objekt für den Hintergrund
  late AnimationController
      _animationController; // AnimationController zur Steuerung der Animation
  final _loginFormKey =
      GlobalKey<FormState>(); // GlobalKey für das Login-Formular
  final FocusNode _passFocusNode =
      FocusNode(); // FocusNode für das Passwort-Eingabefeld
  final TextEditingController _emailTextController = TextEditingController(
      text: ''); // TextEditingController für die E-Mail-Eingabe
  final TextEditingController _passTextController =
      TextEditingController(text: ''); // TextEditingController für das Passwort
  bool _obscureText =
      false; // Variable zur Steuerung der Sichtbarkeit des Passworts
  bool _isLoading = false; // Variable zur Anzeige des Ladezustands
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instanz der Firebase-Authentifizierung

  @override
  void dispose() {
    _animationController.dispose(); // AnimationController freigeben
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration:
            Duration(seconds: 20)); // Initialisierung des AnimationControllers
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward(); // Start der Animation
    super.initState();
  }

  void _submitFormOnLogin() async {
    final isValid =
        _loginFormKey.currentState!.validate(); // Validierung des Formulars
    if (isValid) {
      setState(() {
        _isLoading = true; // Setzen der Ladeanzeige
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim(),
        ); // Firebase-Anmeldung mit E-Mail und Passwort
        // ignore: use_build_context_synchronously
        Navigator.canPop(context)
            ? Navigator.pop(context)
            : null; // Zurücknavigieren, falls möglich
      } catch (error) {
        setState(() {
          _isLoading = false; // Ladeanzeige zurücksetzen
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        // ignore: avoid_print
        print('error occured $error');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value,
                0), // Hintergrundbild-Position basierend auf dem Animation-Objekt
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: Image.asset('assets/images/login.png'),
                  ),
                  const SizedBox(height: 15),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Bitte gültige E-Mail-Adresse eingeben';
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _passFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          obscureText: !_obscureText,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return 'Passwort ist ungültig, mind 5 Zeichen';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Passwort',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPasswort()));
                                },
                                child: const Text(
                                  'Passwort vergessen?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontStyle: FontStyle.italic),
                                ))),
                        const SizedBox(
                          height: 15,
                        ),
                        MaterialButton(
                          onPressed: _submitFormOnLogin,
                          // Funktion zum Einreichen des Formulars, s. oben
                          color: Colors.cyan,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          // Funktion zum Einreichen des Formulars, s. oben
                          color: Colors.white70,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
