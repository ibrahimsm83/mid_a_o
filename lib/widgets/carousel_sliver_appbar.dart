import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mao/utils/image_viewer.dart';

import 'package:sizer/sizer.dart';
import 'package:image_viewer/image_viewer.dart';

class CarouselSliver extends SliverPersistentHeaderDelegate {
  CarouselSliver({
    required this.expandedHeight,
    required this.photosPath,
  });
  final double expandedHeight;
  bool buttonEnabled = true;
  final List<dynamic> photosPath;

  Widget carouselItem(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            imagePath,
            width: 76.w,
            height: 20.7.h,
            fit: BoxFit.cover,
          )),
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double height =
        inverseLerp(0, expandedHeight, expandedHeight - shrinkOffset).isNegative
            ? 0
            : inverseLerp(0, expandedHeight, expandedHeight - shrinkOffset);
    return SizedBox(
      height: (expandedHeight - shrinkOffset).clamp(0.0, expandedHeight),
      child: CarouselSlider.builder(
          itemCount: photosPath.length,
          itemBuilder: (
            context,
            indexOne,
            indexTwo,
          ) =>
              InkWell(
                key: ObjectKey(photosPath[indexTwo % photosPath.length]),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SliderShowFullmages(
                            listImagesModel: photosPath,
                            current: indexTwo % photosPath.length,
                          )));
                },
                child: carouselItem(
                  photosPath[indexTwo % photosPath.length],
                ),
              ),
          options: CarouselOptions(
            height: 20.7.h,
            aspectRatio: 16 / 9,
            viewportFraction: 0.65,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {},
            scrollDirection: Axis.horizontal,
          )),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

double inverseLerp(double min, double max, double value) {
  return (value - min) / (max - min);
}
