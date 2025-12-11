import '../models/file_system_entity.dart';

abstract class FileService {
  Future<FileNodeDirectory?> pickDirectory();
  Future<String?> readFile(FileNodeFile file);
}
