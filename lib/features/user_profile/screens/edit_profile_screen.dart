import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/user_profile/controller/user_profile_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;

  const EditProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          name: nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    return isLoading
        ? const Loader()
        : ref.watch(getUserDataProvider(widget.uid)).when(
              data: (user) => Scaffold(
                backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
                appBar: AppBar(
                  title: const Text('Edit Community'),
                  elevation: 0,
                  centerTitle: false,
                  actions: [
                    TextButton(
                      onPressed: save,
                      child: const Text('Save'),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: selectBannerImage,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(12),
                                dashPattern: const [10, 4],
                                strokeCap: StrokeCap.round,
                                color: Pallete.darkModeAppTheme.textTheme
                                    .bodyText2!.color!,
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: bannerFile != null
                                      ? Image.file(bannerFile!)
                                      : user.banner.isEmpty ||
                                              user.banner ==
                                                  Constants.bannerDefault
                                          ? const Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              ),
                                            )
                                          : Image.network(user.banner),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: GestureDetector(
                                onTap: selectProfileImage,
                                child: profileFile != null
                                    ? CircleAvatar(
                                        radius: 32,
                                        backgroundImage:
                                            FileImage(profileFile!),
                                      )
                                    : CircleAvatar(
                                        radius: 32,
                                        backgroundImage: NetworkImage(
                                          user.profilePic,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Name',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Pallete.blueColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stackTrace) => ErrorText(
                text: error.toString(),
              ),
              loading: () => const Loader(),
            );
  }
}
