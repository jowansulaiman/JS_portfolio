// lib/widgets/sections/nav/floating_glass_navbar.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:js_portfolio/app/app_data.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/glass_box.dart';

class FloatingGlassNavBar extends StatelessWidget {
  final void Function(int) onJump;
  final VoidCallback toggleTheme;
  final ValueNotifier<int> activeIndexNotifier;
  final bool isUnlocked;
  final VoidCallback onUnlock;
  final VoidCallback onLock;

  const FloatingGlassNavBar({
    super.key,
    required this.onJump,
    required this.toggleTheme,
    required this.activeIndexNotifier,
    required this.isUnlocked,
    required this.onUnlock,
    required this.onLock,
  });

  @override
  Widget build(BuildContext context) {
    final navItemsToShow = isUnlocked ? AppData.navItems : [AppData.navItems.first];

    // GEÄNDERT: Das mobile Menü wurde komplett überarbeitet
    if (context.isPhone) {
      return Positioned(
        top: 16, right: 16,
        child: Row(
          children: [
            FloatingActionButton.small(
              heroTag: 'unlockFabMobile',
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: isUnlocked ? onLock : onUnlock,
              child: Icon(isUnlocked ? Icons.lock_open_outlined : Icons.lock_outline_rounded),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              heroTag: 'navBurger',
              backgroundColor: Theme.of(context).colorScheme.surface,
              onPressed: () => showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(navItemsToShow.length, (i) => ListTile(
                          leading: Icon(navItemsToShow[i].icon),
                          title: Text(navItemsToShow[i].label),
                          onTap: () { Navigator.pop(context); onJump(i); }
                      )),
                      const Divider(),
                      ListTile(
                          leading: const Icon(Icons.brightness_6_outlined),
                          title: const Text('Theme wechseln'),
                          onTap: () { Navigator.pop(context); toggleTheme(); }
                      )
                    ],
                  ),
                ),
              ),
              child: const Icon(Icons.menu),
            ),
          ],
        ),
      );
    }

    // Desktop-Version verwendet jetzt auch die neuen Begriffe
    return Positioned(
      top: 24, right: 24,
      child: ValueListenableBuilder<int>(
        valueListenable: activeIndexNotifier,
        builder: (context, activeIndex, _) {
          return GlassBox(
            r: 28,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(children: [
              ...List.generate(
                  navItemsToShow.length,
                      (i) => InkWell(
                    onTap: () => onJump(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(navItemsToShow[i].label), // .label verwenden
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: 200.ms,
                          height: 2,
                          width: activeIndex == i ? 20 : 0,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(2)
                          ),
                        ),
                      ]),
                    ),
                  )),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(isUnlocked ? Icons.lock_open_outlined : Icons.lock_outline_rounded),
                tooltip: isUnlocked ? 'Seite sperren' : 'Inhalte freischalten',
                onPressed: isUnlocked ? onLock : onUnlock,
              ),
              IconButton(
                icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                onPressed: toggleTheme,
              ),
            ]),
          );
        },
      ),
    );
  }
}