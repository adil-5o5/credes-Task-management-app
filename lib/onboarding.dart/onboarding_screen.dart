import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:task_management_app/list/lists_screen.dart';
import 'package:task_management_app/onboarding.dart/screen_1.dart';
import 'package:task_management_app/onboarding.dart/screen_2.dart';
import 'package:task_management_app/onboarding.dart/screen_3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

//controller for pageview indi
PageController _controller = PageController();

//keep track of the lastpage

bool onLastPage = false;

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) => {
            setState(() {
              onLastPage = (index == 2);
            }),
          },
          children: [Screen1(), Screen2(), Screen3()],
        ),
        Container(
          alignment: Alignment(0, 0.75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //skip
              GestureDetector(
                onTap: () {
                  _controller.jumpToPage(2);
                },
                child: Text(
                  "skip",
                  style: GoogleFonts.poppins(
                    decoration: TextDecoration.none,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              SmoothPageIndicator(controller: _controller, count: 3),
              //next or signin
              GestureDetector(
                onTap: () async {
                  if (onLastPage) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('seen_onboard', true);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListsScreen(),
                      ),
                    );
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  }
                },

                child: Text(
                  onLastPage ? "Done" : "Next",
                  style: GoogleFonts.poppins(
                    decoration: TextDecoration.none,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
