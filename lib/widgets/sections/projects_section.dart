// lib/widgets/sections/projects_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:js_portfolio/models/models.dart';
import 'package:js_portfolio/screens/portfolio_page.dart';
import 'package:js_portfolio/utils/extensions.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/section_headline.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_theme.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = DataProvider.of(context)!.data.projects;

    return Container(
      width: double.infinity,
      color: Theme.of(context).extension<CustomThemeExtension>()!.accentSectionBackground,

      padding: EdgeInsets.symmetric(vertical: context.isPhone ? 70 : 96, horizontal: 24),
      child: Column(children: [
        const SectionHeadline('Projekte'),
        const SizedBox(height: 40),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 28,
          runSpacing: 28,
          children: projects.map((project) {
            return SizedBox(
              width: 500,
              child: ProjectCard(project: project),
            );
          }).toList(),
        )
      ]),
    ).animate().fadeIn(duration: 600.ms);
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectItem project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                project.imagePaths.first,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.category, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 4),
                    Text(project.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(project.shortDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: project.technologies.map((tech) => Chip(
                        label: Text(tech),
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        side: BorderSide.none,
                      )).toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => ProjectDetailDialog(project: project),
                ),
              ),
            ),
          ),
        ],
      ),
    ).addHoverEffect();
  }
}

class ProjectDetailDialog extends StatefulWidget {
  final ProjectItem project;
  const ProjectDetailDialog({super.key, required this.project});

  @override
  State<ProjectDetailDialog> createState() => _ProjectDetailDialogState();
}

class _ProjectDetailDialogState extends State<ProjectDetailDialog> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      if(_pageController.page?.round() != _currentPage) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 8, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(widget.project.title,
                          style: Theme.of(context).textTheme.headlineSmall)),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 300,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.project.imagePaths.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  widget.project.imagePaths[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.project.imagePaths.length > 1)
                          Positioned(
                            left: 32,
                            // GEÄNDERT: Button mit Hintergrund für bessere Sichtbarkeit
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: _currentPage > 0
                                    ? () => _pageController.previousPage(duration: 300.ms, curve: Curves.ease)
                                    : null,
                                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        if (widget.project.imagePaths.length > 1)
                          Positioned(
                            right: 32,
                            // GEÄNDERT: Button mit Hintergrund für bessere Sichtbarkeit
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: _currentPage < widget.project.imagePaths.length - 1
                                    ? () => _pageController.nextPage(duration: 300.ms, curve: Curves.ease)
                                    : null,
                                icon: const Icon(Icons.arrow_forward_ios_rounded),
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (widget.project.imagePaths.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.project.imagePaths.length,
                              (index) => AnimatedContainer(
                            duration: 200.ms,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(widget.project.longDescription,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.project.githubRepoUrl != null)
                    TextButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.github, size: 16),
                      label: const Text('GitHub'),
                      onPressed: () =>
                          launchUrl(Uri.parse(widget.project.githubRepoUrl!)),
                    ),
                  const SizedBox(width: 12),
                  if (widget.project.liveDemoUrl != null)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: const Text('Live-Demo'),
                      onPressed: () =>
                          launchUrl(Uri.parse(widget.project.liveDemoUrl!)),
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