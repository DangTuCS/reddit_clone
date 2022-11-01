import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_model.freezed.dart';

part 'community_model.g.dart';

@freezed
class CommunityModel with _$CommunityModel {
  const factory CommunityModel({
    required String id,
    required String name,
    required String banner,
    required String avatar,
    required List<String> members,
    required List<String> mods,
  }) = _CommunityModel;

  factory CommunityModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityModelFromJson(json);
}
