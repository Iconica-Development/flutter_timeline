## 4.0.0

- Add a serviceBuilder to the userstory configuration
- Add a listHeaderBuilder for showing a header at the top of the list of posts in the timeline
- Add a getUserId function to retrieve the userId when needed in the userstory configuration
- Fix the timelinecategory selection by removing the categories with key null
- Set an optional max length on the default post title input field
- Add a postCreationFloatingActionButtonColor to the timeline theme to set the color of the floating action button
- Add a post and a category to the postViewOpenPageBuilder function
- Add a refresh functionality to the timeline with a pull to refresh callback to allow additional functionality when refreshing the timeline
- Use the adaptive variants of the material elements in the timeline
- Change the default blue color to the primary color of the Theme.of(context) in the timeline

## 3.0.1

- Fixed postOverviewScreen not displaying the creators name.

## 3.0.0
- Add default styling and default flow

## 2.3.1

- Updated readme.
- fixed bug in `localTimelinePostService` where it was not possible to make a post.

## 2.3.0

- Added separate open page builders for timeline screens
- Fixed afterPostCreationGoHome routing in gorouter and navigater user stories

## 2.2.0

- Add all routes to gorouter and navigator user stories
- Added enablePostOverviewScreen to config
- Update flutter_image_picker to 1.0.5

## 2.1.0

- Fixed multiline textfield not being dismissible.
- Fixed liking a new post you created.
- Added options to require image and enforce content length in post creation
- Added post overview screen before creating post

## 1.0.0 - November 27 2023

- Improved TimelineService with support for pagination
- Extra screens and configuration
- TimelineUserStory in the flutter_timeline package which uses go_router

## 0.0.1 - November 22 2023

- Initial release
