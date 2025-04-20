// import 'package:flutter/material.dart';
// import '../models/user_model.dart';
// import '../services/user_service.dart';
//
// class UserProvider with ChangeNotifier {
//   UserModel? _userData;
//   final UserService _userService = UserService();
//   bool _isLoading = false;
//
//   UserModel? get userData => _userData;
//   bool get isLoading => _isLoading;
//
//   Future<void> fetchUserData(String authId) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       _userData = await _userService.getUserData(authId);
//     } catch (e) {
//       //TODO - Add error message for debugging
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> updateUserData({
//     required String authId,
//     String? firstName,
//     String? lastName,
//     String? phone,
//   }) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       await _userService.updateUserData(
//         authId: authId,
//         firstName: firstName,
//         lastName: lastName,
//         phone: phone,
//       );
//
//       // Refresh user data after update
//       await fetchUserData(authId);
//     } catch (e) {
//       // Handle error silently
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   void clearUserData() {
//     _userData = null;
//     _isLoading = false;
//     notifyListeners();
//   }
// }
//
//
