import 'package:eat_all_fungus/constValues/constSizes.dart';
import 'package:eat_all_fungus/services/authRepository.dart';
import 'package:eat_all_fungus/services/profileRepository.dart';
import 'package:eat_all_fungus/views/widgets/inputs/textInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final secPasswordController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('SIGN UP'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(paddingSize),
                child: buildTextInput(
                    controller: usernameController,
                    hintText: 'Username',
                    iconInput: Icon(Icons.person)),
              ),
              SizedBox(height: spacingSize),
              Padding(
                padding: EdgeInsets.all(paddingSize),
                child: buildTextInput(
                    controller: emailController,
                    hintText: 'Email',
                    inputType: TextInputType.emailAddress,
                    iconInput: Icon(Icons.mail)),
              ),
              SizedBox(height: spacingSize),
              Padding(
                padding: EdgeInsets.all(paddingSize),
                child: buildTextInput(
                    controller: passwordController,
                    hintText: 'Password',
                    isObscured: true,
                    iconInput: Icon(Icons.lock)),
              ),
              SizedBox(height: spacingSize),
              Padding(
                padding: EdgeInsets.all(paddingSize),
                child: buildTextInput(
                    controller: secPasswordController,
                    hintText: 'Repeat Password',
                    isObscured: true,
                    iconInput: Icon(Icons.lock_outline)),
              ),
              SizedBox(height: spacingSize),
              Padding(
                padding: EdgeInsets.all(paddingSize),
                child: ElevatedButton(
                    onPressed: () async {
                      if (passwordController.text !=
                          secPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('The passwords dont match, try again!')));
                        passwordController.clear();
                        secPasswordController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Signing up...')));
                        await context.read(authRepositoryProvider).signUp(
                            emailController.text, passwordController.text);
                        await context
                            .read(userProfileRepository)
                            .createEmptyProfile(name: usernameController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        height: 50.0,
                        width: double.infinity,
                        child: Center(
                            child: Text('Register',
                                style: GoogleFonts.inter(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold))))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
