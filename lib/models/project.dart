// lib/models/project.dart
class Project {
  final String title, category, shortDescription, longDescription;
  final List<String> technologies, imagePaths;
  final String? githubRepoUrl, liveDemoUrl;
  const Project({
    required this.title, required this.category, required this.shortDescription,
    required this.longDescription, required this.technologies, required this.imagePaths,
    this.githubRepoUrl, this.liveDemoUrl,
  });
}