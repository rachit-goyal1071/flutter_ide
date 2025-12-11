abstract class FileNode {
  final String name;
  final String path;

  FileNode(this.name, this.path);
}

class FileNodeDirectory extends FileNode {
  final List<FileNode> children;
  bool isExpanded;

  FileNodeDirectory(
    super.name,
    super.path, {
    this.children = const [],
    this.isExpanded = false,
  });
}

class FileNodeFile extends FileNode {
  String? content; // Cached content (especially for Web)

  FileNodeFile(super.name, super.path, {this.content});
}
