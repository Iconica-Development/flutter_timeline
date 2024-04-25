import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';

class TappableImage extends StatefulWidget {
  const TappableImage({
    required this.post,
    required this.onLike,
    required this.userId,
    required this.likeAndDislikeIcon,
    super.key,
  });

  final TimelinePost post;
  final String userId;
  final Future<bool> Function({required bool liked}) onLike;
  final (Icon?, Icon?) likeAndDislikeIcon;

  @override
  State<TappableImage> createState() => _TappableImageState();
}

class _TappableImageState extends State<TappableImage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    );

    animationController.addListener(listener);
  }

  void listener() {
    setState(() {});
  }

  @override
  void dispose() {
    animationController.removeListener(listener);
    animationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    animationController.forward();
  }

  void reverseAnimation() {
    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onDoubleTap: () async {
          if (loading) {
            return;
          }
          loading = true;
          await animationController.forward();

          var liked = await widget.onLike(
            liked: widget.post.likedBy?.contains(
                  widget.userId,
                ) ??
                false,
          );

          if (context.mounted) {
            await showDialog(
              barrierDismissible: false,
              barrierColor: Colors.transparent,
              context: context,
              builder: (context) => HeartAnimation(
                duration: const Duration(milliseconds: 200),
                liked: liked,
                likeAndDislikeIcon: widget.likeAndDislikeIcon,
              ),
            );
          }
          await animationController.reverse();
          loading = false;
        },
        child: Transform.translate(
          offset: Offset(0, animation.value * -32),
          child: Transform.scale(
            scale: 1 + animation.value * 0.1,
            child: widget.post.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: widget.post.imageUrl ?? '',
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  )
                : Image.memory(
                    width: double.infinity,
                    widget.post.image!,
                    fit: BoxFit.fitHeight,
                  ),
          ),
        ),
      );
}

class HeartAnimation extends StatefulWidget {
  const HeartAnimation({
    required this.duration,
    required this.liked,
    required this.likeAndDislikeIcon,
    super.key,
  });

  final Duration duration;
  final bool liked;
  final (Icon?, Icon?) likeAndDislikeIcon;

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation> {
  late bool active;

  @override
  void initState() {
    super.initState();
    active = widget.liked;
    unawaited(
      Future.delayed(const Duration(milliseconds: 100)).then((value) async {
        active = widget.liked;
        var navigator = Navigator.of(context);
        await Future.delayed(widget.duration);
        navigator.pop();
      }),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: widget.likeAndDislikeIcon.$1 != null &&
                widget.likeAndDislikeIcon.$2 != null
            ? 1
            : active
                ? 1
                : 0,
        duration: widget.duration,
        curve: Curves.decelerate,
        child: AnimatedScale(
          scale: widget.likeAndDislikeIcon.$1 != null &&
                  widget.likeAndDislikeIcon.$2 != null
              ? 10
              : active
                  ? 10
                  : 1,
          duration: widget.duration,
          child: active
              ? widget.likeAndDislikeIcon.$1
              : widget.likeAndDislikeIcon.$2,
        ),
      );
}
