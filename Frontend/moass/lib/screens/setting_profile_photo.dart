import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/widgets/top_bar.dart';

class SettingProfilePhotoScreen extends StatefulWidget {
  final String? profileImg;
  const SettingProfilePhotoScreen({super.key, required this.profileImg});

  @override
  State<SettingProfilePhotoScreen> createState() =>
      _SettingWidgetPhotoScreenState();
}

class _SettingWidgetPhotoScreenState extends State<SettingProfilePhotoScreen> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  late Image currentProfile;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담김
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      XFile imageFile = XFile(pickedFile.path);
      var croppedFile = await cropImage(imageFile);
      setState(() {
        _image = croppedFile; //가져온 이미지를 _image에 저장
      });
    }
  }

  Future<XFile?> cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      aspectRatio: const CropAspectRatio(ratioX: 500, ratioY: 500),
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    // Returning the edited/cropped image if available, otherwise the original image
    if (croppedFile != null) {
      return XFile(croppedFile.path);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        title: '프로필 사진 설정',
        icon: Icons.settings,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30, width: double.infinity),
          _buildPhotoArea(),
          const SizedBox(height: 20),
          _buildButton(),
        ],
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800)),
          onPressed: () async {
            if (_image != null) {
              var response = await MyInfoApi(
                      dio: Dio(), storage: const FlutterSecureStorage())
                  .postUserProfilePhoto(_image!);
              if (response == 200 && context.mounted) {
                Navigator.of(context).pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Color(0xFF3DB887),
                  content: Text('프로필 이미지 변경 성공!'),
                  duration: Duration(seconds: 3),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: const Color(0xFFD24B4E),
                  content: Text('사진 변경에 실패했습니다. 에러 : ${response.toString()}'),
                  duration: const Duration(seconds: 1),
                ));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Color(0xFFD24B4E),
                content: Text('사진 파일을 선택해주세요'),
                duration: Duration(seconds: 1),
              ));
            }
          },
          child: const Text('프로필 이미지 수정하기'),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? SizedBox(
            width: 300,
            height: 300,
            child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
          )
        : widget.profileImg != null
            ? SizedBox(
                width: 300,
                height: 300,
                child: Image.network(widget.profileImg!))
            : Container(
                width: 300,
                height: 300,
                color: Colors.grey,
                child: const Center(
                  child: Text('등록된 프로필 이미지가 없습니다'),
                ),
              );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800)),
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: const Row(
            children: [
              Icon(Icons.camera_alt_outlined),
              Text("  카메라"),
            ],
          ),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800)),
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: const Row(
            children: [
              Icon(Icons.photo_library_outlined),
              Text("  갤러리"),
            ],
          ),
        ),
      ],
    );
  }
}
