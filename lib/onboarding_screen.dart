

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:taskey_app/const.dart';
import 'package:taskey_app/core/widget/custom_animated_widget.dart';
import 'package:taskey_app/core/widget/onboarding_model.dart';

import 'features/auth/view/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  static const String routeName = 'OnboardingScreen';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<OnBoardingData> onBoarding = dataOnBoarding();
  int index = 0;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 40.0.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 260.h,
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  itemBuilder: (context, index) => CustomAnimatedWidget(
                    index: index,
                    delay: index,
                    child: Image.asset(onBoarding[index].image),
                  ),
                ),
              ),
              SizedBox(height: 23.h),
              SmoothPageIndicator(
                controller: controller,
                count: onBoarding.length,
                effect: ExpandingDotsEffect(
                  dotWidth: 16.w,
                  dotHeight: 4.h,
                  dotColor: Color(0xffB9B9B9),
                  activeDotColor: themeColor,
                ),
              ),
              SizedBox(height: 50.h),
              Text(
                onBoarding[index].title,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff24252C),
                ),
              ),
              SizedBox(height: 42),
              Text(
                onBoarding[index].describtion,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6E6A7C),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 95.h),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                  onPressed: ()async {
                    if (index < onBoarding.length - 1) {
                      controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.linear,
                      );
                    } else {
                      final prefs= await SharedPreferences.getInstance();
                      await prefs.setBool('onBoardingDone', true);
                      if(!mounted) return;
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(LoginScreen.routeName);
                    }
                  },
                  color: Color(0xff5F33E1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(12.0.r),
                    child: Text(
                      index < onBoarding.length - 1 ? 'Next' : 'Get Started',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
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
