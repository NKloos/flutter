import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpd_ss23/login_page/login_screen.dart';
import 'package:cpd_ss23/services/global_methods.dart';
import 'package:cpd_ss23/services/global_variables.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signUpFormKey = GlobalKey<FormState>();
  File? imageFile;
  String? imageUrl;

  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _cityTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneNumberTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget buildTextFormField({
    required String helperText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required String? Function(String?) validator,
    required TextEditingController controller,
  }) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        helperText: helperText,
        filled: true,
        fillColor: Colors.blueGrey.withOpacity(0.2),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  void _openGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void _submitFormSignup() async {
    final isValid = _signUpFormKey.currentState!.validate();
    if (isValid) {
      if (imageFile == null) {
        if (kIsWeb) {
          //hier sollte eine  methode zum erstellen des Files aus internet geben( weil in web path_provider.dart'; nicht realoisiert ist) , aber es ist mir zu viel
        } else {
          final appDir = await getApplicationDocumentsDirectory();
          final defaultImagePath = '${appDir.path}/default_profile_image.jpg';
          final defaultImageAsset =
              await rootBundle.load('assets/images/genericProfile.jpg');
          final bytes = defaultImageAsset.buffer.asUint8List();
          await File(defaultImagePath).writeAsBytes(bytes);
          imageFile = File(defaultImagePath);
        }
      }
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text.trim(),
      );
      final User? user = _auth.currentUser;
      final _uid = user!.uid;
      if (kIsWeb) {
        imageUrl =
            "https://firebasestorage.googleapis.com/v0/b/cpd-last-try.appspot.com/o/userImages%2Fweb_foto.jpeg?alt=media&token=41db34c9-ce68-4d5f-a10b-e45802479999";
      } else {
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child('$_uid.jpg');
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
      }
      FirebaseFirestore.instance.collection('users').doc(_uid).set({
        'id': _uid,
        'name': _nameTextController.text,
        'email': _emailTextController.text,
        'userImage': imageUrl,
        'phone': _phoneNumberTextController.text,
        'location': _cityTextController.text,
        'createdAt': Timestamp.now(),
      });
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    } catch (e) {
      // Handle any errors that occur during sign-up
      setState() {
        _isLoading = false;
      }

      GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            signupUrlImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
              child: ListView(
                children: [
                  Form(
                    key: _signUpFormKey,
                    autovalidateMode:
                        AutovalidateMode.always, // Enable immediate validation
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _openGallery();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 80,
                              right: 80,
                              bottom: 40,
                            ),
                            child: Container(
                              width: size.width * 0.44,
                              height: size.width * 0.44,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 5, color: Colors.cyan),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: imageFile == null
                                    ? const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.cyan,
                                        size: 120,
                                      )
                                    : Image.file(
                                        imageFile!,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        buildTextFormField(
                          helperText: 'Name',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Wer bist du?';
                            } else {
                              return null;
                            }
                          },
                          controller: _nameTextController,
                        ),
                        buildTextFormField(
                          helperText: 'Stadt',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Wo wohnst du?';
                            } else {
                              return null;
                            }
                          },
                          controller: _cityTextController,
                        ),
                        buildTextFormField(
                          helperText: 'Email',
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Bitte gültige Email eingeben';
                            } else {
                              return null;
                            }
                          },
                          controller: _emailTextController,
                        ),
                        buildTextFormField(
                          helperText: 'Handynummer',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Bitte Handynummer eingeben';
                            } else {
                              return null;
                            }
                          },
                          controller: _phoneNumberTextController,
                        ),
                        buildTextFormField(
                          helperText: 'Passwort',
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return 'Passwort muss mindestens 5 Zeichen lang sein';
                            } else {
                              return null;
                            }
                          },
                          controller: _passwordTextController,
                        ),
                        _isLoading
                            ? Center(
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  child: const CircularProgressIndicator(),
                                ),
                              )
                            : MaterialButton(
                                onPressed: _submitFormSignup,
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
                                        'Sign Up',
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
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: const Text(
                              'Schon registriert?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
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
