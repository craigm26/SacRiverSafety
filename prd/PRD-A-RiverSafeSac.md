# PRD-A · SacRiverSafety Mobile App

## 1. Purpose
Create a data‑driven, mobile‑friendly Flutter application that consolidates drowning statistics, live river conditions, safety resources, and community stories for the Sacramento & American River corridor. The app provides real-time safety information through an intuitive map interface with interactive overlays and critical measurements.

## 2. Goals
- ↓ ​drowning incidents by making life‑saving info easily accessible on mobile devices
- Present authoritative, up‑to‑date numbers (Coroner stats + USGS gauges) in real-time
- Offer interactive map interface with safety overlays and measurements
- Provide comprehensive navigation with categorized safety information
- Deploy as a cross-platform mobile app (iOS/Android) with web support

## 3. Non‑Goals
- No user accounts / log‑in (public safety information)
- No comment threads or forums (link to external resources for discussion)
- No paid ads or tracking beyond privacy‑respecting analytics
- No complex user-generated content management

## 4. Users & JTBDs
| Persona | "Job‑to‑Be‑Done" |
|---------|------------------|
| Local parent planning a river day | Check real-time water conditions and find nearby safety resources |
| Tubing student | Understand current hazards and access emergency information |
| Journalist / policymaker | Access comprehensive safety data and incident statistics |
| Emergency responders | Quick access to current river conditions and safety alerts |
| Outdoor enthusiasts | Plan activities with real-time safety information |

## 5. Core Features

### 5.1 Interactive Map Interface
- **River System Map**: Comprehensive map showing Sacramento & American River systems
- **Real-time Gauge Data**: Live USGS gauge readings with color-coded safety levels
- **Trail Information**: American River Trail conditions and amenities
- **Safety Alerts**: Real-time alerts and warnings with location-based filtering
- **Interactive Markers**: Tap for detailed information on gauges, amenities, and alerts

### 5.2 Collapsible Overlay System
- **Map Layer Controls**: Toggle visibility of river gauges, trail amenities, and safety alerts
- **Safety Measurements Overlay**: Collapsible panel showing critical safety information
  - River gauge readings (water level, flow rate, safety status)
  - Trail conditions (temperature, air quality, weather, sunset times)
  - Real-time alerts and warnings
- **Responsive Design**: Adapts to different screen sizes and orientations

### 5.3 Navigation & Information Architecture
- **App Shell**: Robust hamburger menu with categorized navigation
- **River Conditions**: Detailed river safety information and historical data
- **Trail Safety**: Trail conditions, amenities, and safety guidelines
- **Emergency Resources**: Emergency contacts, life jacket locations, safety tips
- **About & Data**: Methodology, data sources, and contribution information

### 5.4 Real-time Data Integration
- **USGS Gauge Integration**: Live data from multiple river gauges
  - USGS 11446500 (American @ Fair Oaks)
  - USGS 11447650 (Sacramento @ Downtown)
  - Additional gauges as needed
- **Weather Integration**: Real-time weather conditions and forecasts
- **Safety Alerts**: Automated alerts based on dangerous conditions

## 6. Technical Architecture

### 6.1 State Management
- **BLoC Pattern**: Cubit-based state management for predictable data flow
- **Repository Pattern**: Clean separation between data sources and business logic
- **Dependency Injection**: GetIt for service locator pattern

### 6.2 Data Layer
| Component | Update Cadence | Source |
|-----------|----------------|--------|
| River Gauge Data | Real-time (5-15 min) | USGS Water Services API |
| Weather Data | Real-time (hourly) | Weather API integration |
| Safety Alerts | Real-time | Automated monitoring + manual entry |
| Trail Conditions | Real-time | Weather + manual updates |
| Historical Data | Quarterly | Sacramento County Coroner |

### 6.3 Navigation
- **GoRouter**: Declarative routing with deep linking support
- **App Shell**: Consistent navigation structure across all screens
- **Route Guards**: Conditional navigation based on data availability

## 7. Tech Stack
- **Flutter 3.32+**: Cross-platform mobile development
- **Dart 3.8+**: Modern programming language with null safety
- **flutter_map**: Interactive mapping with OpenStreetMap tiles
- **flutter_bloc**: State management with Cubit pattern
- **go_router**: Declarative routing and navigation
- **get_it**: Dependency injection and service locator
- **dio**: HTTP client for API integration
- **hive**: Local data storage and caching
- **fl_chart**: Data visualization and charts
- **geolocator**: Location services and GPS integration

## 8. App Structure

### 8.1 Core Architecture
```
lib/
├── app.dart                 # Main app configuration
├── main.dart               # App entry point
├── core/                   # Core functionality
│   ├── constants/          # App constants
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── router/             # Navigation configuration
│   ├── theme/              # App theming
│   └── utils/              # Utility functions
├── data/                   # Data layer
│   ├── models/             # Data models
│   ├── repositories/       # Repository implementations
│   ├── services/           # API services
│   └── sources/            # Data sources
├── domain/                 # Business logic
│   ├── entities/           # Domain entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
├── features/               # Feature modules
│   └── home/               # Home feature
└── presentation/           # UI layer
    ├── cubits/             # State management
    ├── pages/              # Screen implementations
    ├── themes/             # UI theming
    └── widgets/            # Reusable widgets
```

### 8.2 Key Widgets
- **RiverMapWidget**: Interactive map with overlays
- **MapOverlayControls**: Layer visibility controls
- **SafetyMeasurementsWidget**: Collapsible safety information
- **AppShell**: Navigation shell with hamburger menu

## 9. Deployment & Distribution

### 9.1 Mobile Platforms
- **iOS**: App Store distribution with TestFlight for beta testing
- **Android**: Google Play Store with internal testing tracks
- **Web**: Progressive Web App (PWA) for browser access

### 9.2 CI/CD Pipeline
- **GitHub Actions**: Automated testing and deployment
- **Code Quality**: Flutter lints and static analysis
- **Testing**: Unit tests, widget tests, and integration tests
- **Build Automation**: Automated builds for all platforms

## 10. Open Source Contributions
This project welcomes open source contributions and will be hosted on GitHub. Key areas for community involvement:

### Development
- Map visualization improvements
- Mobile UI/UX enhancements
- Accessibility improvements
- Performance optimizations
- Cross-platform compatibility

### Content & Data
- Incident reporting and verification
- Safety resource updates
- Community story submissions
- Translation/localization
- Data accuracy improvements

### Infrastructure
- CI/CD pipeline improvements
- Monitoring and analytics
- Security enhancements
- Documentation updates
- API integrations

### Contribution Guidelines
- Fork the repository
- Create feature branches (`feature/description`)
- Submit pull requests with clear descriptions
- Follow Flutter/Dart conventions and style guide
- Include tests for new features
- Update documentation as needed
- Ensure accessibility compliance

## 11. Success Metrics
- **Primary**: Reduction in drowning incidents in Sacramento County
- **Secondary**: App downloads, active users, and engagement metrics
- **Tertiary**: Community adoption of safety resources and features
- **Technical**: App performance, crash-free rate, and data accuracy
- **User Experience**: App store ratings, user feedback, and feature adoption

## 12. Future Enhancements
- **Offline Support**: Cached data for offline access
- **Push Notifications**: Safety alerts and condition updates
- **Social Features**: Community reporting and sharing
- **Advanced Analytics**: Detailed usage analytics and insights
- **Multi-language Support**: Spanish and other local languages
- **Accessibility**: Enhanced accessibility features for all users
