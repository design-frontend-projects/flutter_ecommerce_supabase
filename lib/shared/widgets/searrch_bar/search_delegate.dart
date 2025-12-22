import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  final List<String> data = ['Apple', 'Banana', 'Orange'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
    data.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView(
      children: results.map((e) => ListTile(title: Text(e))).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
