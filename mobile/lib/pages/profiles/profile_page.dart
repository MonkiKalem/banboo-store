import 'package:banboostore/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth.dart';
import '../../services/user_api_service.dart';
import '../../utils/token_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = '';
  String _userEmail = '';
  String _profilePicture = '';
  String _role = '';
  bool _isGoogleUser = false;
  final TokenManager _tokenManager = TokenManager();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _userEmail = prefs.getString('userEmail') ?? 'user@example.com';
      _profilePicture = prefs.getString('profilePicture') ?? '';
      _role =  prefs.getString('userRole') ?? 'userRole';
      _isGoogleUser = prefs.getBool('isGoogleUser') ?? false;
    });
  }

  Future<void> _refreshProfile() async {
    await _loadUserProfile();

  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        backgroundColor: AppColors.backgroundCardColor,
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    // Proceed with logout if confirmed
    if (confirmLogout == true) {
      try {
        await _tokenManager.deleteToken();
        // If Google user, sign out from Google
        if (_isGoogleUser) {
          await GoogleAuth.logout();
        }

        // General logout process
        await UserApiService.logout();

        // Navigate to onboarding
        Navigator.pushReplacementNamed(context, "/onboarding");
      } catch (e) {
        // Show error if logout fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGreyColor,
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    CachedNetworkImage(
                      imageUrl: "https://upload-os-bbs.hoyolab.com/upload/2023/11/15/369285726/fe6f361715d2e479c9333aa4eb56debd_5228699759752292298.jpg?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // Gradient Overlay
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.backgroundDarkColor,
                            Colors.transparent,
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Header
                    Card(
                      color: AppColors.backgroundCardColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Profile Picture
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: _profilePicture.isNotEmpty
                                  ? NetworkImage(_profilePicture)
                                  : null,
                              child: _profilePicture.isEmpty
                                  ? const Icon(Icons.person, size: 40)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            // User Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _userName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _role,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _userEmail,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Profile Actions
                    Card(
                      color: AppColors.backgroundCardColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          _buildProfileAction(
                            icon: Icons.person_outline,
                            title: 'Edit Profile',
                            onTap: () async {
                              final result = await Navigator.pushNamed(context, '/edit-profile');
                              if (result == true) _refreshProfile();
                              },
                          ),
                          _buildProfileAction(
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Coming Soon'),
                                ),
                              );
                            },
                          ),
                          _buildProfileAction(
                            icon: Icons.logout,
                            title: 'Logout',
                            onTap: _handleLogout,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(25),
                      height: 150,
                      child: CachedNetworkImage(
                          imageUrl: ImagesLink.banbooGifImage,
                              progressIndicatorBuilder:(context, url, progress) =>  const Center(child: CircularProgressIndicator(),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build profile action rows
  Widget _buildProfileAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}