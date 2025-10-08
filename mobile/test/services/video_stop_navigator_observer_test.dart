// ABOUTME: Tests for VideoStopNavigatorObserver pausing videos on modal/route navigation
// ABOUTME: Validates that videos pause when navigating to comments, share menu, or other modals

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvine/services/video_stop_navigator_observer.dart';
import 'package:openvine/providers/individual_video_providers.dart';

void main() {
  group('VideoStopNavigatorObserver Widget Tests', () {
    testWidgets('should clear active video when modal is pushed', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final observer = VideoStopNavigatorObserver();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            navigatorObservers: [observer],
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    // Open a modal
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const Scaffold(body: Text('Modal')),
                      ),
                    );
                  },
                  child: const Text('Open Modal'),
                ),
              ),
            ),
          ),
        ),
      );

      // Set video as active
      container.read(activeVideoProvider.notifier).setActiveVideo('test-video-1');
      await tester.pump();
      expect(container.read(activeVideoProvider).currentVideoId, 'test-video-1');

      // Act - open modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Assert - active video should be cleared
      expect(container.read(activeVideoProvider).currentVideoId, isNull,
          reason: 'Active video should be cleared when modal opens');
    });

    testWidgets('should not clear active video when modal is popped', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final observer = VideoStopNavigatorObserver();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            navigatorObservers: [observer],
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          body: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      // Set video as active before opening modal
      container.read(activeVideoProvider.notifier).setActiveVideo('test-video-2');
      await tester.pump();

      // Open modal (this will clear active video)
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Video should have been cleared when modal opened
      expect(container.read(activeVideoProvider).currentVideoId, isNull);

      // Set video active again (simulating video reactivation)
      container.read(activeVideoProvider.notifier).setActiveVideo('test-video-2');
      await tester.pump();

      // Act - close modal
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Assert - active video should REMAIN (not be cleared when returning to feed)
      expect(container.read(activeVideoProvider).currentVideoId, 'test-video-2',
          reason: 'Active video should remain when returning from modal');
    });
  });
}
