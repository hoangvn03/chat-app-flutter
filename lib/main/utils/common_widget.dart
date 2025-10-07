import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

//Common
Widget commonButton({
  required String text,
  required onTap,
  color,
  colorBorder,
  textColor,
  isBoxBorder,
  isIcon,
  isMargin,
  padding,
  margin,
  textStyle,
  double? height,
  bool? hasHeight,
  bool? uppercase,
  double? radius,
  double? fontSize,
}) {
  return InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: onTap,
    child: Container(
      margin:
          margin ?? (EdgeInsets.only(left: 12, top: 0, right: 12, bottom: 0)),

      height: hasHeight == null ? 50 : height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 25),
        border:
            isBoxBorder ??
            Border.all(color: colorBorder ?? Colors.transparent, width: 1),
        color: color ?? AppColors.blue60,
      ),
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          text,
          style:
              textStyle ??
              TextStyle(
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
  );
}

Widget commonTextField({
  String? labelText,
  String? hintText,
  double? radius,
  TextEditingController? controller,
  bool? obscureText,
  Color? color,
  TextInputType? keyboardType,
}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 24)),
      border: Border.all(color: AppColors.gray30, width: 1),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppStyles.title3Regular.copyWith(color: AppColors.gray40),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: AppStyles.title3Regular.copyWith(
          fontSize: 18,
          color: AppColors.gray40,
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

Widget commonTextFieldV2({
  String? labelText,
  String? hintText,
  String? iconLeading,
  TextStyle? labelStyle,
  TextStyle? hintStyle,
  TextStyle? inputStyle,
  double? radius,
  double? height,
  EdgeInsets? margin,
  EdgeInsets? padding,
  TextEditingController? controller,
  bool? obscureText,
  bool? enabled,
  Color? color,
  TextInputType? keyboardType,
  VoidCallback? onTap,
  ValueChanged<String>? onChanged,
}) {
  final effectiveController = controller ?? TextEditingController();

  return Container(
    alignment: Alignment.center,
    margin: margin ?? const EdgeInsets.only(right: 16),
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: color ?? AppColors.gray20,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 8)),
    ),
    height: height ?? 38,
    child: ValueListenableBuilder<TextEditingValue>(
      valueListenable: effectiveController,
      builder: (context, value, child) {
        return TextField(
          textAlignVertical: TextAlignVertical.center,
          obscureText: obscureText ?? false,
          controller: effectiveController,
          style: inputStyle ?? AppStyles.title3Regular,
          onTap: onTap,
          onChanged: onChanged,
          cursorColor: AppColors.gray40,
          cursorWidth: 1.5,
          cursorHeight: 16,
          cursorRadius: const Radius.circular(4),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                hintStyle ??
                const TextStyle(fontSize: 14, color: AppColors.gray40),
            isDense: true,
            labelText: labelText,
            labelStyle:
                labelStyle ??
                AppStyles.title3Regular.copyWith(color: AppColors.gray40),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: AppStyles.title3Regular.copyWith(
              fontSize: 18,
              color: AppColors.gray40,
            ),
            enabled: enabled ?? true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 0,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SvgPicture.asset(
                iconLeading ?? AppImages.icSearch,
                color: AppColors.gray40,
                width: 16,
                height: 16,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            // 👇 chỉ hiện khi có text
            suffixIcon:
                value.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        effectiveController.clear();
                      },
                    )
                    : null,
            fillColor: AppColors.gray20,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    ),
  );
}

Widget cricleColorImage({
  Widget? childWidget,
  double? size,
  bool hasReels = true,
  bool hasReelsBorder = true,
  double? paddingImage,
}) {
  final double finalSize = size ?? 78;
  double xSize = 6;
  if (finalSize < 78) {
    xSize = 4;
  }
  return SizedBox(
    width: finalSize,
    height: finalSize,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Viền gradient
        if (hasReelsBorder)
          Container(
            width: finalSize,
            height: finalSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient:
                  (hasReels)
                      ? LinearGradient(
                        colors: [
                          Color(0xFF7638FA), // Purple
                          Color(0xFFD300C5), // Pink
                          Color(0xFFFF0069), // Red
                          Color(0xFFFF7A00), // Orange
                          Color(0xFFFFD600), // Yellow
                          Color(0xFF7638FA), // Purple repeat
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      )
                      : LinearGradient(
                        colors: [AppColors.gray30, AppColors.gray20],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
            ),
          ),
        // Nền trắng bên trong
        Container(
          width: finalSize - xSize,
          height: finalSize - xSize,
          padding: EdgeInsets.all(paddingImage ?? 2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: ClipOval(child: childWidget),
        ),
      ],
    ),
  );
}

Widget userNote({String? img, String? note, String? subTitle}) {
  return Column(
    children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          /// Avatar
          ClipOval(
            child: Image.asset(
              img ?? AppImages.imgAvatarDefault,
              width: 68,
              height: 68,
              fit: BoxFit.cover,
            ),
          ),

          /// Note hiển thị phía trên avatar
          Positioned(
            left: 0,
            bottom: 60,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(-2, 0),
                        blurRadius: 6,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(2, 0),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 64,
                    child: Text(
                      note ?? '',
                      style: AppStyles.footnoteRegular,
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -4,
                  left: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -8,
                  left: 24,
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      if (subTitle != null)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subTitle, style: AppStyles.footnoteRegular),
        ),
    ],
  );
}

Widget commonTileItem({
  String? imageLeading,
  String? title,
  String? subtitle,
  TextStyle? titleStyle,
  TextStyle? subTitleStyle,
  EdgeInsets? margin,
  Widget? titleWidget,
  Widget? trallingWidget,
  Widget? leadingWidget,
  double? sizeImage,
  bool? hasReels,
  bool? hasReelsBorder,
  VoidCallback? onTapLeading,
  VoidCallback? onTapTralling,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          leadingWidget ??
              GestureDetector(
                onTap: onTapLeading,
                child: cricleColorImage(
                  size: sizeImage ?? 34,
                  hasReelsBorder: hasReelsBorder ?? true,
                  hasReels: hasReels ?? true,
                  childWidget: Image.asset(
                    imageLeading ?? AppImages.imgAvatarDefault, // ảnh PNG/JPG
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child:
                  titleWidget ??
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        style: titleStyle ?? AppStyles.headlineBold,
                      ),
                      Text(
                        subtitle ?? '',
                        style: subTitleStyle ?? AppStyles.footnoteRegular,
                      ),
                    ],
                  ),
            ),
          ),
          GestureDetector(
            onTap: onTapTralling,
            child:
                trallingWidget ??
                Transform.rotate(
                  angle: 90 * 3.1415926535 / 180, // xoay 90 độ (radian)
                  child: SvgPicture.asset(AppImages.icOption),
                ),
          ),
        ],
      ),
    ),
  );
}

//Icon
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

Widget iconMaintaining() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(AppImages.icMaintaining),
      const SizedBox(height: 8),
      Text("Chức năng đang được phát triển"),
    ],
  );
}
