import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;

  const EditCommunityScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

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

  void save(CommunityModel community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          community: community,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return isLoading
        ? const Loader()
        : ref.watch(getCommunityByNameProvider(widget.name)).when(
              data: (community) => Scaffold(
                backgroundColor: currentTheme.backgroundColor,
                appBar: AppBar(
                  title: const Text('Edit Community'),
                  elevation: 0,
                  centerTitle: false,
                  actions: [
                    TextButton(
                      onPressed: () => save(community),
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
                                      : community.banner.isEmpty ||
                                              community.banner ==
                                                  Constants.bannerDefault
                                          ? const Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              ),
                                            )
                                          : Image.network(community.banner),
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
                                          community.avatar,
                                        ),
                                      ),
                              ),
                            ),
                          ],
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
