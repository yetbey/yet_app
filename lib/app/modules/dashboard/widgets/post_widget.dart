import 'package:flutter/material.dart';
import 'package:yet_app/app/data/models/post_model.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;
  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header - Username and Profile Picture
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: post.authorProfilePhotoUrl != null
                      ? NetworkImage(post.authorProfilePhotoUrl!)
                      : null,
                  child: post.authorProfilePhotoUrl == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  post.authorUsername,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Post Image
          Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300, // constant maybe change
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 300,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.comment_outlined),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.send_outlined)),
              ],
            ),
          ),

          // Explanation
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: '${post.authorUsername} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: post.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
