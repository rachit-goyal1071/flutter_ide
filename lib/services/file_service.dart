import 'file_service_interface.dart';
import 'file_service_io.dart' if (dart.library.html) 'file_service_web.dart';

export 'file_service_interface.dart';

/// Global instance of the platform-specific file service
final FileService fileService = FileServiceImpl();
