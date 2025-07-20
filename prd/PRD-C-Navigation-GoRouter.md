# PRD-C · Navigation with Go Router
**Parent project:** sacriversafety.com  
**Feature:** Declarative routing system with deep linking support

## 1. Purpose
Implement a robust, declarative navigation system using go_router that supports deep linking, web URLs, and seamless navigation between river safety features.

## 2. Goals
- Enable direct URL access to specific features (e.g., `/river/conditions`, `/trail/safety`)
- Support deep linking for sharing specific river/trail conditions
- Provide consistent navigation experience across web, iOS, and Android
- Enable browser back/forward button functionality on web
- Support route guards for feature access control

## 3. Non-Goals
- Complex nested navigation with bottom tabs (not needed for this app)
- Custom transition animations (use Material Design defaults)
- Route-based analytics (implemented separately)

## 4. User Stories & Use Cases
| User Story | Acceptance Criteria |
|------------|-------------------|
| **Direct Access**: User wants to bookmark specific river conditions | Can access `/river/conditions/11446500` directly |
| **Sharing**: User wants to share current trail conditions | URL can be copied and shared, opens same state |
| **Deep Link**: User clicks link from social media | App opens directly to relevant safety information |
| **Browser Navigation**: User uses back/forward buttons | Navigation works as expected on web |

## 5. Route Structure
```dart
// Main routes
/                           → HomePage
/river                      → RiverConditionsPage
/river/conditions/:gaugeId  → RiverDetailPage
/trail                      → TrailSafetyPage
/trail/amenities            → TrailAmenitiesPage
/alerts                     → SafetyAlertsPage
/about                      → AboutPage
/settings                   → SettingsPage

// Deep link routes
/river/alert/:alertId       → RiverAlertDetailPage
/trail/incident/:incidentId → TrailIncidentPage
```

## 6. Technical Implementation

### 6.1 Router Configuration
```dart
// lib/core/router/app_router.dart
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/river',
      builder: (context, state) => const RiverConditionsPage(),
      routes: [
        GoRoute(
          path: 'conditions/:gaugeId',
          builder: (context, state) => RiverDetailPage(
            gaugeId: state.pathParameters['gaugeId']!,
          ),
        ),
        GoRoute(
          path: 'alert/:alertId',
          builder: (context, state) => RiverAlertDetailPage(
            alertId: state.pathParameters['alertId']!,
          ),
        ),
      ],
    ),
    // ... other routes
  ],
);
```

### 6.2 Navigation Methods
```dart
// Programmatic navigation
context.go('/river/conditions/11446500');
context.goNamed('river-detail', pathParameters: {'gaugeId': '11446500'});

// With query parameters
context.go('/river?gauge=11446500&time=24h');

// With extra data
context.go('/river', extra: {'forceRefresh': true});
```

### 6.3 Route Guards
```dart
// Authentication/feature flags
GoRoute(
  path: '/settings',
  redirect: (context, state) {
    // Check if user has access to settings
    if (!hasSettingsAccess) return '/';
    return null;
  },
  builder: (context, state) => const SettingsPage(),
),
```

## 7. Deep Linking Strategy

### 7.1 Web Deep Links
- **SEO-friendly URLs**: `/river/conditions/american-river-fair-oaks`
- **Query parameters**: `/river?gauge=11446500&time=24h&units=metric`
- **Hash routing**: Support for `#` based routing on older browsers

### 7.2 Mobile Deep Links
- **iOS**: Universal Links for `sacriversafety.com`
- **Android**: App Links for `sacriversafety.com`
- **Custom schemes**: `riversafe://river/conditions/11446500`

### 7.3 Social Media Integration
- **Twitter Cards**: Meta tags for rich previews
- **Facebook Open Graph**: Structured data for sharing
- **WhatsApp/Telegram**: Direct deep link support

## 8. URL Structure Examples

### 8.1 River Conditions
```
/river                                    # River overview
/river/conditions/11446500               # American River at Fair Oaks
/river/conditions/11447650               # Sacramento River at Downtown
/river/conditions/11446500?time=7d       # 7-day history
/river/conditions/11446500?units=metric  # Metric units
```

### 8.2 Trail Safety
```
/trail                                   # Trail overview
/trail/safety                           # Safety information
/trail/amenities                        # Water fountains, restrooms
/trail/amenities?type=water             # Filter by type
/trail/incident/2024-07-15-001          # Specific incident
```

### 8.3 Safety Alerts
```
/alerts                                  # All alerts
/alerts/river                           # River alerts only
/alerts/trail                           # Trail alerts only
/alerts/alert/high-water-2024-07-15     # Specific alert
```

## 9. Implementation Phases

### Phase 1: Basic Routing (Week 1)
- [ ] Set up go_router configuration
- [ ] Implement main routes (/, /river, /trail)
- [ ] Add navigation in existing pages
- [ ] Test basic navigation flow

### Phase 2: Deep Linking (Week 2)
- [ ] Implement parameterized routes
- [ ] Add query parameter support
- [ ] Test deep linking on web
- [ ] Add route guards

### Phase 3: Mobile Deep Links (Week 3)
- [ ] Configure iOS Universal Links
- [ ] Configure Android App Links
- [ ] Test mobile deep linking
- [ ] Add custom URL schemes

### Phase 4: SEO & Social (Week 4)
- [ ] Add meta tags for social sharing
- [ ] Implement structured data
- [ ] Test social media integration
- [ ] Performance optimization

## 10. Testing Strategy

### 10.1 Unit Tests
```dart
test('river detail route with gauge ID', () {
  final router = GoRouter(routes: appRoutes);
  final location = '/river/conditions/11446500';
  
  expect(router.routerDelegate.currentConfiguration.uri.path, location);
});
```

### 10.2 Integration Tests
- Test deep link handling
- Test browser back/forward navigation
- Test route guards and redirects
- Test parameter parsing

### 10.3 Manual Testing
- [ ] Direct URL access on web
- [ ] Deep link sharing via social media
- [ ] Mobile deep link handling
- [ ] Browser navigation controls

## 11. Success Metrics
- **Direct URL Access**: 95% of routes accessible via direct URL
- **Deep Link Success Rate**: 90% of shared links open correctly
- **Navigation Performance**: <100ms route transitions
- **SEO Impact**: Improved search engine indexing

## 12. Dependencies
- **go_router**: ^13.2.0 (already in pubspec.yaml)
- **url_launcher**: For external link handling
- **shared_preferences**: For route state persistence

## 13. Risks & Mitigation
| Risk | Impact | Mitigation |
|------|--------|------------|
| **Browser Compatibility** | Medium | Test on multiple browsers, provide fallbacks |
| **Mobile Deep Link Setup** | High | Follow platform-specific guidelines carefully |
| **SEO Conflicts** | Low | Use proper meta tags and structured data |
| **Performance Impact** | Low | Lazy load routes, optimize bundle size |

## 14. Future Enhancements
- **Analytics Integration**: Track route changes and user journeys
- **A/B Testing**: Route-based feature flags
- **Progressive Web App**: Offline route caching
- **Internationalization**: Route-based language switching 