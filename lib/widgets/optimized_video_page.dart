import 'package:flutter/material.dart';
import 'package:video_shopping_flutter/video_shop_flutter.dart';
import 'package:video_shopping_flutter/widgets/optimized_video_item.dart';

class OptimizedVideoPage extends StatelessWidget {
  const OptimizedVideoPage({
    Key? key,
    required this.video,
    this.customVideoInfo,
    required this.followWidget,
    required this.likeWidget,
    required this.commentWidget,
    required this.shareWidget,
    required this.buyWidget,
    required this.viewWidget,
    required this.viewMoreWidget,
    this.informationPadding,
    required this.videoWatched,
    this.informationAlign,
    this.actionsAlign,
    this.actionsPadding,
    required this.index,
    required this.currentIndex,
    required this.preloadDistance,
    required this.updateLastSeenPage,
    this.enableBackgroundContent = false,
  }) : super(key: key);

  final VideoModel video;
  final Widget Function(VideoModel? video, int index)? customVideoInfo;
  final Widget Function(VideoModel? video)? followWidget;
  final Widget Function(VideoModel? video, Function(int likes, bool liked))? likeWidget;
  final Widget Function(VideoModel? video)? commentWidget;
  final Widget Function(VideoModel? video)? shareWidget;
  final Widget Function(VideoModel? video)? buyWidget;
  final Widget Function(VideoModel? video, int index)? viewWidget;
  final Widget Function(VideoModel? video, int index)? viewMoreWidget;
  final EdgeInsetsGeometry? informationPadding;
  final List<String> videoWatched;
  final AlignmentGeometry? informationAlign;
  final AlignmentGeometry? actionsAlign;
  final EdgeInsetsGeometry? actionsPadding;
  final int index;
  final int currentIndex;
  final int preloadDistance;
  final Function(int lastSeenPage)? updateLastSeenPage;
  final bool? enableBackgroundContent;

  bool get shouldPreload {
    return (index - currentIndex).abs() <= preloadDistance;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Video with optimized preloading
          Align(
            alignment: Alignment.center,
            child: OptimizedVideoItem(
              video: video,
              videoWatched: videoWatched,
              index: index,
              updateLastSeenPage: updateLastSeenPage,
              shouldPreload: shouldPreload,
            ),
          ),
          // Background content.
          if (enableBackgroundContent != null && enableBackgroundContent!)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: stopGradient,
                    colors: gradientBackground,
                  ),
                ),
              ),
            ),
          // Video info______________.
          Align(
            alignment: informationAlign ?? Alignment.bottomLeft,
            child: Padding(
              padding: informationPadding ?? const EdgeInsets.only(left: 20, bottom: 70),
              child: (customVideoInfo != null)
                  ? customVideoInfo!(video, index)
                  : VideoInformation(
                      video.videoTitle ?? "",
                      video.videoTitle ?? "",
                      video.description ?? "",
                    ),
            ),
          ),
          // Video actions______________.
          Align(
            alignment: actionsAlign ?? Alignment.bottomRight,
            child: Padding(
              padding: actionsPadding ?? const EdgeInsets.only(bottom: 70),
              child: ActionsToolbar(
                enableBackgroundContent: enableBackgroundContent,
                video: video,
                followWidget: followWidget,
                likeWidget: likeWidget,
                commentWidget: commentWidget,
                shareWidget: shareWidget,
                buyWidget: buyWidget,
                viewWidget: viewWidget,
                viewMoreWidget: viewMoreWidget,
                index: index,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
