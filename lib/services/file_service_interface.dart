import '../models/file_system_entity.dart';

abstract class FileService {
  Future<FileNodeDirectory?> pickDirectory();
  Future<String?> readFile(FileNodeFile file);
  Future<FileNodeFile?> createFile(String parentPath, String name);
  Future<FileNodeDirectory?> createDirectory(String parentPath, String name);
  Future<void> saveFile(FileNodeFile file, String content);
}
