import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskey_app/auth/data/firebase/firebase_database_user.dart';
import 'package:taskey_app/auth/data/model/user_model.dart';
import 'package:taskey_app/auth/view/login_screen.dart';
import 'package:taskey_app/core/network/result_firebase.dart';

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

    if (user == null) return;

    final result = await FBAUser.getUserData(user.uid);

    if (result is SuccessFB<UserModel>) {
      userModel = result.data;
    } else if (result is ErrorFB<UserModel>) {
      debugPrint(result.messageError);
    }

    isLoading = false;
    if(mounted){
    setState(() {});
  }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xff5F33E1),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 60,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                userModel?.name ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                userModel?.email ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff5F33E1),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginScreen.routeName,
                          (route) => false,
                    );
                  },

                  icon: const Icon(Icons.logout),
                  label: const Text('Logout',style:TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffFFFFFF),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
