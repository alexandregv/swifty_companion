import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final loginFieldController= TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    loginFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fluttery Companion'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align to left
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Center(
                  child: Image(
                    image: AssetImage("assets/images/42paris.png"),
                    height: 150,
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: loginFieldController,
                textInputAction: TextInputAction.search,
                onSubmitted: (String login) => Navigator.pushNamed(context, '/users', arguments: login.toLowerCase()),
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp(r'[a-zA-Z0-9\-]'), allow: true),
                ],
                autofocus: true,
                autocorrect: false,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.none,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a 42 student login',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/users', arguments: loginFieldController.text.toLowerCase());
                  loginFieldController.clear();
                },
                icon: const Icon(Icons.search),
                label: const Text('Search'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
              ),
            ),
          ],
        )
    );
  }

}
