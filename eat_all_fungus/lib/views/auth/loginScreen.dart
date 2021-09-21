import 'package:eat_all_fungus/constValues/constSizes.dart';
import 'package:eat_all_fungus/services/authRepository.dart';
import 'package:eat_all_fungus/services/profileRepository.dart';
import 'package:eat_all_fungus/views/auth/registerScreen.dart';
import 'package:eat_all_fungus/views/widgets/inputs/textInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildEmailInput(emailController),
              SizedBox(height: spacingSize),
              _buildPassWordInput(passwordController),
              SizedBox(height: spacingSize),
              Padding(
                padding: EdgeInsets.all(paddingSize),
                child: ElevatedButton(
                    onPressed: () async {
                      await context
                          .read(authRepositoryProvider)
                          .signInWithEmailAndPassword(
                              emailController.text, passwordController.text);
                      await context.read(userProfileRepository).getProfile(
                          id: context
                              .read(authRepositoryProvider)
                              .getCurrentUser()!
                              .uid);
                    },
                    child: Container(
                        height: 50.0,
                        width: double.infinity,
                        child: Center(
                            child: Text('Login',
                                style: GoogleFonts.inter(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold))))),
              ),
              SizedBox(height: spacingSize),
              Padding(
                padding: EdgeInsets.all(paddingSize),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      child: Center(
                          child: Text('Sign Me Up Instead',
                              style: GoogleFonts.inter(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold))),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput(TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(paddingSize),
      child: buildTextInput(
          controller: controller,
          inputType: TextInputType.emailAddress,
          hintText: 'Email',
          iconInput: Icon(Icons.mail)),
    );
  }

  Widget _buildPassWordInput(TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(paddingSize),
      child: buildTextInput(
          controller: controller,
          hintText: 'Password',
          isObscured: true,
          iconInput: Icon(Icons.lock)),
    );
  }
}
