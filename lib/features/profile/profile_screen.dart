import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskey_app/core/network/result_firebase.dart';

import '../auth/data/firebase/firebase_database_user.dart';
import '../auth/data/model/user_model.dart';
import '../auth/view/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = 'ProfileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? userModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    final result = await FBAUser.getUserData(user.uid);

    if (result is SuccessFB<UserModel>) {
      userModel = result.data;
    } else if (result is ErrorFB<UserModel>) {
      debugPrint(result.messageError);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),

                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xff5F33E1),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  ),
                ),

                SizedBox(height: 20.h),

                Text(
                  userModel?.name ?? '',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                Text(
                  userModel?.email ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Username'),
                        subtitle: Text(userModel?.name ?? ''),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Email'),
                        subtitle: Text(userModel?.email ?? ''),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),

                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5F33E1),
                     // minimumSize: Size(double.infinity,50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();

                      if (!mounted) return;

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginScreen.routeName,
                            (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size:20,

                    ),
                    label: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.0.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}