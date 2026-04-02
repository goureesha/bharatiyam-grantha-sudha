import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../data/grantha_data.dart';
import '../models/grantha.dart';
import '../services/storage_service.dart';
import 'shloka_reader_screen.dart';

/// Bookmarks screen showing all saved shlokas
class BookmarksScreen extends StatefulWidget {
  final bool isDark;

  const BookmarksScreen({super.key, required this.isDark});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  Set<String> _bookmarks = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await StorageService.getBookmarks();
    setState(() {
      _bookmarks = bookmarks;
      _loading = false;
    });
  }

  /// Find a shloka by ID across all granthas
  _BookmarkedShloka? _findShloka(String id) {
    for (final g in allGranthas) {
      for (final a in g.adhyayas) {
        for (int i = 0; i < a.shlokas.length; i++) {
          if (a.shlokas[i].id == id) {
            return _BookmarkedShloka(grantha: g, adhyaya: a, shloka: a.shlokas[i], index: i);
          }
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final kBg = isDark ? AppTheme.kDarkBg : AppTheme.kLightBg;
    final kCard = isDark ? AppTheme.kDarkCard : AppTheme.kLightCard;
    final kText = isDark ? AppTheme.kDarkText : AppTheme.kLightText;
    final kMuted = isDark ? AppTheme.kDarkMuted : AppTheme.kLightMuted;
    final kBorder = isDark ? AppTheme.kDarkBorder : AppTheme.kLightBorder;

    final bookmarkedShlokas = _bookmarks.map(_findShloka).where((s) => s != null).toList();

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kCard,
        title: Text(
          'ಪುಟಗುರುತು / Bookmarks',
          style: TextStyle(color: AppTheme.kSaffron, fontWeight: FontWeight.w800, fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.kSaffron))
          : bookmarkedShlokas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_border, size: 72, color: kMuted),
                      const SizedBox(height: 16),
                      Text(
                        'ಯಾವುದೇ ಶ್ಲೋಕ ಉಳಿಸಿಲ್ಲ',
                        style: TextStyle(color: kMuted, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'ಶ್ಲೋಕ ಓದುವಾಗ bookmark ಐಕಾನ್ ಒತ್ತಿ',
                        style: TextStyle(color: kMuted, fontSize: 12),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookmarkedShlokas.length,
                  itemBuilder: (context, index) {
                    final bs = bookmarkedShlokas[index]!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: kCard,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ShlokaReaderScreen(
                                  grantha: bs.grantha,
                                  adhyaya: bs.adhyaya,
                                  isDark: isDark,
                                  initialIndex: bs.index,
                                ),
                              ),
                            );
                            _loadBookmarks(); // Refresh after returning
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: kBorder.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.bookmark, color: AppTheme.kSaffron, size: 18),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '${bs.grantha.kannadaName} • ${bs.adhyaya.kannadaName}',
                                        style: TextStyle(
                                          color: AppTheme.kSaffron,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Remove bookmark
                                    IconButton(
                                      icon: Icon(Icons.close, size: 18, color: kMuted),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () async {
                                        await StorageService.toggleBookmark(bs.shloka.id);
                                        _loadBookmarks();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bs.shloka.kannadaText,
                                  style: TextStyle(color: kText, fontSize: 13, height: 1.6),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ಶ್ಲೋಕ ${bs.shloka.number}',
                                  style: TextStyle(color: kMuted, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _BookmarkedShloka {
  final Grantha grantha;
  final Adhyaya adhyaya;
  final Shloka shloka;
  final int index;

  _BookmarkedShloka({required this.grantha, required this.adhyaya, required this.shloka, required this.index});
}
