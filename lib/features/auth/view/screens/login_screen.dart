
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskey_app/const.dart';
import 'package:taskey_app/core/utils/app_dialog.dart';
import 'package:taskey_app/core/utils/validator.dart';
import 'package:taskey_app/features/auth/view/screens/register_screen.dart';
import 'package:taskey_app/main_layout.dart';
import '../../view_model/auth_cubit.dart';
import '../widgets/inkwell_widget.dart';
import '../widgets/text_form_field_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var email = TextEditingController();
  var password = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          AppDialog.showLoading(context);
        }
        if (state is LoginSuccess) {
          Navigator.pop(context);

          email.clear();
          password.clear();

          Navigator.pushReplacementNamed(
            context,
            MainLayout.routeName,
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
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 122.h),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 53.h),
                  Text(
                    'email',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  TextFormFieldWidget(
                    controller: email,
                    validator: Validator.validateEmail,
                    hintText: 'enter email',
                  ),
                  SizedBox(height: 26.h),
                  Text(
                    'password',
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  TextFormFieldWidget(
                    controller: password,
                    validator: Validator.validatePassword,
                    hintText: 'password',
                    isPassword: true,
                    obscureText: true,
                  ),
                  SizedBox(height: 71.h),
                  MaterialButton(
                    onPressed: onPressedLogin,
                    color: themeColor,
                    minWidth: double.infinity,
                    height: 48.h,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16.sp,
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
            title: 'Don’t have an account? ',
            subTitle: 'Register',
            routePath: RegisterScreen.routeName,
          ),
        );
      },
    );
  }
   onPressedLogin() {
     if (formKey.currentState!.validate()) {
       context.read<AuthCubit>().login(
         email: email.text,
         password: password.text,
       );
     }
   }
}



