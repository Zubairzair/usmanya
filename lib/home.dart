import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:usmanya/add_record.dart';
import 'package:usmanya/addannouncement.dart';
import 'package:usmanya/addmultimedia.dart';
import 'package:usmanya/admincontrol.dart';
import 'package:usmanya/article.dart';
import 'package:usmanya/atya.dart';
import 'package:usmanya/contact.dart';
import 'package:usmanya/faq.dart';
import 'package:usmanya/privacy_policy.dart';
import 'package:usmanya/settings.dart';
import 'package:usmanya/staf.dart';
import 'package:usmanya/view_records.dart';
import 'package:usmanya/view_staff.dart';
import 'package:usmanya/viewannouncement.dart';
import 'package:usmanya/viewarticle.dart';
import 'package:usmanya/viewmulti.dart';
import 'package:usmanya/viewperformance.dart';
import 'about.dart' show AboutSchoolScreen;

class HomeDashboard extends StatefulWidget {
  final String role;
  final VoidCallback? onLogout;

  const HomeDashboard({super.key, this.role = 'user', this.onLogout});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 1;
  String fullMessage = "جامعہ عثمانیہ میں خوش آمدید!";
  int currentLength = 0;
  final TextEditingController _searchController = TextEditingController();

  bool get isAdmin => widget.role == 'admin' || widget.role == 'super_admin';

  @override
  void initState() {
    super.initState();
    startTypingAnimation();
  }

