import 'package:flutter/material.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String activeId = "invite_friends";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: CustomSliverAppBarDelegate(expandedHeight: 200),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // User Info Section
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/man.png',
                    fit: BoxFit.contain,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Gagan Saini',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@gsprocoder',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),

                // Profile Menu List
                _buildProfileMenu(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }

  // Widget for building the list of profile options
  Widget _buildProfileMenu() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildMenuListItem(
            id: "invite_friends",
            icon: Icons.diamond_outlined,
            title: 'Invite Friends',
          ),
          _buildMenuListItem(
            id: "account_info",
            icon: Icons.person_outline,
            title: 'Account info',
          ),
          _buildMenuListItem(
            id: "personal_profile",
            icon: Icons.group_outlined,
            title: 'Personal profile',
          ),
          _buildMenuListItem(
            id: "message_center",
            icon: Icons.mail_outline,
            title: 'Message center',
          ),
          _buildMenuListItem(
            id: "security",
            icon: Icons.shield_outlined,
            title: 'Login and security',
          ),
          _buildMenuListItem(
            id: "privacy",
            icon: Icons.lock_outline,
            title: 'Data and privacy',
          ),
        ],
      ),
    );
  }

  // Reusable widget for each menu item
  Widget _buildMenuListItem({
    required String id,
    required IconData icon,
    required String title,
  }) {
    final isActive = id == activeId;

    return Card(
      elevation: isActive ? 2 : 1,
      shadowColor: isActive ? const Color(0xFF63B5AF) : Colors.black87,
      // margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: isActive ? Colors.white : Colors.grey[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? const Color(0xFF63B5AF)
              : Colors.transparent,
          child: Icon(icon, color: isActive ? Colors.white : Colors.grey[600]),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          setState(() {
            activeId = id;
          });
        },
      ),
    );
  }
}

// Custom delegate for the sliver app bar to create the curved effect
class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  const CustomSliverAppBarDelegate({required this.expandedHeight});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        // Background with curved shape
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D9C9A), Color(0xFF43B4B1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        // AppBar content (Title and Actions)
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // leading: IconButton(
            //   icon: const Icon(Icons.arrow_back, color: Colors.white),
            //   onPressed: () {
            //     // Handle back button press
            //   },
            // ),
            // centerTitle: true,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    // Handle Download click
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],

            // actions: [
            //   Container(
            //     margin: EdgeInsets.only(right: 10),
            //     decoration: BoxDecoration(
            //       color: Colors.white.withAlpha(65),
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     // padding: const EdgeInsets.all(4),
            //     child: IconButton(
            //       icon: const Icon(
            //         Icons.notifications_none,
            //         color: Colors.white,
            //       ),
            //       onPressed: () {
            //         // Handle Notification click
            //       },
            //     ),
            //   ),
            // ],
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 40;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

// Custom clipper for the curved app bar shape
class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 35);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 35,
      size.width,
      size.height - 35,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
