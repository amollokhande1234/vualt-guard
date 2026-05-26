import 'package:flutter/material.dart';

import '../widgets/action_button.dart';
import '../widgets/file_card.dart';
import '../widgets/header.dart';
import '../widgets/stat_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: 0,
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.lock_outline),
            selectedIcon: Icon(Icons.lock),
            label: "Vault",
          ),
          NavigationDestination(
            icon: Icon(Icons.share_outlined),
            selectedIcon: Icon(Icons.share),
            label: "Shared",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),

              const SizedBox(height: 24),

              const Text(
                "Security Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: const [
                  StatCard(title: "Protected", value: "128"),
                  StatCard(title: "Locked", value: "95"),
                  StatCard(title: "Shared", value: "14"),
                  StatCard(title: "Expiring", value: "7"),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                "Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 16),

              Row(
                children: const [
                  Expanded(
                    child: ActionButton(icon: Icons.upload, title: "Upload"),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ActionButton(icon: Icons.lock, title: "Lock"),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: const [
                  Expanded(
                    child: ActionButton(icon: Icons.share, title: "Share"),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ActionButton(icon: Icons.history, title: "Activity"),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                "Recent Files",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 12),

              const FileCard(
                title: "Passport.jpg",
                subtitle: "Expires in 2 hours",
              ),

              const SizedBox(height: 12),

              const FileCard(
                title: "Family.jpg",
                subtitle: "Shared with 2 users",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
