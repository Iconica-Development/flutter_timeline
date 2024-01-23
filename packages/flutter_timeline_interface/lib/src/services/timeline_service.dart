// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/src/model/timeline_post.dart';
import 'package:flutter_timeline_interface/src/model/timeline_reaction.dart';

abstract class TimelineService with ChangeNotifier {
  List<TimelinePost> posts = [];

  Future<void> deletePost(TimelinePost post);
  Future<TimelinePost> deletePostReaction(TimelinePost post, String reactionId);
  Future<TimelinePost> createPost(TimelinePost post);
  Future<List<TimelinePost>> fetchPosts(String? category);
  Future<TimelinePost> fetchPost(TimelinePost post);
  Future<List<TimelinePost>> fetchPostsPaginated(String? category, int limit);
  TimelinePost? getPost(String postId);
  List<TimelinePost> getPosts(String? category);
  Future<List<TimelinePost>> refreshPosts(String? category);
  Future<TimelinePost> fetchPostDetails(TimelinePost post);
  Future<TimelinePost> reactToPost(
    TimelinePost post,
    TimelinePostReaction reaction, {
    Uint8List image,
  });
  Future<TimelinePost> likePost(String userId, TimelinePost post);
  Future<TimelinePost> unlikePost(String userId, TimelinePost post);
}
