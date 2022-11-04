import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:chuck/models/joke/joke.dart';
import 'package:chuck/models/reaction/reaction.dart';
import 'package:chuck/pages/saved/saved_jokes_logic.dart';
import 'package:chuck/pages/search/search_jokes_logic.dart';

class SearchJokesPage extends ConsumerStatefulWidget {
  final String searchQuery;

  const SearchJokesPage({super.key, required this.searchQuery});

  @override
  ConsumerState<SearchJokesPage> createState() => SearchJokesPageState();
}

class SearchJokesPageState extends ConsumerState<SearchJokesPage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    SearchJokesLogic.fetch(widget.searchQuery);
    pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  void _onButtonLike() {
    setState(() {
      SearchJokesLogic.getJoke(pageController.page!.round())
          .then((joke) => joke.reaction = Reaction.like);
      SavedJokesLogic.store();
      pageController.animateToPage(pageController.page!.round() + 1,
          duration: const Duration(seconds: 1), curve: Curves.elasticInOut);
    });
  }

  void _onButtonSave() async {
    Joke? joke = await SearchJokesLogic.getJoke(pageController.page!.round());
    if (!mounted) return;
    await SavedJokesLogic.addJoke(joke).then((n) {
      if (n) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("The joke is saved")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("This joke is already saved")));
      }
    });
  }

  void _onButtonDislike() {
    setState(() {
      SearchJokesLogic.getJoke(pageController.page!.round())
          .then((joke) => joke.reaction = Reaction.dislike);
      SavedJokesLogic.store();
      pageController.animateToPage(pageController.page!.round() + 1,
          duration: const Duration(seconds: 1), curve: Curves.elasticInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(title: const Text('Search Jokes')),
            body: Center(
                child: Column(children: [
              Expanded(
                flex: 4,
                child: PageView.builder(
                  controller: pageController,
                  itemBuilder: (context, i) {
                    return FutureBuilder<Joke>(
                      future: SearchJokesLogic.getJoke(i),
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
                  Spacer(),
                  ElevatedButton(
                    onPressed: _onButtonLike,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.thumb_up),
                    ),

                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _onButtonSave,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: const Icon(Icons.turned_in_not),
                    ),

                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _onButtonDislike,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: const Icon(Icons.thumb_down),
                    ),

                  ),
                  Spacer(),
                ])));
  }
}
