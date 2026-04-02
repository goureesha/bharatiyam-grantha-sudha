import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/grantha.dart';
import 'shloka_reader_screen.dart';

/// Screen that lists all chapters (Adhyayas) of a selected Grantha
class GranthaScreen extends StatelessWidget {
  final Grantha grantha;
  final bool isDark;

  const GranthaScreen({super.key, required this.grantha, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final kBg = isDark ? AppTheme.kDarkBg : AppTheme.kLightBg;
    final kCard = isDark ? AppTheme.kDarkCard : AppTheme.kLightCard;
    final kText = isDark ? AppTheme.kDarkText : AppTheme.kLightText;
    final kMuted = isDark ? AppTheme.kDarkMuted : AppTheme.kLightMuted;
    final kBorder = isDark ? AppTheme.kDarkBorder : AppTheme.kLightBorder;

    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: kCard,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: kText),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                grantha.kannadaName,
                style: TextStyle(
                  color: AppTheme.kSaffron,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [const Color(0xFF3A2510), kCard]
                        : [const Color(0xFFFFF0D4), kCard],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(grantha.icon, style: const TextStyle(fontSize: 56)),
                      const SizedBox(height: 8),
                      Text(
                        grantha.devanagariName,
                        style: TextStyle(
                          color: kMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${grantha.author} • ${grantha.shlokaCount} ಶ್ಲೋಕಗಳು',
                        style: TextStyle(color: kMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Description ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kBorder.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: AppTheme.kSaffron),
                        const SizedBox(width: 8),
                        Text(
                          'ಪರಿಚಯ / About',
                          style: TextStyle(
                            color: AppTheme.kSaffron,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      grantha.description,
                      style: TextStyle(color: kMuted, fontSize: 13, height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Section Title ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'ಅಧ್ಯಾಯಗಳು / Chapters',
                style: TextStyle(
                  color: kText,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          // ── Chapter List ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final adhyaya = grantha.adhyayas[index];
                return _AdhyayaTile(
                  adhyaya: adhyaya,
                  grantha: grantha,
                  isDark: isDark,
                  index: index,
                );
              },
              childCount: grantha.adhyayas.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _AdhyayaTile extends StatelessWidget {
  final Adhyaya adhyaya;
  final Grantha grantha;
  final bool isDark;
  final int index;

  const _AdhyayaTile({required this.adhyaya, required this.grantha, required this.isDark, required this.index});

  @override
  Widget build(BuildContext context) {
    final kCard = isDark ? AppTheme.kDarkCard : AppTheme.kLightCard;
    final kText = isDark ? AppTheme.kDarkText : AppTheme.kLightText;
    final kMuted = isDark ? AppTheme.kDarkMuted : AppTheme.kLightMuted;
    final kBorder = isDark ? AppTheme.kDarkBorder : AppTheme.kLightBorder;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShlokaReaderScreen(
                  grantha: grantha,
                  adhyaya: adhyaya,
                  isDark: isDark,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBorder.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                // Chapter number circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppTheme.kSaffron, AppTheme.kDeepSaffron],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${adhyaya.number}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Chapter info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adhyaya.kannadaName,
                        style: TextStyle(
                          color: kText,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${adhyaya.devanagariName} • ${adhyaya.shlokas.length} ಶ್ಲೋಕ',
                        style: TextStyle(color: kMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppTheme.kSaffron),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
