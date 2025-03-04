import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_viewmodel.dart';

/// The Settings Screen allows users to customize their app's appearance and preferences.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the SettingsViewModel for managing user preferences.
    final settingsVM = Provider.of<SettingsViewModel>(context, listen: true);

    // Retrieve current theme and font scale settings.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fontScale = settingsVM.fontScale;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings', // Screen title.
          style: TextStyle(fontSize: 18 * fontScale),
        ),
        centerTitle: true,
        // Back button to return to the previous screen.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Main content of the screen.
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section for theme and appearance settings.
          Text(
            'Theme & Appearance',
            style: TextStyle(
              fontSize: 16 * fontScale,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Toggle for enabling/disabling dark mode.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dark Theme', style: TextStyle(fontSize: 16 * fontScale)),
              Switch(
                value: settingsVM.isDarkTheme, // Current dark theme status.
                onChanged: (value) {
                  settingsVM.setDarkTheme(value); // Update dark theme setting.
                },
              ),
            ],
          ),
          const Divider(), // Divider for better visual separation.

          // Font size customization slider.
          Text(
            'Font Size',
            style: TextStyle(fontSize: 16 * fontScale),
          ),
          Slider(
            min: 0.8, // Minimum font scale.
            max: 1.5, // Maximum font scale.
            divisions: 7, // Number of slider divisions for granularity.
            label: settingsVM.fontScale.toStringAsFixed(2), // Display current font scale.
            value: settingsVM.fontScale, // Current font scale.
            onChanged: (value) {
              settingsVM.setFontScale(value); // Update font scale value.
            },
          ),
          const SizedBox(height: 8),
          // Display the current font scale value.
          Text(
            'Current Scale: ${settingsVM.fontScale.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14 * fontScale,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),

          // Button to reset settings to default values.
          ElevatedButton.icon(
            onPressed: () {
              settingsVM.resetToDefault(); // Reset settings.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to default.')), // Confirmation message.
              );
            },
            icon: const Icon(Icons.refresh), // Icon for reset button.
            label: Text(
              'Reset to Default',
              style: TextStyle(fontSize: 16 * fontScale),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode
                  ? Colors.teal.shade700
                  : Colors.green.shade700, // Button color based on theme.
              foregroundColor: isDarkMode ? Colors.white : Colors.black, // Text color.
              padding: const EdgeInsets.symmetric(vertical: 12), // Padding for button content.
              minimumSize: const Size(double.infinity, 50), // Full-width button.
            ),
          ),
        ],
      ),
    );
  }
}
