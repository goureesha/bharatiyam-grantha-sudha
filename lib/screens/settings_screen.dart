import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../services/storage_service.dart';

/// Settings screen for theme, script, and font preferences
class SettingsScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const SettingsScreen({super.key, required this.isDark, required this.onToggleTheme});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _scriptMode = 'dual';
  double _fontScale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final script = await StorageService.getScriptMode();
    final font = await StorageService.getFontSize();
    setState(() {
      _scriptMode = script;
      _fontScale = font;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final kBg = isDark ? AppTheme.kDarkBg : AppTheme.kLightBg;
    final kCard = isDark ? AppTheme.kDarkCard : AppTheme.kLightCard;
    final kText = isDark ? AppTheme.kDarkText : AppTheme.kLightText;
    final kMuted = isDark ? AppTheme.kDarkMuted : AppTheme.kLightMuted;
    final kBorder = isDark ? AppTheme.kDarkBorder : AppTheme.kLightBorder;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kCard,
        title: Text(
          'ಸೆಟ್ಟಿಂಗ್ಸ್ / Settings',
          style: TextStyle(color: AppTheme.kSaffron, fontWeight: FontWeight.w800, fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Theme ──
          _sectionTitle('ಥೀಮ್ / Theme', kText),
          const SizedBox(height: 8),
          _settingCard(
            kCard, kBorder,
            child: SwitchListTile(
              title: Text('ಡಾರ್ಕ್ ಮೋಡ್', style: TextStyle(color: kText, fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text(isDark ? 'ಸಕ್ರಿಯ / Active' : 'ನಿಷ್ಕ್ರಿಯ / Inactive', style: TextStyle(color: kMuted, fontSize: 12)),
              value: isDark,
              activeColor: AppTheme.kSaffron,
              onChanged: (_) => widget.onToggleTheme(),
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: AppTheme.kSaffron),
            ),
          ),

          const SizedBox(height: 24),

          // ── Script Display ──
          _sectionTitle('ಲಿಪಿ / Script Display', kText),
          const SizedBox(height: 8),
          _settingCard(
            kCard, kBorder,
            child: Column(
              children: [
                _scriptOption('dual', 'ಕನ್ನಡ + देवनागरी (ಎರಡೂ)', kText, kMuted),
                Divider(color: kBorder, height: 1),
                _scriptOption('kannada', 'ಕನ್ನಡ ಮಾತ್ರ', kText, kMuted),
                Divider(color: kBorder, height: 1),
                _scriptOption('devanagari', 'देवनागरी मात्र', kText, kMuted),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Font Size ──
          _sectionTitle('ಅಕ್ಷರ ಗಾತ್ರ / Font Size', kText),
          const SizedBox(height: 8),
          _settingCard(
            kCard, kBorder,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ಅ', style: TextStyle(color: kMuted, fontSize: 14)),
                      Text('${(_fontScale * 100).round()}%', style: TextStyle(color: AppTheme.kSaffron, fontWeight: FontWeight.w700, fontSize: 14)),
                      Text('ಅ', style: TextStyle(color: kMuted, fontSize: 28)),
                    ],
                  ),
                  Slider(
                    value: _fontScale,
                    min: 0.8,
                    max: 2.0,
                    divisions: 6,
                    activeColor: AppTheme.kSaffron,
                    onChanged: (v) async {
                      setState(() => _fontScale = v);
                      await StorageService.setFontSize(v);
                    },
                  ),
                  Text(
                    'ಮಾದರಿ ಪಠ್ಯ / Sample text',
                    style: TextStyle(color: kText, fontSize: 14 * _fontScale),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── About ──
          _sectionTitle('ಕುರಿತು / About', kText),
          const SizedBox(height: 8),
          _settingCard(
            kCard, kBorder,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('🙏', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text(
                    'ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ',
                    style: TextStyle(color: AppTheme.kSaffron, fontWeight: FontWeight.w800, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bharatiyam Grantha Sudha',
                    style: TextStyle(color: kMuted, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ವೈದಿಕ ಸಾಹಿತ್ಯದ ಅಪೂರ್ವ ಭಂಡಾರ\nA treasury of Vedic literature',
                    style: TextStyle(color: kMuted, fontSize: 12, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(color: kMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color kText) {
    return Text(
      title,
      style: TextStyle(color: kText, fontWeight: FontWeight.w800, fontSize: 15),
    );
  }

  Widget _settingCard(Color kCard, Color kBorder, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _scriptOption(String value, String label, Color kText, Color kMuted) {
    final selected = _scriptMode == value;
    return ListTile(
      title: Text(label, style: TextStyle(color: kText, fontSize: 14, fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
      trailing: selected
          ? Icon(Icons.check_circle, color: AppTheme.kSaffron, size: 22)
          : Icon(Icons.circle_outlined, color: kMuted, size: 22),
      onTap: () async {
        await StorageService.setScriptMode(value);
        setState(() => _scriptMode = value);
      },
    );
  }
}
