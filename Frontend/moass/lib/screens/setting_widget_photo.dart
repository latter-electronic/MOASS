import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/widgets/top_bar.dart';

class SettingWidgetPhotoScreen extends StatefulWidget {
  final String? profileImg;
  const SettingWidgetPhotoScreen({super.key, required this.profileImg});

  @override
  State<SettingWidgetPhotoScreen> createState() =>
      _SettingWidgetPhotoScreenState();
}

class _SettingWidgetPhotoScreenState extends State<SettingWidgetPhotoScreen> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담김
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        title: '위젯 사진 설정',
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
          onPressed: () async {
            await MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
                .postUserWidgetPhoto(_image!);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('위젯 이미지 수정하기'),
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
                child: Image.network(widget.profileImg.toString()))
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
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: const Text("카메라"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: const Text("갤러리"),
        ),
      ],
    );
  }
}
