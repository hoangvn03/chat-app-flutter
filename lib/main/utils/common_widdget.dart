import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget bottomButton({
  required String text,
  required onTap,
  color,
  textColor,
  isBoxBorder,
  isIcon,
  isMargin,
  padding,
  margin,
  bool? hasHeight,
  bool? uppercase,
  double? radius,
  double? fontSize,
}) {
  return Container(
    margin:
        margin ?? (EdgeInsets.only(left: 15, top: 24, right: 15, bottom: 10)),
    child: InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: hasHeight == null ? 50 : null,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 25),
          border: isBoxBorder ?? Border.all(color: AppColors.blue60, width: 2),
          color: color ?? AppColors.blue60,
        ),
        child: Center(
          child:
              isIcon != null && isIcon
                  ? Icon(Icons.delete, color: AppColors.white)
                  : Text(
                    textAlign: TextAlign.center,
                    text,
                    style: TextStyle(
                      color:
                          textColor ??
                          (color == AppColors.white
                              ? AppColors.black
                              : AppColors.white),

                      fontSize: fontSize ?? 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
        ),
      ),
    ),
  );
}

Widget commonTextField({
  String? labelText,
  String? hintText,
  TextEditingController? controller,
  bool? obscureText,
  TextInputType? keyboardType,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(24)),
      border: Border.all(color: AppColors.gray30, width: 2),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppStyles.textCommon.copyWith(color: AppColors.gray30),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: AppStyles.textCommon.copyWith(
          fontSize: 20,
          color: AppColors.gray30,
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: InputBorder.none, // 👈 bỏ viền
        enabledBorder: InputBorder.none, // 👈 bỏ viền khi enabled
        focusedBorder: InputBorder.none, // 👈 bỏ viền khi focus
      ),
    ),
  );
}

Widget titleAppTwoElement({
  String? urlImage,
  String? titleText,
  VoidCallback? onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      children: [
        Container(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: SvgPicture.asset(urlImage ?? AppImages.icClose),
            onPressed: onPressed,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              titleText ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 32),
      ],
    ),
  );
}

Widget iconLikeNotification({bool isHasNotification = false}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      SvgPicture.asset(AppImages.icLike),
      if (isHasNotification)
        Positioned(
          left: 16,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.red100, // màu của hình tròn
              shape: BoxShape.circle,
            ),
          ),
        ),
    ],
  );
}

Widget iconShareNotification({int? num, bool isHasNotification = false}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      SvgPicture.asset(AppImages.icShare),
      if (isHasNotification)
        Positioned(
          left: 12,
          top: -5,
          child: Container(
            width: 19,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.red100, // màu của hình tròn
            ),
            child: Center(
              child: Text(
                '$num',
                style: TextStyle(fontSize: 9, color: AppColors.white),
              ),
            ),
          ),
        ),
    ],
  );
}
