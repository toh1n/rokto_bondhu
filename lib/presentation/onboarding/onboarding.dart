import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/routes_manager.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   SizedBox(
                     height: AppSize.s65,
                   ),
                   SizedBox(
                     height: AppSize.s65,
                   ),
                   SizedBox(
                     height: AppSize.s65,
                   ),
                   SvgPicture.asset(ImageAssets.onboardingLogo),
                   SizedBox(
                     height: AppSize.s65,
                   ),
                   Padding(
                     padding: EdgeInsets.all(AppPadding.p8),
                     child: Text(
                       AppStrings.onBoardingTittle1,
                       textAlign: TextAlign.center,
                       style: Theme.of(context).textTheme.headline1,
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.all(AppPadding.p8),
                     child: Column(children: [
                       Text(
                         AppStrings.onBoardingSubTittle1,
                         textAlign: TextAlign.center,
                         style: Theme.of(context).textTheme.subtitle1,
                       ),
                       Text(
                         AppStrings.onBoardingSubTittle2,
                         textAlign: TextAlign.center,
                         style: Theme.of(context).textTheme.subtitle1,
                       ),
                     ]),
                   ),
                 ],
               ),
               Column(
                 children: [
                   GestureDetector(
                   onTap: () {
                     Navigator.pushReplacementNamed(context, Routes.loginRoute);
                   },
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: ColorManager.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            AppStrings.getStarted,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    )
                 ],
               ),
        ],
      )),
    );
  }
}
