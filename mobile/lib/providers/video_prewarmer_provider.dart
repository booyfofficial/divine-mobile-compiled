// ABOUTME: VideoPrewarmer provider manages preloading of neighbor videos in feeds
// ABOUTME: Uses ref.read() to trigger controller creation without keeping persistent subscriptions

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:openvine/providers/individual_video_providers.dart';

part 'video_prewarmer_provider.g.dart';

@riverpod
class VideoPrewarmer extends _$VideoPrewarmer {
  @override
  void build() {
    // Stateless provider - no state needed
  }

  /// Prewarm video controllers for the given list of videos
  /// This triggers controller initialization without keeping them alive
  void prewarmVideos(List<VideoControllerParams> params) {
    for (final param in params) {
      // ref.read() creates the provider if it doesn't exist
      // but doesn't establish a listener, so the controller can autodispose
      ref.read(individualVideoControllerProvider(param));
    }
  }
}
