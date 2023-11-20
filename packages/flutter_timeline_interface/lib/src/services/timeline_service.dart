// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import 'package:flutter_timeline_interface/src/model/timeline_post.dart';
import 'package:flutter_timeline_interface/src/model/timeline_reaction.dart';

abstract class TimelineService {
  Future<void> deletePost(TimelinePost post);
  Future<void> createPost(TimelinePost post);
  Future<List<TimelinePost>> fetchPosts(String? category);
  Future<TimelinePost> fetchPostDetails(TimelinePost post);
  Future<void> reactToPost(
    TimelinePost post,
    TimelinePostReaction reaction, {
    Uint8List image,
  });
  Future<void> likePost(String userId, TimelinePost post);
  Future<void> unlikePost(String userId, TimelinePost post);
}