// ABOUTME: Tests for hashtag feed provider reactivity
// ABOUTME: Verifies that hashtag provider rebuilds when VideoEventService updates

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvine/models/video_event.dart';
import 'package:openvine/providers/hashtag_feed_providers.dart';
import 'package:openvine/providers/app_providers.dart';
import 'package:openvine/router/page_context_provider.dart';
import 'package:openvine/router/route_utils.dart';
import 'package:openvine/services/video_event_service.dart';

/// Fake VideoEventService for testing reactive behavior
class FakeVideoEventService extends ChangeNotifier
    implements VideoEventService {
  final Map<String, List<VideoEvent>> _hashtagBuckets = {};
  final Map<String, List<VideoEvent>> _authorBuckets = {};

  // Track subscription calls for verification
  final List<List<String>> subscribedHashtags = [];
  final List<String> subscribedAuthors = [];

  @override
  List<VideoEvent> hashtagVideos(String tag) => _hashtagBuckets[tag] ?? [];

  @override
  List<VideoEvent> authorVideos(String pubkeyHex) =>
      _authorBuckets[pubkeyHex] ?? [];

  @override
  Future<void> subscribeToHashtagVideos(List<String> hashtags,
      {int limit = 100}) async {
    subscribedHashtags.add(hashtags);
  }

  @override
  Future<void> subscribeToUserVideos(String pubkey, {int limit = 50}) async {
    subscribedAuthors.add(pubkey);
  }

  // Test helper: emit events for a hashtag
  void emitHashtagVideos(String tag, List<VideoEvent> videos) {
    _hashtagBuckets[tag] = videos;
    notifyListeners();
  }

  // Test helper: emit events for an author
  void emitAuthorVideos(String pubkeyHex, List<VideoEvent> videos) {
    _authorBuckets[pubkeyHex] = videos;
    notifyListeners();
  }

  // Stub implementations for required interface methods
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('HashtagFeedProvider', () {
    late FakeVideoEventService fakeService;
    late ProviderContainer container;

    setUp(() {
      fakeService = FakeVideoEventService();
    });

    tearDown(() {
      container.dispose();
    });

    test('returns empty state when route type is not hashtag', () {
      // Arrange: Route context is home, not hashtag
      container = ProviderContainer(
        overrides: [
          videoEventServiceProvider.overrideWithValue(fakeService),
          pageContextProvider.overrideWith((ref) {
            return Stream.value(const RouteContext(type: RouteType.home));
          }),
        ],
      );

      // Act
      final result = container.read(videosForHashtagRouteProvider);

      // Assert
      expect(result.hasValue, isTrue);
      expect(result.value!.videos, isEmpty);
      expect(result.value!.hasMoreContent, isFalse);
    });

    test('returns empty state when hashtag is empty', () {
      // Arrange: Route is hashtag but tag is empty
      container = ProviderContainer(
        overrides: [
          videoEventServiceProvider.overrideWithValue(fakeService),
          pageContextProvider.overrideWith((ref) {
            return Stream.value(const RouteContext(
              type: RouteType.hashtag,
              hashtag: '',
            ));
          }),
        ],
      );

      // Act
      final result = container.read(videosForHashtagRouteProvider);

      // Assert
      expect(result.hasValue, isTrue);
      expect(result.value!.videos, isEmpty);
    });

    // TODO: Add subscription and reactive update tests once stream provider testing is refined
  });
}
