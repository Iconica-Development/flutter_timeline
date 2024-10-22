import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_image_picker/flutter_image_picker.dart";
import "package:flutter_timeline/flutter_timeline.dart";
import "package:intl/intl.dart";

class TimelineOptions {
  const TimelineOptions({
    this.translations = const TimelineTranslations(),
    this.everyoneCanDelete = false,
    this.onTapLike,
    this.onTapUnlike,
    this.onPostDelete,
    this.userAvatarBuilder = _defaultUserAvatarBuilder,
    this.iconSize = 24,
    this.iconColor = Colors.black,
    this.doubleTapToLike = false,
    this.userNameBuilder = _defaultNameBuilder,
    this.floatingActionButtonBuilder = _defaultFloatingActionButton,
    this.allowCreatingCategories = true,
    this.initialCategoryId,
    this.likeIcon = Icons.favorite_outline,
    this.likedIcon = Icons.favorite,
    this.commentIcon = Icons.chat_bubble_outline,
    this.imagePickerTheme,
    this.dateFormat = _defaultDateFormat,
    this.buttonBuilder = _defaultButtonBuilder,
    this.postBuilder,
    this.timelineScreenDrawer,
    this.timelineScreenAppBarBuilder,
    this.onCreatePost,
    this.onTapComments,
    this.onTapCreatePost,
    this.onTapPost,
    this.onTapCategory,
    this.onTapOverview,
    this.onTapCreatePostInOverview,
  });

  // Builders
  final UserAvatarBuilder userAvatarBuilder;
  final UserNameBuilder userNameBuilder;
  final DateFormat Function(BuildContext context) dateFormat;
  final FloatingActionButtonBuilder floatingActionButtonBuilder;
  final ButtonBuilder buttonBuilder;
  final PostBuilder? postBuilder;

  //general
  final TimelineTranslations translations;
  final Function(TimelinePost post, TimelineUser user)? onTapComments;
  final Function(TimelineCategory? category)? onTapCreatePost;
  final Function(TimelinePost post, TimelineUser user)? onTapPost;
  final Function(TimelineCategory? category)? onTapCategory;
  final Function()? onTapOverview;
  final Function(TimelinePost post)? onTapCreatePostInOverview;

  // TimelinePostWidget
  final bool everyoneCanDelete;
  final VoidCallback? onTapLike;
  final VoidCallback? onTapUnlike;
  final VoidCallback? onPostDelete;
  final Function(TimelinePost post)? onCreatePost;
  final double iconSize;
  final Color iconColor;
  final IconData likeIcon;
  final IconData likedIcon;
  final IconData commentIcon;
  final bool doubleTapToLike;
  final bool allowCreatingCategories;
  final String? initialCategoryId;
  final ImagePickerTheme? imagePickerTheme;
  final Widget? timelineScreenDrawer;
  final AppBarBuilder? timelineScreenAppBarBuilder;
}

Widget _defaultFloatingActionButton(
  Function() onPressed,
  BuildContext context,
) {
  var theme = Theme.of(context);
  return FloatingActionButton.large(
    backgroundColor: theme.primaryColor,
    onPressed: onPressed,
    child: Icon(
      Icons.add,
      size: 44,
      color: theme.colorScheme.onPrimary,
    ),
  );
}

Widget _defaultUserAvatarBuilder(TimelineUser? user, double size) {
  if (user == null || user.imageUrl == null) {
    return CircleAvatar(
      radius: size / 2,
      child: const Icon(
        Icons.person,
      ),
    );
  }
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: CachedNetworkImageProvider(
          user.imageUrl!,
        ),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _defaultNameBuilder(
  TimelineUser? user,
  String anonymousUserText,
  BuildContext context,
) {
  if (user == null || user.fullName == null) {
    return Text(anonymousUserText);
  }
  return Text(
    user.fullName!,
    style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Colors.black,
        ),
  );
}

Widget _defaultButtonBuilder({
  required String title,
  required Function() onPressed,
  required BuildContext context,
}) {
  var theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: FilledButton(
      style: ElevatedButton.styleFrom(
        maximumSize: const Size(254, 50),
        minimumSize: const Size(254, 50),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: theme.textTheme.displayLarge,
      ),
    ),
  );
}

DateFormat _defaultDateFormat(BuildContext context) => DateFormat(
      "dd/MM/yyyy 'at' HH:mm",
      Localizations.localeOf(context).languageCode,
    );

typedef UserAvatarBuilder = Widget Function(
  TimelineUser? user,
  double size,
);

typedef UserNameBuilder = Widget Function(
  TimelineUser? user,
  String anonymousUserText,
  BuildContext context,
);

typedef FloatingActionButtonBuilder = Widget Function(
  Function() onPressed,
  BuildContext context,
);

typedef ButtonBuilder = Widget Function({
  required String title,
  required Function() onPressed,
  required BuildContext context,
});

typedef PostBuilder = Widget Function({
  required TimelinePost post,
  required Function(TimelinePost) onTap,
  required BuildContext context,
});

typedef AppBarBuilder = PreferredSizeWidget Function(
  BuildContext context,
  String title,
);
