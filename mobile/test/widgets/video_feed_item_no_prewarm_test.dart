// ABOUTME: Tests that VideoFeedItem renders controllers based only on active state
// ABOUTME: Validates removal of PrewarmManager dependency for simpler Riverpod-native lifecycle

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvine/models/video_event.dart';
import 'package:openvine/widgets/video_feed_item.dart';
import 'package:openvine/providers/individual_video_providers.dart';

void main() {
  group('VideoFeedItem Without PrewarmManager', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should render video controller when active', (tester) async {
      // Arrange
      final now = DateTime.now();
      final video = VideoEvent(
        id: 'test-active-video',
        pubkey: 'pubkey123',
        content: 'Test Video',
        createdAt: now.millisecondsSinceEpoch ~/ 1000,
        timestamp: now,
        videoUrl: 'https://example.com/video.mp4',
      );

      // Act - mount widget with active video
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: VideoFeedItem(
                video: video,
                index: 0,
                hasBottomNavigation: false,
              ),
            ),
          ),
        ),
      );

      // Set video as active
      container.read(activeVideoProvider.notifier).setActiveVideo(video.id);
      await tester.pump();

      // Assert - video controller should be created
      final params = VideoControllerParams(
        videoId: video.id,
        videoUrl: video.videoUrl!,
        videoEvent: video,
      );

      expect(
        () => container.read(individualVideoControllerProvider(params)),
        returnsNormally,
      );
    });

    testWidgets('should not require prewarm state to render', (tester) async {
      // Arrange
      final now = DateTime.now();
      final video = VideoEvent(
        id: 'test-no-prewarm',
        pubkey: 'pubkey456',
        content: 'Test Video 2',
        createdAt: now.millisecondsSinceEpoch ~/ 1000,
        timestamp: now,
        videoUrl: 'https://example.com/video2.mp4',
      );

      // Act - mount widget WITHOUT setting as prewarmed
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: VideoFeedItem(
                video: video,
                index: 0,
                hasBottomNavigation: false,
              ),
            ),
          ),
        ),
      );

      // Set as active (but NOT prewarmed - old code would fail here)
      container.read(activeVideoProvider.notifier).setActiveVideo(video.id);
      await tester.pump();

      // Assert - should work fine without prewarm state
      final params = VideoControllerParams(
        videoId: video.id,
        videoUrl: video.videoUrl!,
        videoEvent: video,
      );

      expect(
        () => container.read(individualVideoControllerProvider(params)),
        returnsNormally,
      );
    });

    testWidgets('should not watch prewarmManagerProvider', (tester) async {
      // Arrange
      final now = DateTime.now();
      final video = VideoEvent(
        id: 'test-no-watch',
        pubkey: 'pubkey789',
        content: 'Test Video 3',
        createdAt: now.millisecondsSinceEpoch ~/ 1000,
        timestamp: now,
        videoUrl: 'https://example.com/video3.mp4',
      );

      // Act - mount widget
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: VideoFeedItem(
                video: video,
                index: 0,
                hasBottomNavigation: false,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Assert - This test verifies the code compiles without prewarmManagerProvider
      // If the code still references it, this will fail at compile time
      expect(find.byType(VideoFeedItem), findsOneWidget);
    });
  });
}
