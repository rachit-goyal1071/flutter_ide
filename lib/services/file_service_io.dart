import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import '../models/file_system_entity.dart';
import 'file_service_interface.dart';

class FileServiceImpl implements FileService {
  @override
  Future<FileNodeDirectory?> pickDirectory() async {
    final String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath();
    if (selectedDirectory == null) return null;

    final dir = Directory(selectedDirectory);
    return _buildDirectoryNode(dir);
  }

  FileNodeDirectory _buildDirectoryNode(Directory dir) {
    List<FileNode> children = [];
    try {
      final entities = dir.listSync();

      // Sort: Directories first, then files
      entities.sort((a, b) {
        if (a is Directory && b is File) return -1;
        if (a is File && b is Directory) return 1;
        return p
            .basename(a.path)
            .toLowerCase()
            .compareTo(p.basename(b.path).toLowerCase());
      });

      for (var entity in entities) {
        final name = p.basename(entity.path);
        if (name.startsWith('.')) continue; // Skip hidden

        if (entity is Directory) {
          children.add(_buildDirectoryNode(entity));
        } else if (entity is File) {
          children.add(FileNodeFile(name, entity.path));
        }
      }
    } catch (e) {
      debugPrint('Error listing directory: $e');
    }

    return FileNodeDirectory(
      p.basename(dir.path),
      dir.path,
      children: children,
    );
  }

  @override
  Future<String?> readFile(FileNodeFile file) async {
    return File(file.path).readAsString();
  }
}
