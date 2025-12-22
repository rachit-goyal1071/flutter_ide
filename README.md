# Flutter IDE

A lightweight, cross-platform code editor built with Flutter. Features a VS Code-inspired interface with Monaco Editor integration, file tree navigation, multi-tab editing, and auto-save functionality.

## Features

- **Monaco Editor** - Powered by `flutter_monaco` for a rich code editing experience with syntax highlighting
- **File Explorer** - VS Code-style sidebar with collapsible folder tree navigation
- **Multi-Tab Editing** - Open and switch between multiple files with a tabbed interface
- **Auto-Save** - Automatically saves changes every 2 seconds
- **Syntax Highlighting** - Supports multiple languages:
  - Dart
  - JavaScript / TypeScript
  - HTML / CSS
  - JSON
  - YAML
  - Markdown
  - SQL
  - XML
- **Cross-Platform** - Runs on Web, macOS, Windows, Linux, iOS, and Android
- **Dark Theme** - Modern VS Code-inspired dark UI

## Screenshots

The editor features:
- Activity bar (left) for switching views
- File explorer sidebar with folder/file tree
- Editor tabs with file icons
- Breadcrumb navigation
- Status bar showing language, encoding, and indentation

## Getting Started

### Prerequisites

- Flutter SDK ^3.10.1
- Dart SDK ^3.10.1

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd flutter_ide
   ```

2. Navigate to the demo project:
   ```bash
   cd flutter_ide_demo
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   # For web
   flutter run -d chrome

   # For desktop
   flutter run -d macos  # or windows, linux

   # For mobile
   flutter run -d <device-id>
   ```

## Project Structure

```
flutter_ide_demo/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── editor_screen.dart        # Main editor UI with Monaco integration
│   ├── file_tree.dart            # File explorer tree widget
│   ├── models/
│   │   └── file_system_entity.dart   # File/Directory node models
│   └── services/
│       ├── file_service.dart         # Platform-aware service factory
│       ├── file_service_interface.dart   # Abstract file service
│       ├── file_service_io.dart      # Native platform implementation
│       └── file_service_web.dart     # Web platform implementation
├── pubspec.yaml
└── test/
```

## Architecture

### File System Abstraction

The app uses a platform-aware file service pattern:

- `FileService` (interface) - Defines operations: `pickDirectory`, `readFile`, `createFile`, `createDirectory`, `saveFile`
- `FileServiceIO` - Implementation for native platforms (macOS, Windows, Linux, iOS, Android)
- `FileServiceWeb` - Implementation for web browsers using File System Access API

### Data Models

- `FileNode` - Abstract base class for file system entities
- `FileNodeDirectory` - Represents a folder with children
- `FileNodeFile` - Represents a file with optional cached content

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_monaco` | ^1.1.1 | Monaco Editor integration |
| `file_picker` | ^10.3.7 | Native file/folder selection |
| `path` | ^1.9.1 | Path manipulation utilities |
| `path_provider` | ^2.1.5 | Platform-specific directories |
| `webview_flutter` | ^4.10.0 | WebView support |
| `json_rpc_2` | ^4.0.0 | JSON-RPC protocol (for future LSP support) |

## Usage

1. **Open a Folder** - Click "Open Folder" on the welcome screen or use the refresh icon in the explorer
2. **Navigate Files** - Click folders to expand/collapse, click files to open in editor
3. **Edit Code** - Changes are auto-saved every 2 seconds
4. **Create Files/Folders** - Use the icons in the explorer header
5. **Switch Files** - Click tabs or use the file tree

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd/Ctrl + O | Open folder |
| Cmd/Ctrl + N | New file |
| Cmd/Ctrl + Click | Go to definition (placeholder) |

## Roadmap

- [ ] LSP (Language Server Protocol) integration for Dart
- [ ] Search across files
- [ ] Git integration
- [ ] Terminal panel
- [ ] Extensions support
- [ ] Custom themes
- [ ] Split editor views

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.
