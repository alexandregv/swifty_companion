import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:english_words/english_words.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swifty Companion',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final _alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.deepPurple : null,
      ),
      onTap: () => setState(() => _alreadySaved ? _saved.remove(pair) : _saved.add(pair)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
   Navigator.of(context).push(
     CupertinoPageRoute(
       builder: (BuildContext context) {
         final tiles = _saved.map(
           (WordPair pair) {
             return ListTile(
               title: Text(
                 pair.asPascalCase,
                 style: _biggerFont,
               ),
             );
           },
         );
         final divided = ListTile.divideTiles(
           context: context,
           tiles: tiles,
         ).toList();

         return Scaffold(
           appBar: AppBar(
             title: const Text('Saved Suggestions'),
           ),
           body: ListView(children: divided),
         );
       },
     ),
   );
  }
}
