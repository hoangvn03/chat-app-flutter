import 'dart:io';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageHelper {
  ImageHelper({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();
  final ImagePicker _imagePicker;
  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    bool multiple = false,
  }) async {
    if (multiple) {
      return await _imagePicker.pickMultiImage(imageQuality: imageQuality);
    }
    final file = await _imagePicker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );
    if (file != null) return [file];
    return [];
  }
}

class MediaHelper {
  Future loadAlbums(RequestType requestType) async {
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];
    if (permission.isAuth) {
      albumList = await PhotoManager.getAssetPathList(type: requestType);
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  Future loadAssests(AssetPathEntity selectedAlbum) async {
    final count = await selectedAlbum.assetCountAsync;
    List<AssetEntity> albumList = await selectedAlbum.getAssetListRange(
      start: 0,
      end: count + 1,
    );
    return albumList;
  }
}
