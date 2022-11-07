import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolScreen extends StatelessWidget {
  final String name;

  const ModToolScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  void navigateToEditScreen(BuildContext context){
    Routemaster.of(context).push('/edit-community/$name');
  }

  void navigateToAddModScreen(BuildContext context){
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tool'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add Moderators'),
            onTap: () => navigateToAddModScreen(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit community'),
            onTap: () => navigateToEditScreen(context),
          ),
        ],
      ),
    );
  }
}
