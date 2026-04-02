import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../data/grantha_data.dart';
import '../models/grantha.dart';
import 'grantha_screen.dart';
import 'bookmarks_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const HomeScreen({super.key, required this.onToggleTheme, required this.isDark});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  String _searchQuery = '';
  String? _selectedCategory;
  int _currentIndex = 0;

  final List<String> _categories = ['ಎಲ್ಲಾ', 'ಸ್ತೋತ್ರ', 'ಶಾಸ್ತ್ರ', 'ಉಪನಿಷದ್', 'ಪುರಾಣ', 'ಕಾವ್ಯ'];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<Grantha> get _filteredGranthas {
    return allGranthas.where((g) {
      final matchesSearch = _searchQuery.isEmpty ||
          g.kannadaName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          g.devanagariName.contains(_searchQuery) ||
          g.englishName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null ||
          _selectedCategory == 'ಎಲ್ಲಾ' ||
          g.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final kBg = isDark ? AppTheme.kDarkBg : AppTheme.kLightBg;
    final kCard = isDark ? AppTheme.kDarkCard : AppTheme.kLightCard;
    final kText = isDark ? AppTheme.kDarkText : AppTheme.kLightText;
    final kMuted = isDark ? AppTheme.kDarkMuted : AppTheme.kLightMuted;
    final kBorder = isDark ? AppTheme.kDarkBorder : AppTheme.kLightBorder;

    final screens = [
      _buildLibraryView(isDark, kBg, kCard, kText, kMuted, kBorder),
      BookmarksScreen(isDark: isDark),
      SettingsScreen(isDark: isDark, onToggleTheme: widget.onToggleTheme),
    ];

    return Scaffold(
      backgroundColor: kBg,
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: kCard,
          border: Border(top: BorderSide(color: kBorder, width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.kSaffron,
          unselectedItemColor: kMuted,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: 'ಗ್ರಂಥಾಲಯ'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'ಪುಟಗುರುತು'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'ಸೆಟ್ಟಿಂಗ್ಸ್'),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryView(bool isDark, Color kBg, Color kCard, Color kText, Color kMuted, Color kBorder) {
    final filteredGranthas = _filteredGranthas;

    return CustomScrollView(
      slivers: [
        // ── App Bar ──
        SliverAppBar(
          expandedHeight: 180,
          floating: false,
          pinned: true,
          backgroundColor: isDark ? AppTheme.kDarkCard : AppTheme.kLightCard,
          flexibleSpace: FlexibleSpaceBar(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ',
                  style: TextStyle(
                    color: AppTheme.kSaffron,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Vedic Library',
                  style: TextStyle(
                    color: kMuted,
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [const Color(0xFF3A2510), AppTheme.kDarkCard]
                      : [const Color(0xFFFFF0D4), AppTheme.kLightCard],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Text(
                    '🙏',
                    style: TextStyle(fontSize: 48),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: AppTheme.kSaffron),
              onPressed: widget.onToggleTheme,
            ),
          ],
        ),

        // ── Search Bar ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: TextStyle(color: kText, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'ಶ್ಲೋಕ ಅಥವಾ ಗ್ರಂಥ ಹುಡುಕಿ...',
                  hintStyle: TextStyle(color: kMuted, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: AppTheme.kSaffron),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ),

        // ── Category Filter ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final selected = (_selectedCategory ?? 'ಎಲ್ಲಾ') == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat, style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : kMuted,
                    )),
                    selected: selected,
                    selectedColor: AppTheme.kSaffron,
                    backgroundColor: kCard,
                    side: BorderSide(color: selected ? AppTheme.kSaffron : kBorder),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // ── Book Grid ──
        filteredGranthas.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off, size: 64, color: kMuted),
                      const SizedBox(height: 12),
                      Text('ಯಾವುದೇ ಗ್ರಂಥ ಕಂಡುಬಂದಿಲ್ಲ', style: TextStyle(color: kMuted, fontSize: 14)),
                    ],
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final grantha = filteredGranthas[index];
                      return _GranthaCard(
                        grantha: grantha,
                        isDark: isDark,
                        delay: index * 100,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GranthaScreen(grantha: grantha, isDark: isDark),
                            ),
                          );
                        },
                      );
                    },
                    childCount: filteredGranthas.length,
                  ),
                ),
              ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

/// ── Animated Book Card Widget ──
class _GranthaCard extends StatefulWidget {
  final Grantha grantha;
  final bool isDark;
  final int delay;
  final VoidCallback onTap;

  const _GranthaCard({required this.grantha, required this.isDark, required this.delay, required this.onTap});

  @override
  State<_GranthaCard> createState() => _GranthaCardState();
}

class _GranthaCardState extends State<_GranthaCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.grantha;
    final isDark = widget.isDark;
    final kCard = isDark ? AppTheme.kDarkCard : AppTheme.kLightCard;
    final kText = isDark ? AppTheme.kDarkText : AppTheme.kLightText;
    final kMuted = isDark ? AppTheme.kDarkMuted : AppTheme.kLightMuted;
    final kBorder = isDark ? AppTheme.kDarkBorder : AppTheme.kLightBorder;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBorder.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.kSaffron.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Book cover area ──
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [const Color(0xFF3A2510), const Color(0xFF2A1A08)]
                            : [const Color(0xFFFFF5E0), const Color(0xFFF5E6C8)],
                      ),
                    ),
                    child: Center(
                      child: Text(g.icon, style: const TextStyle(fontSize: 48)),
                    ),
                  ),
                ),
                // ── Info area ──
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g.kannadaName,
                          style: TextStyle(
                            color: kText,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          g.englishName,
                          style: TextStyle(color: kMuted, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.kSaffron.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                g.category,
                                style: TextStyle(
                                  color: AppTheme.kSaffron,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${g.shlokaCount} ಶ್ಲೋಕ',
                              style: TextStyle(color: kMuted, fontSize: 9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
