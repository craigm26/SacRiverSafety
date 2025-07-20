# SacRiverSafe

A data-driven, mobile-friendly Flutter application for Sacramento & American River safety information. This app provides real-time river conditions, safety alerts, and community resources to help prevent drowning incidents and promote safe outdoor recreation.

## Features

- **Live River Conditions**: Real-time water levels and safety data from USGS gauges
- **Trail Safety**: American River Parkway trail conditions and etiquette
- **Safety Alerts**: Automated warnings for dangerous conditions
- **Community Resources**: Life jacket loaner stations and emergency contacts
- **Cross-Platform**: Works on Web, iOS, and Android

## Getting Started

### Prerequisites

1. **Install Flutter SDK** (version 3.19.0 or higher):
   - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Add Flutter to your PATH
   - Run `flutter doctor` to verify installation

2. **Install Development Tools**:
   - **VS Code** with Flutter extension (recommended)
   - **Android Studio** with Flutter plugin
   - **Xcode** (for iOS development, macOS only)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/SacRiverSafety.git
   cd SacRiverSafety
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   # For web
   flutter run -d chrome
   
   # For Android
   flutter run -d android
   
   # For iOS (macOS only)
   flutter run -d ios
   ```

## Project Structure

```
lib/
├── main.dart                    # App entrypoint
├── app.dart                     # MaterialApp configuration
├── core/
│   ├── di/                      # Dependency injection setup
│   ├── error/                   # Error handling & exceptions
│   ├── utils/                   # Utility functions & helpers
│   └── constants/               # App constants & configuration
├── data/
│   ├── models/                  # Data models & DTOs
│   ├── repositories/            # Repository implementations
│   ├── services/                # External service integrations
│   └── sources/                 # Data sources (local/remote)
├── domain/
│   ├── entities/                # Business entities
│   ├── repositories/            # Repository interfaces
│   └── usecases/               # Business logic & use cases
├── presentation/
│   ├── cubits/                  # State management (Cubit/Bloc)
│   ├── pages/                   # Screen widgets
│   ├── widgets/                 # Reusable UI components
│   └── themes/                  # App theming & styling
└── assets/
    ├── images/                  # App images and icons
    └── data/                    # Static data files
```

## Development

### Code Style

This project follows Flutter's official style guide and uses `flutter_lints` for code quality. Run the following commands:

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test
```

### State Management

This project uses **flutter_bloc** with **Cubit-first pattern** for state management. Key concepts:

- **Cubits**: Simple state management with minimal boilerplate
- **Blocs**: Used only when event-to-state mapping is complex
- **BlocBuilder**: Widgets that rebuild based on state changes
- **BlocProvider**: Dependency injection for Cubits/Blocs
- **Equatable**: For efficient state comparisons

### Architecture

We follow a clean, layered architecture:

```
┌──────────────┐
│   UI Layer   │   Flutter Widgets / Views
└──────┬───────┘
       ▼   (calls)
┌──────────────┐
│  Cubit/Bloc  │   Pure Dart → emits State objects
└──────┬───────┘
       ▼   (depends on)
┌──────────────┐  Services / Repositories (singletons via get_it)
│   Services &  │  – RiverService, TrailService
│  Repositories │  – RiverRepository, TrailRepository
└──────┬───────┘  – Data caching and API integration
       ▼   (wraps)
┌──────────────┐  Data sources & SDKs
│  Data Layer  │  – USGS API, Weather APIs, Local Storage
└──────────────┘
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/home/home_test.dart
```

## Deployment

### Web Deployment (DigitalOcean)

1. **Build for production**:
   ```bash
   flutter build web --release
   ```

2. **Deploy to DigitalOcean App Platform**:
   - Connect your GitHub repository
   - Use the build command: `flutter build web --release`
   - Set output directory to: `build/web`

### Mobile App Distribution

1. **Android**:
   ```bash
   flutter build appbundle
   # Upload to Google Play Console
   ```

2. **iOS**:
   ```bash
   flutter build ios --release
   # Archive and upload via Xcode
   ```

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and add tests
4. Run tests: `flutter test`
5. Commit your changes: `git commit -m 'Add amazing feature'`
6. Push to the branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

## Data Sources

- **USGS Water Data**: Real-time river gauge information
- **Sacramento County Coroner**: Drowning incident statistics
- **National Weather Service**: Weather and air quality data
- **Community Reports**: User-submitted safety information

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions:
- Create an issue on GitHub
- Join our community discussions
- Contact the development team

## Acknowledgments

- Sacramento County Regional Parks
- Sacramento Area Bicycle Advocates
- Local emergency response teams
- Community volunteers and contributors