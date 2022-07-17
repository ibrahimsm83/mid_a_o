import 'package:flutter/material.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/widgets/index_widgets.dart';
import 'package:sizer/sizer.dart';

class TCDialog extends StatefulWidget {
  TCDialog({Key? key}) : super(key: key);

  @override
  _TCDialogState createState() => _TCDialogState();
}

class _TCDialogState extends State<TCDialog> {
  bool termsAndConditions = false;

  bool privacyPolicy = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.BACKGROUND_BLUE_HAZE,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 7.3.h,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: TextButton(
              onPressed: () {
                // AppNavigation.navigateTo(
                //     context,
                //     ConditionsScreen(
                //       title: AppStrings.PRIVACY_POLICY,
                //       assetPath: 'assets/privacy_policy.html',
                //     ));
              },
              child: Text(
                AppStrings.AGREEMENT,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          SizedBox(
            height: 3.4.h,
          ),
          TextButton(
            onPressed: () {
              // AppNavigation.navigateTo(
              //   context,
              //   ConditionsScreen(
              //     title: AppStrings.TERMS_AND_CONDITIONS_ALL_CAPS,
              //     assetPath: 'assets/terms_and_conditions.html',
              //   ),
              // );
            },
            child: Text(
              AppStrings.TC_CONDITION,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(
            height: 1.4.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: termsAndConditions,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          termsAndConditions = value;
                        });
                      }
                    }),
                GestureDetector(
                  onTap: () {},

                  // AppNavigation.navigateTo(
                  //   context,
                  //   HTMLScreens(
                  //     htmlPath: AssetPaths.PRIVACY_HTML,
                  //     title: AppStrings.TERMS_AND_CONDITIONS,
                  //   ),
                  // ),
                  child: Text(
                    AppStrings.TERMS_AND_CONDITIONS,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: privacyPolicy,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          privacyPolicy = value;
                        });
                      }
                    }),
                GestureDetector(
                  onTap: () {},

                  // => AppNavigation.navigateTo(
                  //   context,
                  //   HTMLScreens(
                  //     htmlPath: AssetPaths.PRIVACY_HTML,
                  //     title: AppStrings.PRIVACY_POLICY,
                  //   ),
                  // ),
                  child: Text(
                    AppStrings.PRIVACY_POLICY,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 1.4.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shape: StadiumBorder(),
                fixedSize: Size(78.4.w, 7.h),
                minimumSize: Size(78.4.w, 5.h),
                elevation: 6,
              ),
              child: Text(
                AppStrings.ACCEPT,
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                if (termsAndConditions && privacyPolicy) {
                  AppNavigation.navigatorPopTrue(context);
                } else if (!termsAndConditions && privacyPolicy) {
                  CustomSnacksBar.showSnackBar(
                      context, AppStrings.CONDITIONS_NOT_ACCEPTED_ERROR);
                } else if (!privacyPolicy && termsAndConditions) {
                  CustomSnacksBar.showSnackBar(
                      context, AppStrings.PRIVACY_POLICY_NOT_ACCEPTED_ERROR);
                } else if (!privacyPolicy && !termsAndConditions) {
                  CustomSnacksBar.showSnackBar(context,
                      AppStrings.PRIVACY_AND_CONDITIONS_NOT_ACCEPTED_ERROR);
                }
              },
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: StadiumBorder(),
                fixedSize: Size(78.4.w, 7.h),
                minimumSize: Size(78.4.w, 5.h),
                shadowColor: Colors.grey[400],
                elevation: 6,
              ),
              child: Text(
                AppStrings.REJECT,
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: AppColors.TEXT_GREY),
              ),
              onPressed: () {
                AppNavigation.navigatorPop(context);
              },
            ),
          ),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
