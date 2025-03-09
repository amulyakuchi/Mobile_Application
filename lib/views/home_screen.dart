import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsVM = Provider.of<SettingsViewModel>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.6)
                  : Colors.grey.shade300.withOpacity(0.8),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'NomNom',
                style: TextStyle(
                  fontSize: 22 * settingsVM.fontScale,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  tooltip: 'Settings',
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/home_background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.teal.shade900
                          : Colors.green.shade800,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Welcome to NomNom',
                          style: TextStyle(
                            fontSize: 22 * settingsVM.fontScale,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Discover recipes at your fingertips. Save your favorites and explore new cuisines every day.',
                          style: TextStyle(
                            fontSize: 16 * settingsVM.fontScale,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/ingredient_input'),
                    icon: Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Find Recipes',
                      style: TextStyle(
                        fontSize: 18 * settingsVM.fontScale,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? Colors.teal.shade800
                          : Colors.green.shade700,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/favorites'),
                    icon: Icon(
                      Icons.favorite,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: Text(
                      'View Favorites',
                      style: TextStyle(
                        fontSize: 18 * settingsVM.fontScale,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? Colors.teal.shade800
                          : Colors.green.shade700,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
