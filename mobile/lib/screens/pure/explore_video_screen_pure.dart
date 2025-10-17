// ABOUTME: Pure explore video screen using VideoFeedItem directly in PageView
// ABOUTME: Simplified implementation with direct VideoFeedItem usage

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvine/models/video_event.dart';
import 'package:openvine/router/nav_extensions.dart';
import 'package:openvine/widgets/video_feed_item.dart';
import 'package:openvine/utils/unified_logger.dart';
import 'package:openvine/mixins/pagination_mixin.dart';

/// Pure explore video screen using VideoFeedItem directly in PageView
class ExploreVideoScreenPure extends ConsumerStatefulWidget {
  const ExploreVideoScreenPure({
    super.key,
    required this.startingVideo,
    required this.videoList,
    required this.contextTitle,
    this.startingIndex,
    this.onLoadMore,
  });

  final VideoEvent startingVideo;
  final List<VideoEvent> videoList;
  final String contextTitle;
  final int? startingIndex;
  final VoidCallback? onLoadMore;

  @override
  ConsumerState<ExploreVideoScreenPure> createState() => _ExploreVideoScreenPureState();
}

class _ExploreVideoScreenPureState extends ConsumerState<ExploreVideoScreenPure>
    with PaginationMixin {
  late int _initialIndex;

  @override
  void initState() {
    super.initState();

    // Find starting video index or use provided index
    _initialIndex = widget.startingIndex ??
        widget.videoList.indexWhere((video) => video.id == widget.startingVideo.id);

    if (_initialIndex == -1) {
      _initialIndex = 0; // Fallback to first video
    }

    Log.info('🎯 ExploreVideoScreenPure: Initialized with ${widget.videoList.length} videos, starting at index $_initialIndex',
        category: LogCategory.video);
  }

  @override
  void dispose() {
    // Router-driven state - no manual cleanup needed, URL navigation handles it
    Log.info('🛑 ExploreVideoScreenPure disposing - router handles state cleanup',
        name: 'ExploreVideoScreen', category: LogCategory.video);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Simple PageView.builder using VideoFeedItem directly
    return PageView.builder(
      itemCount: widget.videoList.length,
      controller: PageController(initialPage: _initialIndex),
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
        Log.debug('📄 Page changed to index $index (${widget.videoList[index].id.substring(0, 8)}...)',
            name: 'ExploreVideoScreen', category: LogCategory.video);

        // Update URL to trigger reactive video playback via router
        context.goExplore(index);

        // Trigger pagination when near the end if callback provided
        if (widget.onLoadMore != null) {
          checkForPagination(
            currentIndex: index,
            totalItems: widget.videoList.length,
            onLoadMore: widget.onLoadMore!,
          );
        }
      },
      itemBuilder: (context, index) {
        return VideoFeedItem(
          key: ValueKey('video-${widget.videoList[index].id}'),
          video: widget.videoList[index],
          index: index,
          hasBottomNavigation: false,
          contextTitle: widget.contextTitle,
        );
      },
    );
  }
}
