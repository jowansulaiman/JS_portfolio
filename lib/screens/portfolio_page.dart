// lib/screens/portfolio_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:js_portfolio/app/data_loader.dart';
import 'package:js_portfolio/widgets/common/quick_contact_fab.dart';
import 'package:js_portfolio/widgets/sections/certificates_section.dart'; // Muss noch angepasst werden
import 'package:js_portfolio/widgets/sections/footer.dart';
import 'package:js_portfolio/widgets/sections/hero_section.dart';
import 'package:js_portfolio/widgets/sections/languages_section.dart';
import 'package:js_portfolio/widgets/sections/nav/floating_glass_navbar.dart';
import 'package:js_portfolio/widgets/sections/projects_section.dart'; // Muss noch angepasst werden
import 'package:js_portfolio/widgets/sections/skills_section.dart';
import 'package:js_portfolio/widgets/sections/timeline_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// DataProvider macht die geladenen Daten für alle untergeordneten Widgets verfügbar.
class DataProvider extends InheritedWidget {
  final PortfolioData data;
  const DataProvider({super.key, required this.data, required super.child});

  static DataProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataProvider>();
  }

  @override
  bool updateShouldNotify(covariant DataProvider oldWidget) {
    return data != oldWidget.data;
  }
}


class PortfolioPage extends StatefulWidget {
  final PortfolioData data;
  final VoidCallback toggleTheme;

  const PortfolioPage({super.key, required this.data, required this.toggleTheme});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _sectionKeys = List.generate(7, (_) => GlobalKey());
  final _scrollViewKey = GlobalKey();
  final _scrollController = ScrollController();
  final _activeIndexNotifier = ValueNotifier<int>(0);
  bool _isUnlocked = false;

  @override
  void initState() {
    super.initState();
    _loadUnlockedState();
    _scrollController.addListener(_onScroll);
  }

  // HINWEIS: Hier kommt die gesamte Logik aus deinem alten _HomeScreenState hinein
  // (dispose, _loadUnlockedState, _saveUnlockedState, _onScroll, _scrollToSection,
  // _requestAccess, _showAccessCodeDialog, _validateCode, _lockPage)
  // ...
  // WICHTIG: Ersetze in _validateCode "AppData.permanentAccessCode" durch einen festen String,
  // z.B. "1234", da AppData nicht mehr existiert.

  @override
  Widget build(BuildContext context) {
    return DataProvider( // Stellt die Daten dem Widget-Baum zur Verfügung
      data: widget.data,
      child: Scaffold(
        floatingActionButton: _isUnlocked ? const QuickContactFAB() : null,
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                  key: _scrollViewKey,
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                        child: HeroSection(
                          key: _sectionKeys[0],
                          onJump: _scrollToSection,
                          isUnlocked: _isUnlocked,
                          onUnlock: _showAccessCodeDialog,
                          onAccessRequest: _requestAccess,
                        )),
                    if (_isUnlocked) ...[
                      SliverToBoxAdapter(child: TimelineSection(key: _sectionKeys[1])),
                      SliverToBoxAdapter(child: ProjectsSection(key: _sectionKeys[2])),
                      SliverToBoxAdapter(child: SkillsSection(key: _sectionKeys[3])),
                      SliverToBoxAdapter(child: LanguagesSection(key: _sectionKeys[4])),
                      SliverToBoxAdapter(child: CertificatesSection(key: _sectionKeys[5])),
                      SliverToBoxAdapter(child: Footer(key: _sectionKeys[6])),
                    ]
                  ]),
              FloatingGlassNavBar(
                onJump: _scrollToSection,
                toggleTheme: widget.toggleTheme,
                activeIndexNotifier: _activeIndexNotifier,
                isUnlocked: _isUnlocked,
                onUnlock: _showAccessCodeDialog,
                onLock: _lockPage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HIER DIE LOGIK EINFÜGEN ---
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _activeIndexNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadUnlockedState() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isUnlocked = prefs.getBool('isUnlocked') ?? false;
      });
    }
  }

  Future<void> _saveUnlockedState(bool isUnlocked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUnlocked', isUnlocked);
  }

  void _onScroll() {
    if (!_scrollController.hasClients || !mounted) return;
    final RenderBox? scrollBox = _scrollViewKey.currentContext?.findRenderObject() as RenderBox?;
    if (scrollBox == null) return;
    final scrollBoxPosition = scrollBox.localToGlobal(Offset.zero);
    final viewportCenterY = scrollBoxPosition.dy + (scrollBox.size.height / 2);
    int newIndex = _activeIndexNotifier.value;
    for (int i = (_isUnlocked ? _sectionKeys.length : 1) - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      if (key.currentContext != null) {
        final box = key.currentContext!.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        if (position.dy <= viewportCenterY && (position.dy + box.size.height) > viewportCenterY) {
          newIndex = i;
          break;
        }
      }
    }
    if (_activeIndexNotifier.value != newIndex) {
      _activeIndexNotifier.value = newIndex;
    }
  }

  void _scrollToSection(int index) {
    if (_sectionKeys[index].currentContext != null) {
      _activeIndexNotifier.value = index;
      Scrollable.ensureVisible(
        _sectionKeys[index].currentContext!,
        duration: 600.ms,
        curve: Curves.easeInOut,
      );
    }
  }

  void _requestAccess() {
    final Uri mailUri = Uri(
      scheme: 'mailto',
      path: widget.data.personalInfo.email,
      query: 'subject=Zugangsanfrage%20f%C3%BCr%20Dein%20Portfolio&body=Hallo%20Jowan,',
    );
    launchUrl(mailUri);
  }

  Future<void> _showAccessCodeDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const _AccessCodeDialog(),
    );
    if (result == 'request_access') {
      _requestAccess();
    } else if (result != null && result.isNotEmpty) {
      _validateCode(result);
    }
  }

  void _validateCode(String code) {
    const permanentAccessCode = "1234";
    const temporaryAccessCode = "GUEST24";

    if (code == permanentAccessCode) {
      setState(() => _isUnlocked = true);
      _saveUnlockedState(true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Willkommen! Dauerhaft freigeschaltet.'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
    } else if (code == temporaryAccessCode) {
      setState(() => _isUnlocked = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Willkommen! Temporär freigeschaltet.'), backgroundColor: Colors.blue, duration: Duration(seconds: 2)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falscher Code.'), backgroundColor: Colors.red, duration: Duration(seconds: 2)));
    }
  }

  void _lockPage() {
    setState(() => _isUnlocked = false);
    _saveUnlockedState(false);
    _scrollToSection(0);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seite gesperrt.'), duration: Duration(seconds: 2)));
  }
}
// Das _AccessCodeDialog Widget muss hierher kopiert werden (aus der alten home_screen.dart)
class _AccessCodeDialog extends StatefulWidget {
  const _AccessCodeDialog();
  @override
  State<_AccessCodeDialog> createState() => _AccessCodeDialogState();
}
class _AccessCodeDialogState extends State<_AccessCodeDialog> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_open_outlined, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('Portfolio freischalten', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Bitte gib den Zugangscode ein, um alle Inhalte zu sehen.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              autofocus: true,
              obscureText: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, letterSpacing: 4),
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Zugangscode', prefixIcon: Icon(Icons.key_outlined)),
              onSubmitted: (code) => Navigator.pop(context, code),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _controller.text),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Freischalten'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context, 'request_access'),
              child: const Text('Zugang anfragen'),
            ),
          ],
        ),
      ),
    );
  }
}