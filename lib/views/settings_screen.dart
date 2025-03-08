import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsVM = Provider.of<SettingsViewModel>(context, listen: true);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fontScale = settingsVM.fontScale;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 18 * fontScale),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Theme & Appearance',
            style: TextStyle(
              fontSize: 16 * fontScale,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dark Theme', style: TextStyle(fontSize: 16 * fontScale)),
              Switch(
                value: settingsVM.isDarkTheme,
                onChanged: (value) {
                  settingsVM.setDarkTheme(value);
                },
              ),
            ],
          ),
          const Divider(),

          Text(
            'Font Size',
            style: TextStyle(fontSize: 16 * fontScale),
          ),
          Slider(
            min: 0.8,
            max: 1.5,
            divisions: 7,
            label: settingsVM.fontScale.toStringAsFixed(2),
            value: settingsVM.fontScale,
            onChanged: (value) {
              settingsVM.setFontScale(value);
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Current Scale: ${settingsVM.fontScale.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14 * fontScale,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              settingsVM.resetToDefault();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to default.')),
              );
            },
            icon: const Icon(Icons.refresh),
            label: Text(
              'Reset to Default',
              style: TextStyle(fontSize: 16 * fontScale),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode
                  ? Colors.teal.shade700
                  : Colors.green.shade700,
              foregroundColor: isDarkMode ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
