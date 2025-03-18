import 'package:auto_route/annotations.dart';
import 'package:bid/components/buttons/custom_button.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/widgets/profile_header.dart';
import '../components/buttons/auth_button.dart';
import '../components/widgets/social_login_row.dart';
import '../modals/loginmodal.dart';
import '../modals/registrationmodal.dart';
import '../providers/supabase_auth_provider.dart';
import '../providers/user_provider.dart';
import '../services/user_service.dart';

@RoutePage()
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserDataIfNeeded();
    });
  }

  void _fetchUserDataIfNeeded() {
    final authProvider = Provider.of<SupabaseAuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (authProvider.isLoggedIn && userProvider.userData == null && !userProvider.isLoading) {
      print('Fetching user data for ID: ${authProvider.user!.id}');
      userProvider.fetchUserData(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<SupabaseAuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;
    final isLoading = userProvider.isLoading;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : !authProvider.isLoggedIn
          ? _buildNotLoggedInView(context)
          : userData == null
          ? _buildNoUserDataView(context, authProvider)
          : SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section with user email and space for avatar - TODO
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.quaternary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Theme.of(context).colorScheme.primary,
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
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Personal Information
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoItem('First Name', userData.firstName ?? 'Not set'),
                  _buildInfoItem('Last Name', userData.lastName ?? 'Not set'),
                  _buildInfoItem('Phone', userData.phone ?? 'Not set'),

                  const SizedBox(height: 5),

                  // Address Information
                  Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Placeholder - TODO - Fetch addresses
                  _buildInfoItem('Address', 'No address saved'),

                  const SizedBox(height: 10),

                  // Recent Order
                  const Text(
                    'Order History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // TODO - This is a placeholder - fetch actual order details
                  _buildInfoItem('Order ID', 'No recent orders'),

                  const SizedBox(height: 40),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      text: "Edit Profile",
                      onTap: () {
                        // TODO - Navigate to edit profile page
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sign Out Button
                  AuthButton(text: 'Sign Out', onTap: () async {
                        await authProvider.signOut();
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedInView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ProfileHeader(),
          const SizedBox(height: 30),

          Text(
            'You need to log in to view your profile',
            style: TextStyle(fontSize: 16,
            color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 20),

          AuthButton(
            text: "Login",
            onTap: () => _showLoginModal(context),
          ),
          const SizedBox(height: 15),
          AuthButton(
            text: "Sign Up",
            onTap: () => _showRegistrationModal(context),
          ),
          const SizedBox(height: 15),
          const SocialLoginRow(),
        ],
      ),
    );
  }

  void _showLoginModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoginPage(
          onTap: () {
            Navigator.pop(context);
            _showRegistrationModal(context);
          },
        );
      },
    );
  }

  void _showRegistrationModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RegistrationPage(
          onTap: () {
            Navigator.pop(context);
            _showLoginModal(context);
          },
        );
      },
    );
  }

  Widget _buildNoUserDataView(BuildContext context, SupabaseAuthProvider authProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ProfileHeader(),
          const SizedBox(height: 30),

          const Text(
            'No profile data found. Would you like to create a profile?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          AuthButton(
            text: "Create Profile",
            onTap: () {
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
          ),
        ],
      ),
    );
  }
}

