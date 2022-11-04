import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chuck/models/tab/tab.dart';
import 'package:chuck/pages/random/random_jokes_page.dart';
import 'package:chuck/pages/saved/saved_jokes_page.dart';
import 'package:chuck/pages/saved/saved_jokes_logic.dart';
import 'package:chuck/pages/search_textfield/search_jokes_textfield_page.dart';
import 'package:chuck/pages/categories_list/categories_jokes_list_page.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chuck Norris Tinder')),
      body: Center(
          child: Column(children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/images/chuck_orange.png'),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.add_reaction),
                title: const Text('Random Jokes'),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                onTap: () {
                  final tab = ref.watch(tabProvider.notifier);
                  tab.setTab(TabType.random);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RandomJokesPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_shopping_cart_rounded),
                title: const Text('Saved'),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                onTap: () {
                  final tab = ref.watch(tabProvider.notifier);
                  tab.setTab(TabType.saved);
                  SavedJokesLogic.fetch();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SavedJokesPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search'),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                onTap: () {
                  final tab = ref.watch(tabProvider.notifier);
                  tab.setTab(TabType.search);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SearchJokesTextfieldPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.api),
                title: const Text('Categories'),

                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                onTap: () {
                  final tab = ref.watch(tabProvider.notifier);
                  tab.setTab(TabType.categories);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CategoriesJokesListPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete all'),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text("Delete Saved?"),
                        content: const Text(
                            "Do you want to delete all saved jokes?"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              SavedJokesLogic.delete();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("All jokes had been deleted")));
                            },
                          ),
                          TextButton(
                            child: const Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ]);
                  },
                ),
              )
            ],
          ),
        ),
      ])),
    );
  }
}
