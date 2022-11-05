import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // user avatar
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
            ),
            // user name
            Text('u/${user.name}'),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: (){},
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined,color: Colors.red,),
              title: const Text('Log Out'),
              onTap: (){},
            ),
            ToggleButtons(children: [], isSelected: [],),
          ],
        ),
      ),
    );
  }
}