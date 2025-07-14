import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class VideoPlayerApp extends StatefulWidget {
  /// Create video player.
  const VideoPlayerApp({Key? key, required this.controller}) : super(key: key);
  final CachedVideoPlayerPlusController controller;
  @override
  State<VideoPlayerApp> createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp> {
  bool _showPause = false;
  bool _isLoading = true;

  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.value.isPlaying) {
        if (_showPause) {
          if (mounted) {
            setState(() {
              _showPause = false;
            });
          }
        }
      } else {
        if (!_showPause) {
          if (mounted) {
            setState(() {
              _showPause = true;
            });
          }
        }
      }

      if (widget.controller.value.isBuffering) {
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenRatio = MediaQuery.of(context).size.aspectRatio;
    return GestureDetector(
      onTap: () {
        if (widget.controller.value.isPlaying) {
          widget.controller.pause();
          setState(() {
            _showPause = true;
          });
        } else {
          widget.controller.play();
          setState(() {
            _showPause = false;
          });
        }
      },
      child: (widget.controller.value.aspectRatio < screenRatio)
          ? AbsorbPointer(
              child: Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: widget.controller.value.size.width,
                      height: widget.controller.value.size.height,
                      child: CachedVideoPlayerPlus(widget.controller),
                    ),
                  ),
                ),
                _isLoading
                    ? const PauseIcon(
                        isLoading: true,
                      )
                    : _showPause
                        ? const PauseIcon()
                        : const SizedBox(),
              ],
            ))
          : AbsorbPointer(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: Stack(
                  children: [
                    CachedVideoPlayerPlus(widget.controller),
                    _isLoading
                        ? const PauseIcon(
                            isLoading: true,
                          )
                        : _showPause
                            ? const PauseIcon()
                            : const SizedBox(),
                  ],
                ),
              ),
            ),
    );
  }
}

class PauseIcon extends StatelessWidget {
  final bool isLoading;

  /// Create pause icon.
  const PauseIcon({Key? key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors.white.withOpacity(0.5),
                )
              : Icon(Icons.play_arrow, color: Colors.white.withOpacity(0.5), size: 40),
        ),
      ),
    );
  }
}
