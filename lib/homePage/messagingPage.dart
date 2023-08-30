import 'package:flutter/material.dart';

class messagingPage extends StatefulWidget {
  messagingPage({Key? key}) : super(key: key);

  @override
  State<messagingPage> createState() => _messagingPage();
}

// https://docs.flutter.dev/cookbook/lists/mixed-list

class _messagingPage extends State<messagingPage> {

  late List<String> groupchatTitles = [];
  late List<String> groupchatLastMessage = [];

  // Adding titles and list item body manually. TODO: Implement firebase to show different messages.
  void addToLists() {
    List<String> titles = ["The Boys", "Andrew", "Bob"];
    groupchatTitles.addAll(titles);
    List<String> body = ["Hey what's up, guys?", "Hey Andrew, can you take out the trash?", "Bob, please take a shower."];
    groupchatLastMessage.addAll(body);
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {

    // Clearing the lists.
    groupchatTitles = [];
    groupchatLastMessage = [];

    // Adding to the lists.
    addToLists();

    // Creating list items.
    final items = List<ListItem>.generate(
      groupchatTitles.length,
          (i) => i % 6 == 0
          ? MessageItem(groupchatTitles[i], groupchatLastMessage[i])
          : MessageItem(groupchatTitles[i], groupchatLastMessage[i]),
    );

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: const Text("Messaging"),
      ),
      backgroundColor:  Color.fromARGB(255, 227, 227, 227),

      body: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: items.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          final item = items[index];

          return ListTile(
            tileColor: Colors.orange,
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context),
          );
        },
      ),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}