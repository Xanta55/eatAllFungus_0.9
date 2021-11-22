import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/controllers/radioController.dart';
import 'package:eat_all_fungus/models/radio/forum.dart';
import 'package:eat_all_fungus/models/radio/radioPost.dart';
import 'package:eat_all_fungus/models/radio/thread.dart';
import 'package:eat_all_fungus/views/inGame/radio/createPopups/radioPostPopup.dart';
import 'package:eat_all_fungus/views/inGame/radio/createPopups/radioThreadPopup.dart';
import 'package:eat_all_fungus/views/inGame/radio/radioWidget.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/heroWidget.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class RadioSubWidget extends HookWidget {
  const RadioSubWidget({
    Key? key,
    required this.forums,
  }) : super(key: key);

  final List<String> forums;

  @override
  Widget build(BuildContext context) {
    final forumsFutures = useProvider(radioControllerProvider.notifier)
        .getForums(forumIDs: forums);
    return Column(
      children: [
        Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Radio Channels',
                style: Theme.of(context).textTheme.headline4,
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: FutureBuilder(
                      future: forumsFutures,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          final forumObjects = snapshot.data as List<Forum>;
                          return ListView.separated(
                            padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            itemCount: forumObjects.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Panel(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      context.read(currentForumProvider).state =
                                          forumObjects[index];
                                    },
                                    child: Container(
                                      //color: Colors.grey[colorIntensity],
                                      child: ListTile(
                                        title: Text(forumObjects[index].title),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                color: Theme.of(context).dividerColor,
                                thickness: 2.0,
                              );
                            },
                          );
                        } else {
                          return Panel(
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                //color: Colors.grey[colorIntensity],
                                child: ListTile(
                                  title: Text('Loading Channels...'),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ForumSubWidget extends HookWidget {
  const ForumSubWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final threads =
        useProvider(radioControllerProvider.notifier).getThreadsInForum();
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    context.read(currentForumProvider).state =
                        Forum(id: '', title: '');
                  },
                  icon: Icon(Icons.arrow_back)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Current Topics',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(
              child: Container(
                color: Colors.grey[colorIntensity],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: FutureBuilder(
                      future: threads,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          final readyThreads = snapshot.data as List<Thread>;
                          return ListView.separated(
                            padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            itemCount: readyThreads.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Panel(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read(currentThreadProvider)
                                          .state = readyThreads[index];
                                    },
                                    child: Container(
                                      //color: Colors.grey[colorIntensity],
                                      child: ListTile(
                                        title: Text(readyThreads[index].title),
                                        subtitle: Text(
                                          '${DateFormat('EEEE').format(readyThreads[index].lastUpdate)} ${readyThreads[index].lastUpdate.day}-${readyThreads[index].lastUpdate.month} ${readyThreads[index].lastUpdate.hour.toString().padLeft(2, '0')}:${readyThreads[index].lastUpdate.minute.toString().padLeft(2, '0')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                color: Theme.of(context).dividerColor,
                                thickness: 2.0,
                              );
                            },
                          );
                        } else {
                          return Panel(
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                //color: Colors.grey[colorIntensity],
                                child: ListView(children: [
                                  ListTile(
                                    title: Text('Loading Threads...'),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return RadioThreadPopup();
                  }));
                },
                child: Container(
                  color: Colors.amber,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Create new topic',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ThreadSubWidget extends HookWidget {
  const ThreadSubWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thread = useProvider(currentThreadProvider).state;
    final posts = useProvider(radioControllerProvider);
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    context.read(currentThreadProvider).state =
                        Thread(title: '', id: '', lastUpdate: DateTime.now());
                  },
                  icon: Icon(Icons.arrow_back)),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    thread.title,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(
              child: Container(
                color: Colors.grey[colorIntensity],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: FutureBuilder(
                      future: posts,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          final readyPosts = snapshot.data as List<RadioPost>;
                          return ListView.separated(
                            padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            itemCount: readyPosts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Panel(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              readyPosts[index].playerID,
                                              style: TextStyle(
                                                  color: Colors.amber[700],
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 15.0, 0.0, 15.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                readyPosts[index].content,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      '${readyPosts[index].timeOfPost.hour.toString().padLeft(2, '0')}:${readyPosts[index].timeOfPost.minute.toString().padLeft(2, '0')}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption),
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                      '${readyPosts[index].timeOfPost.day}-${readyPosts[index].timeOfPost.month}-${readyPosts[index].timeOfPost.year}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                color: Theme.of(context).dividerColor,
                                thickness: 2.0,
                              );
                            },
                          );
                        } else {
                          return Panel(
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                //color: Colors.grey[colorIntensity],
                                child: ListView(children: [
                                  ListTile(
                                    title: Text('Loading Posts...'),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return RadioPostPopup();
                  }));
                },
                child: Container(
                  color: Colors.amber,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Answer',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
