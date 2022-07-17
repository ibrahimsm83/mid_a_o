import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mao/models/event_model.dart';
import 'package:mao/services/network.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/widgets/index_widgets.dart';
import 'package:mao/widgets/photo_selection_field.dart';
import 'package:mao/widgets/star_rating.dart';

import 'package:sizer/sizer.dart';

class ReivewDialog extends StatelessWidget {
  ReivewDialog({Key? key, required this.event}) : super(key: key);
  num? _rating;
  String? _writtenReview;
  final EventData event;
  List<File> _allPhotos = [];

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.BACKGROUND_BLUE_HAZE,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child:
          // BlocBuilder<AddReviewCubit, AddReviewState>(
          //   builder: (context, state) {
          //     return
          SingleChildScrollView(
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
              child: Text(
                AppStrings.POST_REVIEW,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 18.0),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: SmoothStarRating(
                        allowHalfRating: false,
                        starCount: 5,
                        rating: 0,
                        size: 30.0,
                        defaultIconData:
                            Icons.star_border, //FontAwesome5Solid.star,
                        filledIconData: Icons.star, //FontAwesome5Solid.star,
                        halfFilledIconData:
                            Icons.star_half, //FontAwesome5.star_half,
                        color: Colors.grey,
                        borderColor: Colors.grey,
                        onRated: (value) {
                          _rating = value;
                          // context.read<AddReviewCubit>().ratingChanged(value);
                        },
                        spacing: 12.0),
                  ),

                  SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    maxLines: 7,
                    validator: (_) => true //!state.isReviewValid
                        ? AppStrings.WRITTEN_REVIEW_IS_REQUIRED
                        : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      hintText: AppStrings.POST_REVIEW_HINTTEXT,
                      hintStyle: Theme.of(context).textTheme.subtitle2,
                    ),
                    onChanged: (value) {
                      // context
                      //     .read<AddReviewCubit>()
                      //     .writtenReviewChanged(value);
                      _writtenReview = value;
                    },
                  ),
                  // SizedBox(
                  //   height: 24,
                  // ),
                  FormBuilderImagePicker(
                    context: context,
                    onChanged: (value) {
                      final _tempList = value;
                      if (_tempList != null) {
                        final _allPhotosTemp =
                            _tempList.map((e) => e as File).toList();
                        _allPhotos = _allPhotosTemp;
                        //context.read<AddReviewCubit>().photoChanged(true);
                      }
                    },
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(76.5.w, 7.h),
                          primary: Theme.of(context).primaryColor,
                          shape: StadiumBorder()),
                      onPressed: true //state.isPostReviewFormValid
                          ? () async {
                              var res = await NetworkApi.Reviewpost(
                                  eventid: event.id.toString(),
                                  rating: _rating.toString(),
                                  comment: _writtenReview ?? "");
                              print(res);
                              print("Review Details post");
                              AppNavigation.navigatorPop(context);
                              CustomSnacksBar.showSnackBar(
                                  context, res['message'].toString());

                              //
                              // print(_writtenReview);
                              // print(_rating);
                              // print(event.id);
                              // context.read<AddReviewCubit>().submitRating(
                              //       _rating!,
                              //       _writtenReview!,
                              //       event,
                              //       context
                              //           .read<AuthenticationRepository>()
                              //           .currentUsermodel!,
                              //       allPhotos: _allPhotos,
                              //     );

                              //AppNavigation.navigatorPop(context);
                            }
                          : null,
                      child: Text(
                        AppStrings.POST,
                        style: Theme.of(context).textTheme.button,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
