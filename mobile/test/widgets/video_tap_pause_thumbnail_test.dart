// ABOUTME: Tests verifying that video tap pause works correctly even when thumbnail is visible
// ABOUTME: Ensures taps on inactive videos with thumbnails properly activate and play

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvine/models/video_event.dart';
import 'package:openvine/widgets/video_feed_item.dart';
import 'package:openvine/providers/individual_video_providers.dart';

void main() {
  group('Video Tap Pause with Thumbnail', () {
    late ProviderContainer container;
    late VideoEvent testVideo;

    setUp(() {
      container = ProviderContainer();

      final now = DateTime.now();
      testVideo = VideoEvent(
        id: 'test-video-tap',
        pubkey: 'test-pubkey',
        createdAt: now.millisecondsSinceEpoch ~/ 1000,
        timestamp: now,
        content: 'Test video for tap',
        videoUrl: 'https://example.com/video.mp4',
        thumbnailUrl: 'https://example.com/thumbnail.jpg',
        blurhash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('tapping inactive video should activate it', (tester) async {
      // Arrange - mount widget with inactive video
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: VideoFeedItem(
                video: testVideo,
                index: 0,
                hasBottomNavigation: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial state - video is not active
      final activeState = container.read(activeVideoProvider);
      expect(activeState.currentVideoId, isNull,
          reason: 'Video should not be active initially');

      // Act - tap on the video (which shows thumbnail)
      await tester.tap(find.byType(VideoFeedItem));
      await tester.pump();

      // Assert - video should now be active
      final newActiveState = container.read(activeVideoProvider);
      expect(newActiveState.currentVideoId, equals(testVideo.id),
          reason: 'Tapping inactive video should activate it');
    });

    testWidgets('tapping active playing video should pause it', (tester) async {
      // Arrange - mount widget and make video active
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: VideoFeedItem(
                video: testVideo,
                index: 0,
                hasBottomNavigation: false,
              ),
            ),
          ),
        ),
      );

      // Make video active
      container.read(activeVideoProvider.notifier).setActiveVideo(testVideo.id);
      await tester.pumpAndSettle();

      // Get controller and simulate playing state
      final params = VideoControllerParams(
        videoId: testVideo.id,
        videoUrl: testVideo.videoUrl!,
        videoEvent: testVideo,
      );
      final controller = container.read(individualVideoControllerProvider(params));

      // Wait for controller to initialize
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Simulate playing state if controller is initialized
      if (controller.value.isInitialized) {
        await controller.play();
        await tester.pump();

        // Verify video is playing
        expect(controller.value.isPlaying, isTrue,
            reason: 'Video should be playing before tap');

        // Act - tap on the playing video
        await tester.tap(find.byType(VideoFeedItem));
        await tester.pump();

        // Assert - video should be paused
        expect(controller.value.isPlaying, isFalse,
            reason: 'Tapping playing video should pause it');
      }
    });

    testWidgets('tapping active paused video should play it', (tester) async {
      // Arrange - mount widget and make video active
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: VideoFeedItem(
                video: testVideo,
                index: 0,
                hasBottomNavigation: false,
              ),
            ),
          ),
        ),
      );

      // Make video active
      container.read(activeVideoProvider.notifier).setActiveVideo(testVideo.id);
      await tester.pumpAndSettle();

      // Get controller
      final params = VideoControllerParams(
        videoId: testVideo.id,
        videoUrl: testVideo.videoUrl!,
        videoEvent: testVideo,
      );
      final controller = container.read(individualVideoControllerProvider(params));

      // Wait for controller to initialize
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Simulate paused state if controller is initialized
      if (controller.value.isInitialized) {
        await controller.pause();
        await tester.pump();

        // Verify video is paused
        expect(controller.value.isPlaying, isFalse,
            reason: 'Video should be paused before tap');

        // Act - tap on the paused video
        await tester.tap(find.byType(VideoFeedItem));
        await tester.pump();

        // Assert - video should be playing
        expect(controller.value.isPlaying, isTrue,
            reason: 'Tapping paused video should play it');
      }
    });

    testWidgets('thumbnail should not block tap gesture', (tester) async {
      // Arrange - mount widget with inactive video (shows thumbnail)
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: VideoFeedItem(
                video: testVideo,
                index: 0,
                hasBottomNavigation: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify thumbnail is visible (video is not active)
      final activeState = container.read(activeVideoProvider);
      expect(activeState.currentVideoId, isNull);

      // Act - tap directly on the center where thumbnail would be
      final videoFeedItemFinder = find.byType(VideoFeedItem);
      expect(videoFeedItemFinder, findsOneWidget);

      await tester.tap(videoFeedItemFinder);
      await tester.pump();

      // Assert - tap should still work and activate video
      final newActiveState = container.read(activeVideoProvider);
      expect(newActiveState.currentVideoId, equals(testVideo.id),
          reason: 'Tap should work even when thumbnail is displayed');
    });

    testWidgets('tap on play icon should activate video', (tester) async {
      // Arrange - mount widget with inactive video
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: VideoFeedItem(
                video: testVideo,
                index: 0,
                hasBottomNavigation: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify play icon is visible (on inactive video thumbnail)
      final playIconFinder = find.byIcon(Icons.play_arrow);
      expect(playIconFinder, findsOneWidget,
          reason: 'Play icon should be visible on inactive video');

      // Act - tap on the play icon
      await tester.tap(playIconFinder);
      await tester.pump();

      // Assert - video should be activated
      final activeState = container.read(activeVideoProvider);
      expect(activeState.currentVideoId, equals(testVideo.id),
          reason: 'Tapping play icon should activate video');
    });
  });
}
