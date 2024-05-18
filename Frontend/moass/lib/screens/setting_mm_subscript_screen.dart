import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/related_MM_account.dart';
import 'package:moass/services/mattermost_api.dart';
import 'package:moass/widgets/top_bar.dart';

class SettingMMSubscriptScreen extends StatefulWidget {
  const SettingMMSubscriptScreen({super.key});

  @override
  State<SettingMMSubscriptScreen> createState() =>
      _SettingMMSubscriptScreenState();
}

class _SettingMMSubscriptScreenState extends State<SettingMMSubscriptScreen> {
  late MatterMostApi api;
  List<MattermostTeam> teams = [];
  MattermostTeam? selectedTeam;

  @override
  void initState() {
    super.initState();
    api = MatterMostApi(dio: Dio(), storage: const FlutterSecureStorage());
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    var fetchedTeams = await api.fetchMatterMostChannels();
    setState(() {
      teams = fetchedTeams ?? [];
      // If selectedTeam exists, update its data from the newly fetched teams
      if (selectedTeam != null) {
        selectedTeam = teams.firstWhere(
          (team) => team.mmTeamId == selectedTeam!.mmTeamId,
          orElse: () => selectedTeam!,
        );
      }
    });
  }

  Future<void> handleSubscription(String channelId) async {
    var response = await api.connectMMchannel(channelId);
    if (response == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Color(0xFF3DB887),
        content: Text('채널 연동 변경 성공!'),
        duration: Duration(seconds: 3),
      ));
      await fetchTeams();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Color(0xFFD24B4E),
        content: Text('채널 연동 변경 실패'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        title: 'MM 채널 설정',
        icon: Icons.dashboard_outlined,
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(teams[index].mmTeamName),
                  selected: selectedTeam == teams[index],
                  onTap: () {
                    setState(() {
                      selectedTeam = teams[index];
                    });
                  },
                );
              },
            ),
          ),
          const VerticalDivider(),
          Expanded(
              child: selectedTeam == null
                  ? const Center(child: Text('알림을 받아올 채널을 선택해 주세요!'))
                  : ListView.builder(
                      itemCount: selectedTeam!.mmChannelList.length,
                      itemBuilder: (context, index) {
                        var channel = selectedTeam!.mmChannelList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1.0, vertical: 0.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: channel.isSubscribed
                                        ? const Color.fromARGB(
                                            255, 207, 228, 249)
                                        : Colors.white,
                                    elevation: 10.0,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0)),
                                    ),
                                    // side: const BorderSide(
                                    //   color: Colors.black,
                                    //   width: 1,
                                    // ),
                                  ),
                                  onPressed: () {
                                    handleSubscription(channel.mmChannelId);
                                  },
                                  child: Text(channel.channelName),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
        ],
      ),
    );
  }
}
