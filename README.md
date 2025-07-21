# SacRiverSafety

A data-driven, mobile-friendly Flutter application that consolidates drowning statistics, live river conditions, safety resources, and community stories for the Sacramento & American River corridor.

## Features

- **Interactive Map Interface**: Comprehensive map showing Sacramento & American River systems with real-time gauge data
- **River Conditions**: Live USGS gauge readings with color-coded safety levels
- **Trail Safety**: American River Trail conditions and amenities
- **Safety Education**: Educational content and resources
- **Drowning Statistics**: Real-time statistics and incident data
- **Safety Alerts**: Current safety alerts and warnings

## Getting Started

### Prerequisites

- Flutter SDK (>=3.8.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/SacRiverSafety.git
cd SacRiverSafety
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### API Configuration (Optional)

The app works without API keys, but you can enhance functionality by setting up API keys:

#### OpenWeather API (Optional)
To use OpenWeather API for enhanced weather data:

1. Get a free API key from [OpenWeather](https://openweathermap.org/api)
2. Set the environment variable:
```bash
# Windows
set OPENWEATHER_API_KEY=your_api_key_here

# macOS/Linux
export OPENWEATHER_API_KEY=your_api_key_here

# Or run Flutter with the key
flutter run --dart-define=OPENWEATHER_API_KEY=your_api_key_here
```

#### AirNow API (Optional)
For air quality data:

1. Get a free API key from [AirNow](https://docs.airnowapi.org/)
2. Set the environment variable:
```bash
# Windows
set AIRNOW_API_KEY=your_api_key_here

# macOS/Linux
export AIRNOW_API_KEY=your_api_key_here

# Or run Flutter with the key
flutter run --dart-define=AIRNOW_API_KEY=your_api_key_here
```

## Architecture

The app follows a clean architecture pattern with:

- **Domain Layer**: Entities, repositories interfaces, and use cases
- **Data Layer**: Repository implementations, services, and data sources
- **Presentation Layer**: UI components, pages, and state management (BLoC/Cubit)
- **Core**: Constants, error handling, dependency injection, and routing

## Key Technologies

- **Flutter**: Cross-platform UI framework
- **BLoC/Cubit**: State management
- **GoRouter**: Navigation and routing
- **Dio**: HTTP client for API calls
- **Flutter Map**: Interactive map implementation
- **GetIt**: Dependency injection

## Data Sources

- **USGS Water Data**: River gauge readings and water levels
- **National Weather Service**: Weather conditions and forecasts
- **Sacramento County Parks**: Trail conditions and amenities
- **Local Emergency Services**: Safety alerts and incident data

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support or questions, please open an issue on GitHub or contact the development team.