  void startTypingAnimation() async {
    while (mounted) {
      for (int i = 0; i <= fullMessage.length; i++) {
        await Future.delayed(const Duration(milliseconds: 150));
        setState(() {
          currentLength = i;
        });
      }
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        currentLength = 0;
      });
    }
  }

  void _navigateAndCloseDrawer(VoidCallback navigationAction) {
    Navigator.pop(context);
    navigationAction();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat(
      'dd MMMM yyyy',
      'ur_PK',
    ).format(DateTime.now());
    final String day = DateFormat('EEEE', 'ur_PK').format(DateTime.now());

    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('images/aqsda.jpeg'),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'جامعہ عثمانیہ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'سوڈھی جیوالی، ضلع خوشاب',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              Icons.home,
              'ہوم',
              () => _navigateAndCloseDrawer(
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeDashboard(
                      role: widget.role,
                      onLogout: widget.onLogout,
                    ),
                  ),
                ),
              ),
            ),
            if (isAdmin)
              _buildDrawerItem(
                Icons.edit_document,
                'مضمون شامل کریں',
                () => _navigateAndCloseDrawer(
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddArticleScreen()),
                  ),
                ),
              ),
            _buildDrawerItem(
              Icons.library_books,
              'مضامین',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewArticlesScreen(role: widget.role),
                  ),
                ),
              ),
            ),
            if (isAdmin)
              _buildDrawerItem(
                Icons.announcement,
                'اعلان شامل کریں',
                () => _navigateAndCloseDrawer(
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddAnnouncementScreen(),
                    ),
                  ),
                ),
              ),
            if (isAdmin)
              _buildDrawerItem(
                Icons.person_add,
                'ریکارڈ شامل کریں',
                () => _navigateAndCloseDrawer(
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddStudentScreen()),
                  ),
                ),
              ),
            _buildDrawerItem(
              Icons.visibility,
              'ریکارڈ دیکھیں',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentListScreen(
                      userRole: widget.role,
                      searchQuery: _searchController.text.trim(),
                    ),
                  ),
                ),
              ),
            ),
            _buildDrawerItem(
              Icons.announcement_outlined,
              'اعلانات',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewAnnouncementsScreen(role: widget.role),
                  ),
                ),
              ),
            ),

            _buildDrawerItem(
              Icons.video_library,
              ' اسلامک ملٹی میڈیا',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewMultimediaScreen(role: widget.role),
                  ),
                ),
              ),
            ),
            if (isAdmin)
              _buildDrawerItem(
                Icons.person_add,
                ' میڈیا لنک شامل کریں',
                () => _navigateAndCloseDrawer(
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddMultimediaScreen(),
                    ),
                  ),
                ),
              ),
            _buildDrawerItem(
              Icons.bar_chart,
              'کارکردگی دیکھیں',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ViewPerformanceScreen(),
                  ),
                ),
              ),
            ),

            _buildDrawerItem(
              Icons.settings,
              'ترتیبات',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
            ),

            _buildDrawerItem(
              Icons.info,
              'جامعہ کا تعارف',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutSchoolScreen()),
                ),
              ),
            ),
            _buildDrawerItem(
              Icons.help_outline,
              'سوالات',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FAQScreen()),
                ),
              ),
            ),
            _buildDrawerItem(
              Icons.contact_mail,
              'رابطہ کریں',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ContactUsScreen()),
                ),
              ),
            ),
            _buildDrawerItem(
              Icons.privacy_tip,
              'رازداری کی پالیسی',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()),
                ),
              ),
            ),
            if (widget.role == 'super_admin')
              _buildDrawerItem(
                Icons.admin_panel_settings,
                'ایڈمن کنٹرول',
                () => _navigateAndCloseDrawer(
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminControlPanel(),
                    ),
                  ),
                ),
              ),
            if (widget.role == 'super_admin')
              _buildDrawerItem(
                Icons.add_circle_outline_outlined,
                'سٹاف ایڈکریں',
                () => _navigateAndCloseDrawer(
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StaffAddScreen()),
                  ),
                ),
              ),
            _buildDrawerItem(
              Icons.volunteer_activism,
              'تعاون و عطیہ',
              () => _navigateAndCloseDrawer(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DonationScreen()),
                ),
              ),
            ),

            const Divider(),
            _buildDrawerItem(
              Icons.logout,
              'لاگ آؤٹ',
              () => _navigateAndCloseDrawer(_logout),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'جامعہ عثمانیہ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullMessage.substring(0, currentLength),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  today,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'طالب علم کو نام سے تلاش کریں...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentListScreen(
                      userRole: widget.role,
                      searchQuery: value.trim(),
                    ),
                  ),
                );
                _searchController.clear();
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardTile(
                    Icons.library_books,
                    'مضامین',
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewArticlesScreen(role: widget.role),
                        ),
                      );
                    },
                  ),
                  _buildDashboardTile(
                    Icons.announcement_outlined,
                    'اعلانات',
                    Colors.orange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ViewAnnouncementsScreen(role: widget.role),
                        ),
                      );
                    },
                  ),
                  _buildDashboardTile(
                    Icons.visibility,
                    'ریکارڈ دیکھیں',
                    Colors.purple,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentListScreen(
                            userRole: widget.role,
                            searchQuery: _searchController.text.trim(),
                          ),
                        ),
                      );
                    },
                  ),
                  if (isAdmin)
                    _buildDashboardTile(
                      Icons.edit_document,
                      'مضمون شامل کریں',
                      Colors.teal,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddArticleScreen(),
                          ),
                        );
                      },
                    ),
                  _buildDashboardTile(
                    Icons.bar_chart,
                    'کارگردگی دیکھیں',
                    Colors.teal,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewPerformanceScreen(),
                        ),
                      );
                    },
                  ),

                  if (isAdmin)
                    _buildDashboardTile(
                      Icons.person_add,
                      'لنک شامل کریں',
                      Colors.purple,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddMultimediaScreen(),
                          ),
                        );
                      },
                    ),

                  _buildDashboardTile(
                    Icons.volunteer_activism,
                    'تعاون و عطیہ',
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DonationScreen(),
                        ),
                      );
                    },
                  ),

                  if (isAdmin)
                    _buildDashboardTile(
                      Icons.announcement,
                      'اعلان شامل کریں',
                      Colors.teal,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddAnnouncementScreen(),
                          ),
                        );
                      },
                    ),
                  if (isAdmin)
                    _buildDashboardTile(
                      Icons.person_add,
                      'ریکارڈ شامل کریں',
                      Colors.purple,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddStudentScreen(),
                          ),
                        );
                      },
                    ),
                  _buildDashboardTile(
                    Icons.video_library,
                    ' اسلامک ملٹی میڈیا',
                    Colors.orange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ViewMultimediaScreen(role: widget.role),
                        ),
                      );
                    },
                  ),

                  _buildDashboardTile(
                    Icons.people,
                    ' سٹاف',
                    Colors.purple,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              StaffViewScreen(role: widget.role),
                        ),
                      );
                    },
                  ),

                  _buildDashboardTile(
                    Icons.settings,
                    ' سیٹنگ',
                    Colors.teal,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          }
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    HomeDashboard(role: widget.role, onLogout: widget.onLogout),
              ),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutSchoolScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'ترتیبات'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ہوم'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'تعارف'),
        ],
      ),
    );
  }

  Widget _buildDashboardTile(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color.withOpacity(0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
