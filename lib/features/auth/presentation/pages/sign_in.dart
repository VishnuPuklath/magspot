import 'package:flutter/material.dart';
import 'package:magspot/core/theme/app_pallete.dart';
import 'package:magspot/features/auth/presentation/pages/sign_up.dart';
import 'package:magspot/features/auth/presentation/widgets/auth_field.dart';
import 'package:magspot/features/auth/presentation/widgets/auth_gradient_button.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordContoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();

    _passwordContoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'SignIn.',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              AuthField(controller: _emailController, hintText: 'Email'),
              const SizedBox(
                height: 15,
              ),
              AuthField(
                controller: _passwordContoller,
                hintText: 'Password',
                isPassword: true,
              ),
              const SizedBox(
                height: 20,
              ),
              AuthGradientButton(
                onPressed: () {},
                buttonText: 'SignIn',
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    SignUpPage.route(),
                    (route) => false,
                  );
                },
                child: RichText(
                  text: TextSpan(
                      text: 'Dont\'t have an account? ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                            text: 'SignUp',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: AppPallete.gradient2,
                                    fontWeight: FontWeight.bold))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
