import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/services/myinfo_api.dart';

// MyInfoApi 인스턴스를 위한 Provider
final myInfoApiProvider = Provider<MyInfoApi>((ref) {
  return MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage());
});

// MyProfile 상태를 관리하는 Provider
final profileProvider =
    StateNotifierProvider<ProfileNotifier, MyProfile?>((ref) {
  return ProfileNotifier(ref);
});

// ProfileNotifier 구현
class ProfileNotifier extends StateNotifier<MyProfile?> {
  final Ref ref; // 'Ref' 객체로 명명 변경

  // 생성자에서 API 요청
  ProfileNotifier(this.ref) : super(null) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final api = ref.read(myInfoApiProvider); // ref 객체 사용하여 다른 프로바이더 접근
    try {
      final profile = await api.fetchUserProfile();
      if (profile != null) {
        state = profile; // 상태 업데이트
      }
    } catch (e) {
      print("Failed to fetch profile: $e");
    }
  }
}
