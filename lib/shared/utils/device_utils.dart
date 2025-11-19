import 'dart:math';
// This is a comment to replace the erroneous block of code

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';

class DeviceUtils {
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isTablet(BuildContext context) {
    double width = getScreenWidth(context);
    return width >= 600.0;
  }

  static bool isPhone(BuildContext context) {
    double width = getScreenWidth(context);
    return width < 600.0;
  }

  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  static double getTextScaleFactor(BuildContext context) {
    // textScaleFactor was deprecated in newer Flutter SDKs; prefer textScaler when available.
    // Keep backward-compatible access and ignore the deprecation lint here.
    // ignore: deprecated_member_use
    return MediaQuery.of(context).textScaleFactor;
  }

  static TextStyle titleStyle = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subtitleStyle = const TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  static RegExp passwordRegex = RegExp(
    r'^(?=.*\d)'
    r'(?=.*[a-z])'
    r'(?=.*[A-Z])'
    r'(?=.*[a-zA-Z])'
    r'(?=.*[@#\$%^&+=])'
    r'(?!.*\s)'
    r'.{8,32}$',
  );

  static Widget socialIcon(String assetPath, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: iconColor, width: 1.w),
      ),
      child: CircleAvatar(
        radius: 24.r,
        backgroundColor: iconColor,
        child: SvgPicture.asset(assetPath, width: 36.w, height: 36.h),
      ),
    );
  }

  static Widget backIcon(String assetPath, Color iconColor, int size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.neutral40, width: 1.w),
      ),
      child: CircleAvatar(
        radius: size.r,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(
          assetPath,
          width: size.w,
          height: size.h,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }

  static Widget homeScreenIcon(String assetPath, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: iconColor, width: 1.w),
      ),
      child: CircleAvatar(
        radius: 16.r,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(assetPath, width: 16.w, height: 16.h),
      ),
    );
  }

  static String generateTempPassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#\$%';
    final rand = Random.secure();
    return List.generate(
      12,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }
}
