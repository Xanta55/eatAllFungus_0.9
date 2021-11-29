import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/providers/streams/profileStream.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends HookWidget {
  final String? profileID;
  const ProfileScreen({Key? key, this.profileID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PROFILE'),
        ),
        body: ProfileWidget(
          profileID: profileID,
        ));
  }
}

class ProfileWidget extends HookWidget {
  final String? profileID;
  const ProfileWidget({Key? key, this.profileID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final foreignProfile = useProvider(profileControllerProvider.notifier)
        .grabProfile(
            profileID: profileID ?? useProvider(profileStreamProvider)!.id!);
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Panel(
                child: Container(
                  color: Colors.grey[colorIntensity],
                  child: FutureBuilder(
                    future: foreignProfile,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final profile = snapshot.data as UserProfile;
                        return Center(
                          child: Text('${profile.name}'),
                        );
                      } else {
                        return Center(
                          child: Text('Loading...'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Panel(
                child: Container(
                  color: Colors.grey[colorIntensity],
                  child: FutureBuilder(
                    future: foreignProfile,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final profile = snapshot.data as UserProfile;
                        return Center(
                          child: Text('${profile.description}'),
                        );
                      } else {
                        return Center(
                          child: Text('Loading...'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Panel(
                child: Container(
                  color: Colors.grey[colorIntensity],
                  child: FutureBuilder(
                    future: foreignProfile,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final profile = snapshot.data as UserProfile;
                        return Center(
                          child: Text('${profile.survivedDays}'),
                        );
                      } else {
                        return Center(
                          child: Text('Loading...'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
