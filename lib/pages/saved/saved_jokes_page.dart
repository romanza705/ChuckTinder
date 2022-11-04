import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:chuck/models/joke/joke.dart';
import 'package:chuck/models/reaction/reaction.dart';
import 'package:chuck/models/tab/tab.dart';
import 'package:chuck/pages/saved/saved_jokes_logic.dart';

class SavedJokesPage extends ConsumerStatefulWidget {
  const SavedJokesPage({super.key});

  @override
  ConsumerState<SavedJokesPage> createState() => SavedJokesPageState();
}

class SavedJokesPageState extends ConsumerState<SavedJokesPage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  Future<bool> _onWillPop() async {
    final tab = ref.watch(tabProvider.notifier);
    tab.setTab(TabType.menu);
    return true;
  }

  void _onButtonLike() {
    setState(() {
      SavedJokesLogic.getJoke(pageController.page!.round())
          .then((joke) => joke.reaction = Reaction.like);
      SavedJokesLogic.store();
      pageController.animateToPage(pageController.page!.round() + 1,
          duration: const Duration(seconds: 1), curve: Curves.elasticInOut);
    });
  }

  void _onButtonDelete() {
    setState(() {
      SavedJokesLogic.deleteJoke(pageController.page!.round());
    });
  }

  void _onButtonDislike() {
    setState(() {
      SavedJokesLogic.getJoke(pageController.page!.round())
          .then((joke) => joke.reaction = Reaction.dislike);
      SavedJokesLogic.store();
      pageController.animateToPage(pageController.page!.round() + 1,
          duration: const Duration(seconds: 1), curve: Curves.elasticInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    SavedJokesLogic.fetch();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(title: const Text('Saved Jokes')),
            body: Center(
                child: Column(children: [

              Expanded(
                flex: 4,
                child: PageView.builder(
                  controller: pageController,
                  itemBuilder: (context, i) {
                    return FutureBuilder<Joke>(
                      future: SavedJokesLogic.getJoke(i),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 32,
                                    height: 80,),
                                  Text(
                                    snapshot.data!.text,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  const SizedBox(
                                    width: 32,
                                    height: 60,),

                                  reactionToIcon(snapshot.data!.reaction),
                                ],
                              ));
                        } else if (snapshot.hasError) {
                          return Text(
                            "Could not download joke: Chuck Norris had stolen your data packets",
                            style: Theme.of(context).textTheme.headline6,
                          );
                        }
                        return const Center(
                            child: SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(),
                        ));
                      },
                    );
                  },
                ),
              ),
            ])),
            bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _onButtonLike,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: const Icon(Icons.thumb_up),
                    ),

                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _onButtonDelete,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: const Icon(Icons.delete),
                    ),

                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _onButtonDislike,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: const Icon(Icons.thumb_down),
                    ),


                  ),
                  const Spacer(),
                ]),

        ));
  }
}
