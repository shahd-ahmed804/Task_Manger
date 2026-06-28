import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:taskey_app/const.dart';
import 'package:taskey_app/core/widget/custom_animated_widget.dart';
import 'package:taskey_app/core/widget/onboarding_model.dart';

import 'features/auth/view/screens/login_screen.dart';



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
      backgroundColor: Color(0xffFFFFFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 260,
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
            SizedBox(height: 23),
            SmoothPageIndicator(
              controller: controller,
              count: onBoarding.length,
              effect: ExpandingDotsEffect(
                dotWidth: 16,
                dotHeight: 4,
                dotColor: Color(0xffB9B9B9),
                activeDotColor: themeColor,
              ),
            ),
            SizedBox(height: 50),
            Text(
              onBoarding[index].title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xff24252C),
              ),
            ),
            SizedBox(height: 42),
            Text(
              onBoarding[index].descrebtion,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff6E6A7C),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 95),
            Align(
              alignment: Alignment.bottomRight,
              child: MaterialButton(
                onPressed: () {
                  if (index < onBoarding.length - 1) {
                    controller.nextPage(
                      duration: Duration(microseconds: 500),
                      curve: Curves.linear,
                    );
                  } else {
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
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    index < onBoarding.length - 1 ? 'Next' : 'Get Started',
                    style: TextStyle(
                      fontSize: 16,
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
    );
  }
}
