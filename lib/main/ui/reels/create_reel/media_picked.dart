import 'dart:typed_data';

import 'package:chat_app/main/helper/image/media_helper.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class MediaPicked extends StatefulWidget {
  const MediaPicked(this.maxCount, this.requestType, {super.key});
  final int maxCount;
  final RequestType requestType;

  @override
  State<MediaPicked> createState() => _MediaPickedState();
}

class _MediaPickedState extends State<MediaPicked> {
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  @override
  void initState() {
    MediaHelper().loadAlbums(widget.requestType).then((values) {
      setState(() {
        albumList = values;
        selectedAlbum = values[0];
      });
      MediaHelper().loadAssests(selectedAlbum!).then((values) {
        setState(() {
          assetList = values;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<AssetPathEntity>(
          value: selectedAlbum,
          onChanged: (AssetPathEntity? value) {
            setState(() {
              selectedAlbum = value;
            });
            MediaHelper().loadAssests(selectedAlbum!).then((values) {
              setState(() {
                assetList = values;
              });
            });
          },
          items:
              albumList.map<DropdownMenuItem<AssetPathEntity>>((
                AssetPathEntity album,
              ) {
                return DropdownMenuItem<AssetPathEntity>(
                  value: album,
                  child: FutureBuilder<int>(
                    future: album.assetCountAsync,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(album.name); // tạm thời chỉ hiện tên
                      }
                      if (snapshot.hasError) {
                        return Text('${album.name} (err)');
                      }
                      return Text('${album.name} - ${snapshot.data}');
                    },
                  ),
                );
              }).toList(),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(2),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 cột giống Instagram
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: assetList.length,
        itemBuilder: (context, index) {
          final asset = assetList[index];
          return assetWidget(asset);
        },
      ),
    );
  }

  Widget assetWidget(AssetEntity asset) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(selectedAssetList.contains(asset) ? 15 : 0),
            child: AssetEntityImage(
              asset,
              isOriginal: false, // dùng thumbnail cho nhanh
              thumbnailSize: const ThumbnailSize.square(
                250,
              ), // kích thước thumbnail
              fit: BoxFit.cover, // cách hiển thị
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
        ),
        if (asset.type == AssetType.video)
          Positioned(
            right: 5,
            bottom: 5,
            child: SvgPicture.asset(
              AppImages.icReelsActive,
              width: 24,
              height: 24,
              color: AppColors.red100,
            ),
          ),
      ],
    );
  }
}
