// lib/app/modules/search/controllers/user_search_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/user_model.dart';

class UserSearchController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final searchTextController = TextEditingController();

  final RxList<UserModel> searchResults = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasSearched = false.obs; // Arama yapılıp yapılmadığını kontrol etmek için

  Future<void> searchUser() async {
    final String query = searchTextController.text.trim();
    if (query.isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      return;
    }

    isLoading.value = true;
    hasSearched.value = true;
    searchResults.clear();

    try {
      // Şimdilik sadece tam eşleşmeleri arıyoruz.
      final snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: query)
          .get();

      if (snapshot.docs.isNotEmpty) {
        searchResults.value = snapshot.docs.map((doc) => UserModel.fromMap(doc)).toList();
      }
    } catch (e) {
      Get.snackbar("Hata", "Arama sırasında bir sorun oluştu.");
    } finally {
      isLoading.value = false;
    }
  }
}