# Flutter Timeline

Flutter Timeline is a package which shows a list posts by a user. This package also has additional features like liking a post and leaving comments. Default this package adds support for a Firebase back-end.

![Flutter Timeline GIF](example.gif)

## Setup
To use this package, add flutter_timeline as a dependency in your pubspec.yaml file:

```
  flutter_timeline:
    git: 
      url: https://github.com/Iconica-Development/flutter_timeline.git
      path: packages/flutter_timeline
```

If you are going to use Firebase as the back-end of the Timeline, you should also add the following package as a dependency to your pubspec.yaml file:

```
  flutter_timeline_firebase:
    git: 
      url: https://github.com/Iconica-Development/flutter_timeline.git
      path: packages/flutter_timeline_firebase
```

In firebase add firestore and storage to your project.

Add the following code in your `main` function, before the runApp().
And import this package:   import 'package:intl/date_symbol_data_local.dart';
```
  initializeDateFormatting();
```

## How to use
To use the userstory add the following code somewhere in your widget tree:

````
timeLineUserStory(TimelineUserStoryConfiguration, context),
````


Or create your own routing using the Screens:
To add the `TimelineScreen` add the following code:

````
TimelineScreen(
  userId:  currentUserId,
  service: timelineService,
  options: timelineOptions,
),
````

`TimelineScreen` is supplied with a standard `TimelinePostScreen` which opens the detail page of the selected post. Needed parameter like `TimelineService` and `TimelineOptions` will be the same as the ones supplied to the `TimelineScreen`.

The standard `TimelinePostScreen` can be overridden by defining `onPostTap` as shown below.

```
TimelineScreen(
  userId:  currentUserId,
  service: timelineService,
  options: timelineOptions,
  onPostTap: (tappedPost) {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: TimelinePostScreen(
            userId:  currentUserId,
            service: timelineService,
            options: timelineOptions,
            post: post,
            onPostDelete: () {
             service.deletePost(post);
            },
          ),
        ),
      ),
    );
  },
),
```

A standard post creation is provided named: `TimelinePostCreationScreen`. Routing to this has to be done manually.

```
TimelinePostCreationScreen(
  postCategory: selectedCategory,
  userId: currentUserId,
  service: timelineService,
  options: timelineOptions,
  onPostCreated: (post) {
    Navigator.of(context).pop();
  },
),
```

You can choose to show an overview of the post before actually posting it using the `enablePostOverviewScreen` config setting.


The `TimelineOptions` has its own parameters, as specified below:

| Parameter | Explanation |
|-----------|-------------|
| theme | Used to set icon colors and textstyles |
| translations | Ability to provide desired text and tanslations. |
| imagePickerConfig | Config for the image picker in the post creation screen. |
| imagePickerTheme | Theme for the image picker in the post creation screen. |
| timelinePostHeight | Sets the height for each post widget in the list of post. If null, the size depends on the size of the image. |
| allowAllDeletion | Determines of users are allowed to delete thier own posts. |
| afterPostCreationGoHome | Boolean to enable redirect to home after post creation. If false, it will redirect to created post screen. |
| enablePostOverviewScreen | Boolean to enable timeline post overview screen before submitting. |
| sortCommentsAscending | Determines if the comments are sorted from old to new or new to old. |
| sortPostsAscending | Determines if the posts are sorted from old to new or new to old. |
| doubleTapToLike | Enables the abilty to double tap the image to like the post. |
| iconsWithValues | Ability to provide desired text and tanslations. |
| likeAndDislikeIconsForDoubleTap | Ability to override the standard icon which appears on double tap. |
| homeOpenPageBuilder | Open page builder function for the home page. |
| postCreationOpenPageBuilder | Open page builder function for the post creation page. |
| postViewOpenPageBuilder | Open page builder function for the post view page. |
| postOverviewOpenPageBuilder | Open page builder function for the post overview page. |
| itemInfoBuilder | Ability to override the bottom of the postwidgets. (Everything under the like and comment icons) |
| dateFormat | Sets the used date format |
| timeFormat | Sets the used time format |
| buttonBuilder | The ability to provide a custom button for the post creation screen. |
| textInputBuilder | The ability to provide a custom text input widget for the post creation screen. |
| dividerBuilder | Ability to provide desired text and tanslations. |
| userAvatarBuilder | The ability to provide a custom avatar. |
| anonymousAvatarBuilder | The ability to provide a custom avatar for anonymous users. |
| nameBuilder | The ability to override the standard way of display the post creator name. |
| padding | Padding used for the whole page. |
| iconSize | Size of icons like the comment and like icons. Dafualts to 26. |
| postWidgetHeight | Ability to provide desired text and tanslations. |
| minTitleLength | Minimum length of the title. |
| maxTitleLength | Maximum length of the title. |
| minContentLength | Minimum length of the post content. |
| maxContentLength | Maximum length of the post content. |
| postPadding | Padding for each post. |
| filterOptions | Options for using the filter to filter posts. |
| categoriesOptions | Options for using the category selector to provide posts of a certain category. |


The `ImagePickerTheme` and `imagePickerConfig` also have their own parameters, how to use these parameters can be found in [the documentation of the flutter_image_picker package](https://github.com/Iconica-Development/flutter_image_picker).


## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_timeline/pulls) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_timeline/pulls).

## Author

This `flutter_timeline` for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>