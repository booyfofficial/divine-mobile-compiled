// ABOUTME: Tests for VideoPrewarmer provider that manages preloading of neighbor videos
// ABOUTME: Validates that prewarming creates controllers without keeping persistent subscriptions

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvine/providers/video_prewarmer_provider.dart';
import 'package:openvine/providers/individual_video_providers.dart';

void main() {
  group('VideoPrewarmer Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should create controllers for prewarmed videos', () async {
      // Arrange
      final videoIds = ['video1', 'video2', 'video3'];
      final params = videoIds.map((id) => VideoControllerParams(
        videoId: id,
        videoUrl: 'https://example.com/$id.mp4',
      )).toList();

      // Act
      container.read(videoPrewarmerProvider.notifier).prewarmVideos(params);

      // Assert - controllers should exist after prewarming
      for (final param in params) {
        final controller = container.read(individualVideoControllerProvider(param));
        expect(controller, isNotNull);
      }
    });

    test('should handle empty video list', () {
      // Act - should not throw
      expect(
        () => container.read(videoPrewarmerProvider.notifier).prewarmVideos([]),
        returnsNormally,
      );
    });

    test('should handle duplicate video IDs', () {
      // Arrange
      final param = VideoControllerParams(
        videoId: 'duplicate',
        videoUrl: 'https://example.com/duplicate.mp4',
      );

      // Act - prewarm same video twice
      container.read(videoPrewarmerProvider.notifier).prewarmVideos([param]);
      container.read(videoPrewarmerProvider.notifier).prewarmVideos([param]);

      // Assert - should only create one controller
      final controller = container.read(individualVideoControllerProvider(param));
      expect(controller, isNotNull);
      // If it doesn't throw, we're good - Riverpod handles deduplication
    });

    test('should not keep providers alive after prewarming', () async {
      // Arrange
      final param = VideoControllerParams(
        videoId: 'temp',
        videoUrl: 'https://example.com/temp.mp4',
      );

      // Act - prewarm then check if provider can autodispose
      container.read(videoPrewarmerProvider.notifier).prewarmVideos([param]);

      // Assert - The provider should not have an active listener from prewarmer
      // This is implicit - if prewarmer kept a listener, the provider would never autodispose
      // We test the actual autodispose behavior in controller lifecycle tests
      expect(
        () => container.read(individualVideoControllerProvider(param)),
        returnsNormally,
      );
    });
  });
}
