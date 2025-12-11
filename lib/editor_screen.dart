import 'package:flutter/material.dart';
import 'package:flutter_monaco/flutter_monaco.dart';
import 'package:path/path.dart' as p;
import 'models/file_system_entity.dart';
import 'services/file_service.dart';
import 'file_tree.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  FileNodeDirectory? _rootNode;
  MonacoController? _editorController;
  final List<FileNodeFile> _openFiles = [];
  FileNodeFile? _activeFile;
  String _currentCode = '// Open a file to start editing\n';

  Future<void> _pickDirectory() async {
    final root = await fileService.pickDirectory();
    if (root != null) {
      setState(() {
        _rootNode = root;
        // Optionally close existing files or keep them?
        // _openFiles.clear();
        // _activeFile = null;
      });
    }
  }

  Future<void> _openFile(FileNodeFile file) async {
    if (!_openFiles.any((f) => f.path == file.path)) {
      setState(() {
        _openFiles.add(file);
      });
    }

    // Set active even if already open
    setState(() {
      _activeFile = file;
    });

    try {
      final content = await fileService.readFile(file) ?? '';
      setState(() {
        _currentCode = content;
      });

      _editorController?.setValue(_currentCode);
      try {
        final language = _getLanguage(file.path);
        _editorController?.setLanguage(language);
      } catch (e) {
        debugPrint('Error setting language: $e');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error reading file: $e')));
      }
    }
  }

  void _closeFile(FileNodeFile file) {
    setState(() {
      _openFiles.removeWhere((f) => f.path == file.path);
      if (_activeFile?.path == file.path) {
        if (_openFiles.isNotEmpty) {
          _activeFile = _openFiles.last;
          _openFile(_activeFile!); // Load the new active file
        } else {
          _activeFile = null;
          _currentCode = '// Open a file to start editing\n';
          _editorController?.setValue(_currentCode);
        }
      }
    });
  }

  MonacoLanguage _getLanguage(String path) {
    final ext = p.extension(path).toLowerCase();
    switch (ext) {
      case '.dart':
        return MonacoLanguage.dart;
      case '.js':
        return MonacoLanguage.javascript;
      case '.ts':
        return MonacoLanguage.typescript;
      case '.html':
        return MonacoLanguage.html;
      case '.css':
        return MonacoLanguage.css;
      case '.json':
        return MonacoLanguage.json;
      case '.yaml':
      case '.yml':
        return MonacoLanguage.yaml;
      case '.md':
        return MonacoLanguage.markdown;
      case '.sql':
        return MonacoLanguage.sql;
      case '.xml':
        return MonacoLanguage.xml;
      default:
        return MonacoLanguage.dart;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: const Color(0xFF181818), // VS Code Sidebar Darker
            child: Column(
              children: [
                // Explorer Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'EXPLORER',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Colors.white70,
                          size: 16,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                // Project Header
                if (_rootNode != null)
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      _rootNode!.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    shape: const Border(), // Remove borders
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    trailing:
                        const SizedBox.shrink(), // Hide arrow if handled by tree or just make it look like header
                    onExpansionChanged: (val) {},
                    children:
                        const [], // Just for header look, actual tree is below
                  ),

                Expanded(
                  child: FileTree(
                    rootNode: _rootNode,
                    onFileSelected: _openFile,
                    onPickDirectory: _pickDirectory,
                  ),
                ),
              ],
            ),
          ),

          // Main Editor Area
          Expanded(
            child: Column(
              children: [
                // Tab Bar
                Container(
                  height: 35,
                  color: const Color(0xFF252526), // Editor Header Background
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _openFiles.length,
                          itemBuilder: (context, index) {
                            final file = _openFiles[index];
                            final isActive = file.path == _activeFile?.path;
                            return _buildTab(file, isActive);
                          },
                        ),
                      ),
                      // Actions (Split, More)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.green,
                              size: 18,
                            ),
                            onPressed: () {},
                            tooltip: 'Run',
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.splitscreen,
                              color: Colors.white70,
                              size: 16,
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),

                // Breadcrumbs
                if (_activeFile != null)
                  Container(
                    height: 22,
                    color: const Color(0xFF1E1E1E),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          _rootNode?.name ?? '',
                          style: const TextStyle(
                            color: Colors.white30,
                            fontSize: 12,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: Colors.white30,
                        ),
                        Text(
                          p.basename(_activeFile!.path),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: MonacoEditor(
                    initialValue: _currentCode,
                    options: const EditorOptions(
                      language: MonacoLanguage.dart,
                      theme: MonacoTheme.vsDark,
                      automaticLayout: true,
                    ),
                    onReady: (controller) {
                      _editorController = controller;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(FileNodeFile file, bool isActive) {
    return InkWell(
      onTap: () => _openFile(file),
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 4),
        constraints: const BoxConstraints(minWidth: 120, maxWidth: 200),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E1E1E) : const Color(0xFF2D2D2D),
          border: isActive
              ? const Border(
                  top: BorderSide(color: Color(0xFF007ACC), width: 2),
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getFileIcon(file.name),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                file.name,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white54,
                  fontSize: 13,
                  fontStyle: isActive ? FontStyle.normal : FontStyle.italic,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () => _closeFile(file),
              hoverColor: Colors.white10,
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(Icons.close, size: 14, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon _getFileIcon(String fileName) {
    final ext = p.extension(fileName).toLowerCase();
    IconData icon = Icons.insert_drive_file_outlined;
    Color color = Colors.grey;

    switch (ext) {
      case '.dart':
        icon = Icons.code;
        color = const Color(0xFF42A5F5);
        break;
      case '.html':
        icon = Icons.html;
        color = const Color(0xFFE65100);
        break;
      case '.css':
        icon = Icons.css;
        color = const Color(0xFF1E88E5);
        break;
      case '.js':
      case '.ts':
        icon = Icons.javascript;
        color = const Color(0xFFFFCA28);
        break;
      case '.json':
        icon = Icons.data_object;
        color = const Color(0xFF66BB6A);
        break;
      default:
      // keep defaults
    }
    return Icon(icon, size: 14, color: color);
  }
}
