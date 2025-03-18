import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/supabase_auth_provider.dart';
import '../providers/user_provider.dart';
import '../services/user_service.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<SupabaseAuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    // Fetch user data when the page loads
    if (authProvider.isLoggedIn && userProvider.userData == null && !userProvider.isLoading) {
      userProvider.fetchUserData(authProvider.user!.id);
    }

    final userData = userProvider.userData;
    final isLoading = userProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : !authProvider.isLoggedIn
          ? _buildNotLoggedInView(context)
          : userData == null
          ? _buildNoUserDataView(context, authProvider)
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userData.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Account Details
              const Text(
                'Account Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              _buildTextField(
                'Full Name',
                '${userData.firstName ?? ''} ${userData.lastName ?? ''}',
                onChanged: (value) {
                  final nameParts = value.split(' ');
                  final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
                  final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

                  userProvider.updateUserData(
                    authId: authProvider.user!.id,
                    firstName: firstName,
                    lastName: lastName,
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildTextField('Email', userData.email, enabled: false),
              const SizedBox(height: 16),
              _buildTextField(
                'Phone',
                userData.phone ?? '',
                onChanged: (value) {
                  userProvider.updateUserData(
                    authId: authProvider.user!.id,
                    phone: value,
                  );
                },
              ),

              const SizedBox(height: 40),

              // Quick Access
              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              _buildNavigationItem(
                Icons.shopping_bag_outlined,
                'My Orders',
                onTap: () {
                  // Navigate to orders page
                },
              ),
              const SizedBox(height: 12),
              _buildNavigationItem(
                Icons.favorite_border,
                'Wishlist',
                onTap: () {
                  // Navigate to wishlist page
                },
              ),
              const SizedBox(height: 12),
              _buildNavigationItem(
                Icons.credit_card,
                'Payment Methods',
                onTap: () {
                  // Navigate to payment methods page
                },
              ),
              const SizedBox(height: 12),
              _buildNavigationItem(
                Icons.settings_outlined,
                'Settings',
                onTap: () {
                  // Navigate to settings page
                },
              ),

              const SizedBox(height: 40),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await authProvider.signOut();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 20,
                  ),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotLoggedInView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You need to log in to view your profile',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to login page or show login modal
            },
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoUserDataView(BuildContext context, SupabaseAuthProvider authProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No profile data found. Would you like to create a profile?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Create a user profile
              final userService = UserService();
              userService.createUser(
                authId: authProvider.user!.id,
                email: authProvider.user!.email ?? '',
              ).then((_) {
                // Refresh the page
                Provider.of<UserProvider>(context, listen: false)
                    .fetchUserData(authProvider.user!.id);
              });
            },
            child: const Text('Create Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, {bool enabled = true, Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: TextEditingController(text: initialValue),
            enabled: enabled,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationItem(IconData icon, String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white38,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

