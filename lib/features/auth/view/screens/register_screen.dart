import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskey_app/const.dart';
import 'package:taskey_app/core/utils/app_dialog.dart';
import 'package:taskey_app/core/utils/validator.dart';

import '../../view_model/auth_cubit.dart';
import '../widgets/inkwell_widget.dart';
import '../widgets/text_form_field_widget.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register_screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var email = TextEditingController();
  var password = TextEditingController();
  var fullName = TextEditingController();
  var confirmPassword = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          AppDialog.showLoading(context);
        }

        if (state is RegisterSuccess) {
          Navigator.pop(context);

          fullName.clear();
          email.clear();
          password.clear();
          confirmPassword.clear();

          Navigator.pushReplacementNamed(
            context,
            LoginScreen.routeName,
          );
        }

        if (state is AuthError) {
          Navigator.pop(context);

          AppDialog.showError(
            context,
            error: state.message,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 97),
                  Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 53),
                  Text(
                    'UserName',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormFieldWidget(
                    controller: fullName,
                    validator: Validator.validateName,
                    hintText: 'enter userName',
                  ),
                  SizedBox(height: 26),
                  Text(
                    'email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormFieldWidget(
                    controller: email,
                    validator: Validator.validateEmail,
                    hintText: 'enter email',
                  ),
                  SizedBox(height: 26),
                  Text(
                    'password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormFieldWidget(
                    controller: password,
                    validator: Validator.validatePassword,
                    hintText: 'password',
                    isPassword: true,
                    obscureText: true,
                  ),
                  SizedBox(height: 26),
                  Text(
                    'confirm password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormFieldWidget(
                    controller: confirmPassword,
                    validator: (text) {
                      return Validator.validateConfirmPassword(
                          text, password.text);
                    },
                    hintText: 'confirm password',
                    isPassword: true,
                    obscureText: true,
                  ),

                  SizedBox(height: 71),
                  MaterialButton(
                    onPressed: onPressedRegister,
                    color: themeColor,
                    minWidth: double.infinity,
                    height: 48,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: InKWellWidget(
            title: 'Already have an account? ',
            subTitle: 'Login',
            routePath: LoginScreen.routeName,
          ),
        );
      },
    );
  }
  onPressedRegister () {
  if (formKey.currentState!.validate()) {
  context.read<AuthCubit>().register(
  name: fullName.text,
  email: email.text,
  password: password.text,
  );
  }
  }
}
