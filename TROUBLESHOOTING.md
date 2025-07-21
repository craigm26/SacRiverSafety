# Troubleshooting Guide

This guide helps resolve common issues you might encounter while running the SacRiverSafety app.

## Common Issues

### 1. Hero Widget Conflicts

**Error**: `There are multiple heroes that share the same tag within a subtree`

**Solution**: This has been fixed in the latest version. If you encounter this error:
- Make sure you're using the latest code
- Check that all FloatingActionButtons have unique `heroTag` properties
- Restart the app

### 2. API Errors

#### OpenWeather API 401 Error

**Error**: `OpenWeather API error: DioException [bad response]: 401`

**Solution**: This is expected behavior when no API key is provided. The app will:
- Skip OpenWeather API calls
- Continue to work with other data sources
- Use mock/fallback data

To use OpenWeather API (optional):
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

#### USGS API "No data available" Errors

**Error**: `USGS API error for gauge XXXXXXXX: No data available for gauge`

**Solution**: This is normal for some gauge locations. The app will:
- Log the error for debugging
- Provide mock/fallback data
- Continue to function normally

### 3. Build Issues

#### Flutter Version Issues

**Error**: `The current Dart SDK version is X.X.X, but Y.Y.Y is required`

**Solution**:
1. Update Flutter: `flutter upgrade`
2. Check Flutter version: `flutter --version`
3. Ensure you're using Flutter 3.8.0 or higher

#### Dependency Issues

**Error**: `Could not resolve dependencies`

**Solution**:
1. Clean the project: `flutter clean`
2. Get dependencies: `flutter pub get`
3. If issues persist, delete `pubspec.lock` and run `flutter pub get` again

### 4. Runtime Issues

#### Web Platform Issues

**Error**: `flutter_map wants to help keep map data available for everyone`

**Solution**: This is an informational message, not an error. The app will:
- Continue to work normally
- Use OpenStreetMap tiles as configured
- Display the map interface

#### Performance Issues

**Symptoms**: Slow loading, laggy interface

**Solutions**:
1. Check your internet connection
2. Close other browser tabs/applications
3. Try refreshing the page
4. Check browser console for errors

### 5. Navigation Issues

#### Back Button Not Working

**Issue**: Back button doesn't navigate properly

**Solution**: This has been fixed in the latest version. The app now:
- Handles back navigation correctly
- Falls back to home page when needed
- Provides proper navigation flow

## Debugging

### Enable Debug Logging

To see detailed logs, run the app with verbose logging:

```bash
flutter run -d chrome --verbose
```

### Check Browser Console

1. Open browser developer tools (F12)
2. Check the Console tab for errors
3. Look for any red error messages
4. Report specific errors if they persist

### Common Log Messages

- `💡 HomePage: initState called` - Normal initialization
- `🐛 Creating [Service]Cubit` - Normal service creation
- `OpenWeather API error: [error]` - Expected when no API key
- `USGS API error for gauge [id]: [error]` - Expected for some gauges

## Getting Help

If you continue to experience issues:

1. **Check this troubleshooting guide first**
2. **Search existing issues** on GitHub
3. **Create a new issue** with:
   - Detailed error message
   - Steps to reproduce
   - Your Flutter version (`flutter --version`)
   - Platform (Web/Android/iOS)
   - Browser (if using web)

## Environment Setup

### Required Software

- Flutter SDK (>=3.8.0)
- Dart SDK (>=3.0.0)
- Chrome browser (for web development)
- Android Studio / VS Code (recommended)

### Optional Software

- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Verification

Run these commands to verify your setup:

```bash
flutter doctor
flutter --version
dart --version
```

All commands should complete without errors. 