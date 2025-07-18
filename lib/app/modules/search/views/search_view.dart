// lib/app/modules/search/views/search_view.dart
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../controllers/user_search_controller.dart';

class SearchView extends GetView<UserSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller.searchTextController,
          decoration: const InputDecoration(
            hintText: "Kullanıcı adı ara...",
            border: InputBorder.none,
          ),
          onSubmitted: (value) => controller.searchUser(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: controller.searchUser,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!controller.hasSearched.value) {
          return const Center(child: Text("Bulmak istediğiniz kullanıcı adını yazın."));
        }
        if (controller.searchResults.isEmpty) {
          return const Center(child: Text("Bu kullanıcı adına sahip kimse bulunamadı."));
        }
        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final user = controller.searchResults[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.profilePhotoUrl != null
                    ? NetworkImage(user.profilePhotoUrl!)
                    : null,
                child: user.profilePhotoUrl == null ? const Icon(Icons.person) : null,
              ),
              title: Text(user.username),
              subtitle: Text(user.displayName),
              onTap: () {
                Get.toNamed('/profile/${user.id}');
              },
            );
          },
        );
      }),
    );
  }
}