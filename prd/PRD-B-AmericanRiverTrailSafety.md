# PRD-B · American River Trail Safety
**Parent project:** SacRiverSafety.com  
**Delivery:** Flutter web app (sub‑path `/trail`) or standalone Flutter application

## 1. Purpose
Educate cyclists, walkers, and equestrians on safe use of the American River Parkway trail. Provide live conditions, etiquette rules, incident hotspots, and gear checklist.

## 2. Goals
- Reduce bike‑ped collisions and heat‑related rescues
- Centralise official rules + courtesy guidelines in one mobile‑friendly page
- Surface AQI/heat warnings to deter unsafe outings

## 3. Key Features
1. **Trail Rules at‑a‑Glance** (15 mph limit, keep right, leash ≤ 6 ft, helmet law)
2. **Etiquette section** with visual hierarchy yield diagram
3. **Interactive Trail Map**
   - Mile markers
   - Water & restroom icons
   - Ranger stations & call‑boxes
   - Incident pins (crashes, assaults) from `/data/trail_incidents.yaml`
4. **Live Conditions Widget**
   - AirNow API AQI
   - NWS temp & heat‑index
   - Sunrise / sunset
   - Alerts: AQI > 100, temp > 95 °F
5. **Essentials Checklist** (printable + in‑app)
6. **Report Issues CTA** linking to 311 app & non‑emergency Park Rangers

## 4. Data Model
```yaml
# trail_incidents.yaml
- id: 2024-07-14-001
  date: 2024-07-14
  lat: 38.5901
  lon: -121.3442
  type: "bike-ped collision"
  severity: "injury"
  source: "https://www.kcra.com/article/bicyclist-injured..."
```

## 5. User Personas & Use Cases
| Persona | Primary Use Case | Key Information Needs |
|---------|------------------|----------------------|
| **Weekend Cyclist** | Plan safe route with current conditions | Weather, AQI, incident hotspots, rest stops |
| **Daily Commuter** | Quick safety check before ride | Trail status, weather alerts, emergency contacts |
| **Family Walker** | Safe outing with children/pets | Etiquette rules, leash laws, water fountains |
| **Trail Runner** | Early morning/late evening safety | Sunrise/sunset times, lighting, emergency call boxes |

## 6. Technical Implementation
### Flutter Build System
- **Flutter 3.x** for cross-platform development (Web, iOS, Android)
- **Material Design 3** components for consistent UI/UX
- **State Management**: Riverpod or Bloc for reactive data handling
- **HTTP Client**: Dio for API integrations
- **Local Storage**: SharedPreferences for offline data caching

### Integration Options
1. **Flutter Web Module** (`/trail` on main sacriversafety.com)
   - Shared Flutter widgets and design system
   - Unified analytics and deployment pipeline
   - Cross-linking between river and trail safety features

2. **Standalone Flutter App** (separate DigitalOcean app)
   - Independent Flutter project and deployment
   - Specialized trail-focused features and navigation
   - Potential for mobile app store distribution

### Data Sources & APIs
- **AirNow API**: Real-time air quality data via REST
- **National Weather Service**: Temperature, heat index, alerts
- **Sacramento County Parks**: Official trail rules and amenities
- **Community Reports**: Incident data via 311 integration
- **Geolocation Services**: GPS for user location and trail mapping

## 6.1 Flutter Build & Deployment Configuration
### Web Deployment (DigitalOcean)
```yaml
# .do/app.yaml for Flutter Web
name: riversafe-trail
services:
  - static_sites:
      name: web
      github:
        repo: <owner>/riversafe-trail
        branch: main
      build_command: |
        flutter pub get
        flutter build web --release
      output_dir: build/web
envs:
  - key: FLUTTER_VERSION
    value: "3.19.0"
```

### Mobile App Distribution
- **iOS**: App Store deployment via TestFlight
- **Android**: Google Play Store with internal testing
- **Web**: PWA with service worker for offline functionality

### CI/CD Pipeline
- **GitHub Actions**: Automated testing and deployment
- **Flutter Test**: Unit and widget testing
- **Firebase Test Lab**: Cross-platform testing
- **Code Coverage**: Minimum 80% coverage requirement

## 7. Flutter Mobile-First Design Requirements
- **Responsive Layout**: Flutter's adaptive widgets for smartphone use on trail
- **Offline Capability**: SharedPreferences and local SQLite for poor signal areas
- **Quick Access**: Material Design touch targets for emergency contacts
- **Readable in Sunlight**: High contrast themes and large text options
- **Platform-Specific Features**: Native iOS/Android integrations when beneficial
- **Progressive Web App (PWA)**: Offline functionality and app-like experience

## 8. Safety Alerts System
### Automated Triggers
- **AQI > 100**: "Consider indoor exercise today"
- **Temperature > 95°F**: "High heat warning - stay hydrated"
- **Heat Index > 105°F**: "Dangerous conditions - avoid outdoor activity"
- **Sunset within 1 hour**: "Bring lights if continuing"

### Manual Alerts
- Trail closures and maintenance
- Recent incidents in area
- Special events affecting trail use

## 9. Community Features
### Incident Reporting
- **Anonymous reporting** of near-misses and hazards
- **Photo uploads** for trail damage or safety issues
- **Integration with 311** for official reporting
- **Real-time alerts** to other users in affected area

### User-Generated Content
- **Trail condition updates** from regular users
- **Safety tips** and best practices sharing
- **Amenity reviews** (water fountains, restrooms, etc.)

## 10. Success Metrics
### Primary Safety Goals
- **Reduction in bike-pedestrian collisions** on American River Parkway
- **Decrease in heat-related rescues** during summer months
- **Increased compliance** with trail rules and etiquette

### Engagement Metrics
- **Daily active users** checking conditions
- **Alert response rates** (users who modify plans based on warnings)
- **Community reporting** volume and quality

## 11. Flutter Development Phases
### Phase 1: Core Flutter App Structure
- Flutter project setup with Material Design 3
- Trail rules and etiquette documentation widgets
- Basic conditions widget (weather only)
- Static trail map with Flutter map integration

### Phase 2: Interactive Flutter Features
- Live conditions integration (AQI, heat index) with Riverpod state management
- Incident mapping and reporting with geolocation
- Mobile-optimized Flutter interface with platform-specific features

### Phase 3: Community Integration & Advanced Features
- User reporting system with camera integration
- Real-time alerts and push notifications
- Advanced analytics and insights dashboard
- PWA capabilities for web deployment

## 12. Partnerships & Stakeholders
- **Sacramento County Regional Parks**: Official rules and data
- **Sacramento Area Bicycle Advocates**: Safety education content
- **Sacramento Metro Fire**: Emergency response coordination
- **Local cycling clubs**: User testing and feedback

## 13. Flutter Accessibility & Inclusion
- **Screen reader compatibility** via Flutter's Semantics widgets
- **Voice navigation** for hands-free trail use with speech-to-text
- **Multilingual support** via Flutter's internationalization (i18n)
- **Large text options** with Flutter's text scaling
- **Color-blind friendly** design with Material Design 3 color system
- **Platform accessibility** integration (iOS VoiceOver, Android TalkBack)
- **Haptic feedback** for important safety alerts 