// lib/models/project_item.dart

class ProjectItem {
  final String title;
  final String category;
  final String shortDescription;
  final String longDescription;
  final List<String> technologies;
  final List<String> imagePaths;
  final String? githubRepoUrl;
  final String? liveDemoUrl;

  const ProjectItem({
    required this.title,
    required this.category,
    required this.shortDescription,
    required this.longDescription,
    required this.technologies,
    required this.imagePaths,
    this.githubRepoUrl,
    this.liveDemoUrl,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      title: json['title'] as String,
      category: json['category'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String,
      technologies: List<String>.from(json['technologies']),
      imagePaths: List<String>.from(json['imagePaths']),
      githubRepoUrl: json['githubRepoUrl'] as String?,
      liveDemoUrl: json['liveDemoUrl'] as String?,
    );
  }
}