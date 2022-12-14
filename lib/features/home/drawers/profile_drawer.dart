import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({
    Key? key,
  }) : super(key: key);

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfile(
    BuildContext context,
    String uid,
  ) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

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
              radius: 70,
            ),
            const SizedBox(
              height: 10,
            ),
            // user name
            Text(
              'u/${user.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () => navigateToUserProfile(
                context,
                user.uid,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout_outlined,
                color: Pallete.redColor,
              ),
              title: const Text('Log Out'),
              onTap: () => logOut(ref),
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.dark,
              onChanged: (value) => toggleTheme(ref),
            ),
          ],
        ),
      ),
    );
  }
}
