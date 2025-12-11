import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'models/file_system_entity.dart';

class FileTree extends StatefulWidget {
  final FileNodeDirectory? rootNode;
  final Function(FileNodeFile) onFileSelected;
  final VoidCallback? onPickDirectory;

  const FileTree({
    super.key,
    required this.rootNode,
    required this.onFileSelected,
    this.onPickDirectory,
  });

  @override
  State<FileTree> createState() => _FileTreeState();
}

class _FileTreeState extends State<FileTree> {
  String? _selectedPath;

  @override
  Widget build(BuildContext context) {
    if (widget.rootNode == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No folder opened'),
            if (widget.onPickDirectory != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.onPickDirectory,
                child: const Text('Open Folder'),
              ),
            ],
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: _buildDirectoryItem(widget.rootNode!, isRoot: true),
    );
  }

  Widget _buildDirectoryItem(
    FileNodeDirectory directory, {
    bool isRoot = false,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: PageStorageKey(directory.path),
        initiallyExpanded: isRoot,
        tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        dense: true,
        leading: const Icon(Icons.arrow_right, size: 16, color: Colors.grey),
        trailing: const SizedBox.shrink(),
        title: Row(
          children: [
            Icon(
              Icons.folder,
              size: 16,
              color: isRoot ? Colors.blue : const Color(0xFF90A4AE),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                directory.name,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.2,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.only(left: 10.0),
        children: _buildChildren(directory),
      ),
    );
  }

  List<Widget> _buildChildren(FileNodeDirectory directory) {
    List<Widget> children = [];
    for (var entity in directory.children) {
      if (entity is FileNodeDirectory) {
        children.add(_buildDirectoryItem(entity));
      } else if (entity is FileNodeFile) {
        children.add(_buildFileItem(entity));
      }
    }
    return children;
  }

  Widget _buildFileItem(FileNodeFile file) {
    final bool isSelected = file.path == _selectedPath;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPath = file.path;
        });
        widget.onFileSelected(file);
      },
      child: Container(
        color: isSelected ? const Color(0x1AFFFFFF) : null,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          children: [
            const SizedBox(width: 24), // Indent to match folder arrow
            _getFileIcon(file.name),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                file.name,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFileIcon(String fileName) {
    final ext = p.extension(fileName).toLowerCase();
    IconData icon = Icons.insert_drive_file_outlined;
    Color color = Colors.grey;

    switch (ext) {
      case '.dart':
        icon = Icons.code;
        color = const Color(0xFF42A5F5); // Flutter Blue
        break;
      case '.html':
        icon = Icons.html;
        color = const Color(0xFFE65100); // Orange
        break;
      case '.css':
        icon = Icons.css;
        color = const Color(0xFF1E88E5); // Blue
        break;
      case '.js':
      case '.ts':
        icon = Icons.javascript;
        color = const Color(0xFFFFCA28); // Amber
        break;
      case '.json':
        icon = Icons.data_object;
        color = const Color(0xFF66BB6A); // Green
        break;
      case '.md':
        icon = Icons.description;
        color = const Color(0xFFAB47BC); // Purple
        break;
      case '.yaml':
      case '.yml':
        icon = Icons.settings;
        color = const Color(0xFFEF5350); // Red
        break;
      case '.xml':
        icon = Icons.code;
        color = const Color(0xFFFF7043); // Deep Orange
        break;
      case '.png':
      case '.jpg':
      case '.jpeg':
      case '.svg':
        icon = Icons.image;
        color = const Color(0xFF26A69A); // Teal
        break;
    }

    return Icon(icon, size: 16, color: color);
  }
}
