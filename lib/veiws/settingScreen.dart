// import 'package:dermaai/auth/signinScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../veiwsModels/authVeiwModel.dart';
//
// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authVM = Provider.of<AuthViewModel>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Settings"), centerTitle: true),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           SwitchListTile(
//             title: const Text("Dark Mode"),
//             value: authVM.isDarkMode,
//             onChanged: (value) => authVM.toggleDarkMode(value),
//           ),
//           SwitchListTile(
//             title: const Text("Notifications"),
//             value: authVM.notificationsEnabled,
//             onChanged: (value) => authVM.toggleNotifications(value),
//           ),
//           const Divider(),
//           ListTile(
//             title: const Text("Logout"),
//             trailing: const Icon(Icons.logout),
//             onTap: () async {
//               await authVM.signOut();
//               // Navigate to login or splash
//               if (context.mounted) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => Signinscreen()),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:dermaai/auth/signinScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../veiwsModels/authVeiwModel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);
    final isDark = authVM.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 👤 Profile Header
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.purple.withOpacity(0.1),
                  backgroundImage: authVM.userImage.isNotEmpty
                      ? NetworkImage(authVM.userImage)
                      : null,
                  child: authVM.userImage.isEmpty
                      ? const Icon(Icons.person, size: 35, color: Colors.purple)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authVM.userName.isNotEmpty ? authVM.userName : "User",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        authVM.userEmail,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ⚙️ Settings Card
          _buildSettingCard(
            context,
            icon: Icons.dark_mode_rounded,
            title: "Dark Mode",
            value: authVM.isDarkMode,
            onChanged: (v) => authVM.toggleDarkMode(v),
          ),

          const SizedBox(height: 12),

          _buildSettingCard(
            context,
            icon: Icons.notifications_active_rounded,
            title: "Notifications",
            value: authVM.notificationsEnabled,
            onChanged: (v) => authVM.toggleNotifications(v),
          ),

          const SizedBox(height: 32),

          // 🚪 Logout Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            onPressed: () async {
              await authVM.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Signinscreen()),
                );
              }
            },
            icon: const Icon(Icons.logout_rounded, size: 22),
            label: Text(
              "Logout",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable Setting Card Widget
  Widget _buildSettingCard(BuildContext context,
      {required IconData icon,
        required String title,
        required bool value,
        required Function(bool) onChanged}) {
    final isDark = Provider.of<AuthViewModel>(context).isDarkMode;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        secondary: Icon(icon,
            color: isDark ? Colors.purpleAccent : Colors.purple, size: 28),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.purpleAccent,
      ),
    );
  }
}

