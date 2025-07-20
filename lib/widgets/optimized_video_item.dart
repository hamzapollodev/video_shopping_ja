import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_shopping_flutter/model/video_model.dart';
import 'package:video_shopping_flutter/widgets/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class OptimizedVideoItem extends StatefulWidget {
  const OptimizedVideoItem({
    Key? key,
    required this.video,
    required this.videoWatched,
    required this.updateLastSeenPage,
    required this.index,
    this.shouldPreload = false,
  }) : super(key: key);

  final VideoModel video;
  final List<String> videoWatched;
  final Function(int lastSeenPage)? updateLastSeenPage;
  final int index;
  final bool shouldPreload;

  @override
  State<OptimizedVideoItem> createState() => _OptimizedVideoItemState();
}

class _OptimizedVideoItemState extends State<OptimizedVideoItem> {
  CachedVideoPlayerPlusController? _videoController;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    // Only preload if explicitly requested
    if (widget.shouldPreload) {
      _initializeVideoController();
    }
  }

  Future<void> _initializeVideoController() async {
    if (_videoController != null || _isInitializing) return;

    _isInitializing = true;
    try {
      _videoController = CachedVideoPlayerPlusController.networkUrl(Uri.parse(widget.video.url));
      await _videoController!.initialize();
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      print('Error initializing video controller: $e');
      _isInitializing = false;
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
            child: _isInitializing
                ? Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : Image.network(
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
              // Initialize video when it becomes close to visible
              if (info.visibleFraction > 0.1 && !widget.shouldPreload) {
                _initializeVideoController();
              }
            },
          );
  }
}
