import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/widgets/index_widgets.dart';


enum ImageType {
  camera,
  gallery,
}

class ImagePickerUtility {
  File? _image;
  File? get image => _image;
  final _imagePicker = ImagePicker();
  Future<ImageType> _getImageType(BuildContext context) async {
    final Completer<ImageType> completer = Completer();

    showModalBottomSheet(
      context: context,
      builder: (context) => imageSouceSheet(
        onCameraPressed: () {
          completer.complete(ImageType.camera);
          Navigator.of(context).pop();
        },
        onGalleryPressed: () {
          completer.complete(ImageType.gallery);
          Navigator.of(context).pop();
        },
        context: context,
      ),
    );
    return completer.future;
  }

  Future<void> pickImage(BuildContext context) async {
    final _imageType = await _getImageType(context);
    PickedFile? _file;
    if (_imageType == ImageType.camera) {
      _file = await _imagePicker.getImage(source: ImageSource.camera);
    } else {
      _file = await _imagePicker.getImage(source: ImageSource.gallery);
    }
    if (_file != null) {
      _image = File(_file.path);
      var tempImg = _image;
      if (tempImg != null) {
        _image = await _cropImage(tempImg);
      }
    }
  }

  Future<File?> pickImageWithGallery() async {
    PickedFile? _file;
    _file = await _imagePicker.getImage(source: ImageSource.gallery);
    if (_file != null) {
      File _image = File(_file.path);
      var tempImg = _image;
      if (tempImg != null) {
        _image = await _cropImage(tempImg);
      }
      return _image;
    }
  }

  Future<File?> pickImageWithReturn(BuildContext context) async {
    final _imageType = await _getImageType(context);
    PickedFile? _file;
    if (_imageType == ImageType.camera) {
      _file = await _imagePicker.getImage(source: ImageSource.camera);
    } else {
      _file = await _imagePicker.getImage(source: ImageSource.gallery);
    }
    if (_file != null) {
      File _image = File(_file.path);
      var tempImg = _image;
      if (tempImg != null) {
        _image = await _cropImage(tempImg);
      }
      return _image;
    }
  }

  Future<File> _cropImage(File image) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: AppStrings.CROP_IMAGE,
          toolbarColor: AppColors.RED,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      return croppedFile;
    } else {
      throw Exception('No Cropped File Present');
    }
  }
}
