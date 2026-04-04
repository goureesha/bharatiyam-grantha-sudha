import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../app_theme.dart';
import '../models/grantha.dart';
import '../services/storage_service.dart';

/// The core reading experience — dual-script Shloka display
class ShlokaReaderScreen extends StatefulWidget {
  final Grantha grantha;
  final Adhyaya adhyaya;
  final bool isDark;
  final int initialIndex;

  const ShlokaReaderScreen({
    super.key,
    required this.grantha,
    required this.adhyaya,
    required this.isDark,
    this.initialIndex = 0,
  });

  @override
  State<ShlokaReaderScreen> createState() => _ShlokaReaderScreenState();
}

class _ShlokaReaderScreenState extends State<ShlokaReaderScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Set<String> _bookmarks = {};
  String _scriptMode = 'dual'; // 'dual', 'kannada', 'devanagari'
  String _readMode = 'swipe'; // 'swipe' or 'scroll'
  double _fontScale = 1.0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final bookmarks = await StorageService.getBookmarks();
    final script = await StorageService.getScriptMode();
    final readMode = await StorageService.getReadMode();
    final fontSize = await StorageService.getFontSize();
    setState(() {
      _bookmarks = bookmarks;
      _scriptMode = script;
      _readMode = readMode;
      _fontScale = fontSize;
    });
  }

  @override
  void dispose() {
    // Save last read position
    StorageService.setLastRead(widget.grantha.id, widget.adhyaya.id, _currentPage);
    _pageController.dispose();
    super.dispose();
  }

  void _toggleBookmark(String shlokaId) async {
    await StorageService.toggleBookmark(shlokaId);
    final bookmarks = await StorageService.getBookmarks();
    setState(() => _bookmarks = bookmarks);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _bookmarks.contains(shlokaId) ? 'ಪುಟಗುರುತು ಸೇರಿಸಲಾಗಿದೆ ✓' : 'ಪುಟಗುರುತು ತೆಗೆಯಲಾಗಿದೆ',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.kSaffron,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _shareShloka(Shloka shloka) {
    final text = '${shloka.kannadaText}\n\n${shloka.devanagariText}\n\n'
        '— ${widget.grantha.kannadaName}, ${widget.adhyaya.kannadaName} (${shloka.number})\n'
        '📖 ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ';
    Share.share(text);
  }

  void _copyShloka(Shloka shloka) {
    final text = '${shloka.kannadaText}\n\n${shloka.devanagariText}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('ಶ್ಲೋಕ ಕಾಪಿ ಆಗಿದೆ ✓'),
        backgroundColor: AppTheme.kSaffron,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final kBg = isDark ? AppTheme.kDarkBg : AppTheme.kLightBg;
    final kCard = isDark ? AppTheme.kDarkCard : AppTheme.kLightCard;
    final kText = isDark ? AppTheme.kDarkText : AppTheme.kLightText;
    final kMuted = isDark ? AppTheme.kDarkMuted : AppTheme.kLightMuted;
    final shlokas = widget.adhyaya.shlokas;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kCard,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              widget.adhyaya.kannadaName,
              style: TextStyle(color: AppTheme.kSaffron, fontWeight: FontWeight.w800, fontSize: 14),
            ),
            Text(
              '${widget.grantha.englishName} • ${_currentPage + 1}/${shlokas.length}',
              style: TextStyle(color: kMuted, fontSize: 10),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Font Size
          IconButton(
            icon: Icon(Icons.text_fields, color: AppTheme.kSaffron, size: 22),
            onPressed: () => _showFontSizeDialog(kCard, kText, kMuted),
          ),
          // Read mode toggle
          IconButton(
            icon: Icon(_readMode == 'swipe' ? Icons.swap_horiz : Icons.swap_vert, color: AppTheme.kSaffron, size: 24),
            onPressed: () async {
              final newMode = _readMode == 'swipe' ? 'scroll' : 'swipe';
              await StorageService.setReadMode(newMode);
              setState(() => _readMode = newMode);
            },
            tooltip: _readMode == 'swipe' ? 'ಸ್ವೈಪ್ ಮೋಡ್ (Scroll Mode ಗೆ ಬದಲಾಯಿಸಿ)' : 'ಸ್ಕ್ರಾಲ್ ಮೋಡ್ (Swipe Mode ಗೆ ಬದಲಾಯಿಸಿ)',
          ),
          // Script toggle popup
          PopupMenuButton<String>(
            icon: Icon(Icons.translate, color: AppTheme.kSaffron, size: 22),
            color: kCard,
            onSelected: (v) async {
              await StorageService.setScriptMode(v);
              setState(() => _scriptMode = v);
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'dual', child: Text('ಕನ್ನಡ + देवनागरी', style: TextStyle(color: kText, fontSize: 13))),
              PopupMenuItem(value: 'kannada', child: Text('ಕನ್ನಡ ಮಾತ್ರ', style: TextStyle(color: kText, fontSize: 13))),
              PopupMenuItem(value: 'devanagari', child: Text('देवनागरी मात्र', style: TextStyle(color: kText, fontSize: 13))),
            ],
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Shloka View ──
          Expanded(
            child: _readMode == 'swipe'
                ? PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: shlokas.length,
                    itemBuilder: (context, index) {
                      final shloka = shlokas[index];
                      final isBookmarked = _bookmarks.contains(shloka.id);
                      return _buildShlokaPage(shloka, isBookmarked, isDark, kCard, kText, kMuted, isScrollMode: false);
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    itemCount: shlokas.length,
                    itemBuilder: (context, index) {
                      final shloka = shlokas[index];
                      final isBookmarked = _bookmarks.contains(shloka.id);
                      return _buildShlokaPage(shloka, isBookmarked, isDark, kCard, kText, kMuted, isScrollMode: true);
                    },
                  ),
          ),

          // ── Bottom Controls (Only in Swipe Mode) ──
          if (_readMode == 'swipe')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: kCard,
                border: Border(top: BorderSide(color: isDark ? AppTheme.kDarkBorder : AppTheme.kLightBorder, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Previous
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: _currentPage > 0 ? AppTheme.kSaffron : kMuted, size: 32),
                    onPressed: _currentPage > 0
                        ? () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
                        : null,
                  ),
                  // Bookmark
                  IconButton(
                    icon: Icon(
                      _bookmarks.contains(shlokas[_currentPage].id) ? Icons.bookmark : Icons.bookmark_border,
                      color: AppTheme.kSaffron,
                      size: 24,
                    ),
                    onPressed: () => _toggleBookmark(shlokas[_currentPage].id),
                  ),
                  // Share
                  IconButton(
                    icon: Icon(Icons.share, color: AppTheme.kSaffron, size: 22),
                    onPressed: () => _shareShloka(shlokas[_currentPage]),
                  ),
                  // Copy
                  IconButton(
                    icon: Icon(Icons.copy, color: AppTheme.kSaffron, size: 22),
                    onPressed: () => _copyShloka(shlokas[_currentPage]),
                  ),
                  // Next
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: _currentPage < shlokas.length - 1 ? AppTheme.kSaffron : kMuted, size: 32),
                    onPressed: _currentPage < shlokas.length - 1
                        ? () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShlokaPage(Shloka shloka, bool isBookmarked, bool isDark, Color kCard, Color kText, Color kMuted, {bool isScrollMode = false}) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isScrollMode && shloka.number > 1) const Divider(height: 48, thickness: 1),
        
        // ── Shloka Number Badge & Actions ──
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.kSaffron.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.kSaffron.withOpacity(0.3)),
              ),
              child: Text(
                'ಶ್ಲೋಕ ${shloka.number}',
                style: TextStyle(
                  color: AppTheme.kSaffron,
                  fontWeight: FontWeight.w700,
                  fontSize: 13 * _fontScale,
                ),
              ),
            ),
            if (isScrollMode) ...[
              const Spacer(),
              IconButton(
                icon: Icon(Icons.share, size: 20, color: kMuted),
                onPressed: () => _shareShloka(shloka),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.copy, size: 20, color: kMuted),
                onPressed: () => _copyShloka(shloka),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),

          // ── Kannada Text ──
          if (_scriptMode == 'dual' || _scriptMode == 'kannada') ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.kSaffron.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.kSaffron.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.kSaffron.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ಕನ್ನಡ',
                          style: TextStyle(
                            color: AppTheme.kSaffron,
                            fontSize: 10 * _fontScale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    shloka.kannadaText,
                    style: TextStyle(
                      color: kText,
                      fontSize: 18 * _fontScale,
                      fontWeight: FontWeight.w500,
                      height: 2.0,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Devanagari Text ──
          if ((_scriptMode == 'dual' || _scriptMode == 'devanagari') && shloka.devanagariText.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.kMaroon.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.kMaroon.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.kMaroon.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'देवनागरी',
                          style: TextStyle(
                            color: AppTheme.kMaroon,
                            fontSize: 10 * _fontScale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    shloka.devanagariText,
                    style: TextStyle(
                      color: kText,
                      fontSize: 18 * _fontScale,
                      fontWeight: FontWeight.w500,
                      height: 2.0,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Meaning ──
          if (shloka.kannadaMeaning != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.kDarkSurface : AppTheme.kLightSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.kAccentGreen.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 16, color: AppTheme.kAccentGreen),
                      const SizedBox(width: 6),
                      Text(
                        'ಅರ್ಥ / Meaning',
                        style: TextStyle(
                          color: AppTheme.kAccentGreen,
                          fontSize: 11 * _fontScale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    shloka.kannadaMeaning!,
                    style: TextStyle(
                      color: kText,
                      fontSize: 14 * _fontScale,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Vyakhyana ──
          if (shloka.kannadaVyakhyana != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.kSaffron.withOpacity(isDark ? 0.05 : 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.kSaffron.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book, size: 16, color: AppTheme.kSaffron),
                      const SizedBox(width: 6),
                      Text(
                        'ವ್ಯಾಖ್ಯಾನ / Commentary',
                        style: TextStyle(
                          color: AppTheme.kSaffron,
                          fontSize: 11 * _fontScale,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    shloka.kannadaVyakhyana!,
                    style: TextStyle(
                      color: kText,
                      fontSize: 14 * _fontScale,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          if (!isScrollMode) ...[
            const SizedBox(height: 24),
            // ── Page indicator dots ──
            Center(
              child: Text(
                '← ಸ್ವೈಪ್ ಮಾಡಿ / Swipe →',
                style: TextStyle(color: kMuted, fontSize: 11),
              ),
            ),
          ],
        ],
      );

    if (isScrollMode) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: content,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: content,
    );
  }

  void _showFontSizeDialog(Color kCard, Color kText, Color kMuted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kCard,
        title: Text('ಅಕ್ಷರ ಗಾತ್ರ / Font Size', style: TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w700)),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: _fontScale,
                  min: 0.8,
                  max: 2.0,
                  divisions: 6,
                  activeColor: AppTheme.kSaffron,
                  label: '${(_fontScale * 100).round()}%',
                  onChanged: (v) {
                    setDialogState(() => _fontScale = v);
                    setState(() {}); // update parent too
                  },
                ),
                Text(
                  'ಮಾದರಿ / Preview: ${(_fontScale * 100).round()}%',
                  style: TextStyle(color: kMuted, fontSize: 12 * _fontScale),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await StorageService.setFontSize(_fontScale);
              Navigator.pop(context);
            },
            child: Text('ಸರಿ / OK', style: TextStyle(color: AppTheme.kSaffron, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
