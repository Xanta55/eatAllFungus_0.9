import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/providers/streams/profileStream.dart';
import 'package:eat_all_fungus/views/metaGame/messageScreen.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/heroWidget.dart';
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
          Row(
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final profile = snapshot.data as UserProfile;
                            return Center(
                              child: Column(
                                children: [
                                  Text('Username:'),
                                  Text(
                                    '${profile.name}',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
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
              FutureBuilder(
                  future: foreignProfile,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      final profile = snapshot.data as UserProfile;
                      if (profile.id !=
                          context.read(profileStreamProvider)!.id) {
                        return IconButton(
                          onPressed: () => Navigator.of(context)
                              .push(HeroDialogRoute(builder: (context) {
                            return SendMessagePopup(profile.id!);
                          })),
                          icon: Icon(Icons.mail),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.mail),
                      );
                    }
                  }),
            ],
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
