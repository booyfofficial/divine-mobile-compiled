// ABOUTME: Tests verifying that video thumbnails always render as square (1:1 aspect ratio)
// ABOUTME: Ensures 480x480 videos display correctly with proper aspect ratio

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openvine/models/video_event.dart';
import 'package:openvine/widgets/video_thumbnail_widget.dart';

void main() {
  group('VideoThumbnailWidget Aspect Ratio', () {
    late VideoEvent testVideo;

    setUp(() {
      final now = DateTime.now();
      testVideo = VideoEvent(
        id: 'test-video-id',
        pubkey: 'test-pubkey',
        createdAt: now.millisecondsSinceEpoch ~/ 1000,
        timestamp: now,
        content: 'Test video',
        videoUrl: 'https://example.com/video.mp4',
        thumbnailUrl: 'https://example.com/thumbnail.jpg',
        blurhash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
      );
    });

    testWidgets('thumbnail should maintain 1:1 aspect ratio for square videos',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: VideoThumbnailWidget(
                video: testVideo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the AspectRatio widget that should enforce 1:1 ratio
      final aspectRatioFinder = find.byType(AspectRatio);
      expect(aspectRatioFinder, findsOneWidget,
          reason: 'Thumbnail should be wrapped in AspectRatio widget');

      // Verify the aspect ratio is 1:1 (square)
      final aspectRatioWidget = tester.widget<AspectRatio>(aspectRatioFinder);
      expect(aspectRatioWidget.aspectRatio, equals(1.0),
          reason: 'Thumbnail aspect ratio should be 1.0 (square) for 480x480 videos');
    });

    testWidgets('thumbnail with explicit width should be square',
        (tester) async {
      const thumbnailWidth = 200.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoThumbnailWidget(
              video: testVideo,
              width: thumbnailWidth,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find AspectRatio widget
      final aspectRatioFinder = find.byType(AspectRatio);
      expect(aspectRatioFinder, findsOneWidget);

      // Verify square aspect ratio
      final aspectRatioWidget = tester.widget<AspectRatio>(aspectRatioFinder);
      expect(aspectRatioWidget.aspectRatio, equals(1.0));
    });

    testWidgets('thumbnail with explicit height should be square',
        (tester) async {
      const thumbnailHeight = 300.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoThumbnailWidget(
              video: testVideo,
              height: thumbnailHeight,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find AspectRatio widget
      final aspectRatioFinder = find.byType(AspectRatio);
      expect(aspectRatioFinder, findsOneWidget);

      // Verify square aspect ratio
      final aspectRatioWidget = tester.widget<AspectRatio>(aspectRatioFinder);
      expect(aspectRatioWidget.aspectRatio, equals(1.0));
    });

    testWidgets('thumbnail with play icon should maintain aspect ratio',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoThumbnailWidget(
              video: testVideo,
              showPlayIcon: true,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify AspectRatio widget exists
      expect(find.byType(AspectRatio), findsOneWidget);

      // Verify play icon is present
      expect(find.byIcon(Icons.play_arrow), findsOneWidget,
          reason: 'Play icon should be visible on thumbnail');
    });

    testWidgets('thumbnail with blurhash fallback should be square',
        (tester) async {
      final now = DateTime.now();
      final videoWithBlurhash = VideoEvent(
        id: 'test-video-blurhash',
        pubkey: 'test-pubkey',
        createdAt: now.millisecondsSinceEpoch ~/ 1000,
        timestamp: now,
        content: 'Test video with blurhash',
        videoUrl: 'https://example.com/video.mp4',
        thumbnailUrl: null, // No thumbnail URL, should use blurhash
        blurhash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoThumbnailWidget(
              video: videoWithBlurhash,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Even with blurhash fallback, should maintain square aspect ratio
      expect(find.byType(AspectRatio), findsOneWidget);

      final aspectRatioWidget =
          tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatioWidget.aspectRatio, equals(1.0));
    });
  });
}
