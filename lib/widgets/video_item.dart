import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_shopping_flutter/model/video_model.dart';
import 'package:video_shopping_flutter/widgets/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoItem extends StatefulWidget {
  /// Create video item.
  const VideoItem({
    Key? key,
    required this.video,
    required this.videoWatched,
    required this.updateLastSeenPage,
    required this.index,
  }) : super(key: key);
  final VideoModel video;
  final List<String> videoWatched;
  final Function(int lastSeenPage)? updateLastSeenPage;
  final int index;
  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  CachedVideoPlayerPlusController? _videoController;

  @override
  void initState() {
    super.initState();
    // Initialize video controller immediately for preloading
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    try {
      _videoController = CachedVideoPlayerPlusController.networkUrl(Uri.parse(widget.video.url));
      await _videoController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing video controller: $e');
    }
  }

  @override
  void dispose() async {
    super.dispose();
    if (_videoController != null) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      }
    }
    await _videoController?.dispose().then((value) {
      _videoController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _videoController != null && _videoController!.value.isInitialized
        ? VisibilityDetector(
            onVisibilityChanged: (visibleInfo) {
              if (visibleInfo.visibleFraction > 0.8) {
                if (!_videoController!.value.isPlaying) {
                  _videoController!.play();
                  _videoController!.setLooping(true);
                  // Update watched videos.
                  if (widget.video.id != null) {
                    widget.videoWatched.add(widget.video.id!.toString());
                  }
                  // Update last seen video.
                  if (widget.updateLastSeenPage != null) {
                    widget.updateLastSeenPage!(widget.index);
                  }
                }
              }
              if (visibleInfo.visibleFraction == 0) {
                if (_videoController != null) {
                  if (_videoController!.value.isPlaying) {
                    _videoController!.pause();
                  }
                }
              }
            },
            key: UniqueKey(),
            child: VideoPlayerApp(
              controller: _videoController!,
            ),
          )
        : VisibilityDetector(
            key: UniqueKey(),
            child: Image.network(
              widget.video.thumbnail ?? "",
              loadingBuilder: (context, child, loadingProgress) {
                return const AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Center(
                    child: Icon(Icons.play_arrow, size: 80, color: Colors.grey),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Center(
                    child: Icon(Icons.play_arrow, size: 80, color: Colors.grey),
                  ),
                );
              },
              fit: BoxFit.fitWidth,
            ),
            onVisibilityChanged: (info) {
              // Video controller is now initialized in initState
              // This callback is kept for potential future use
            },
          );
  }
}
