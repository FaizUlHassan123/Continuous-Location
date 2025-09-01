# Continuous Location Tracking iOS App

A robust iOS application that provides continuous location tracking with geofencing capabilities, map visualization, and push notifications for location-based events.

## 🚀 Features

- **Continuous Location Tracking**: Real-time location monitoring using Core Location framework
- **Geofencing**: Automatic detection when users enter or exit defined circular regions (50m radius)
- **Interactive Map**: MapKit integration with user location display and circular region overlays
- **Push Notifications**: Local notifications for check-in/check-out events
- **Background Processing**: Maintains location tracking when app is in background
- **Manual Testing**: Long-press gesture on map to simulate user movement for testing
- **Permission Management**: Handles location authorization flow (When in Use → Always)

## 📱 Requirements

- iOS 15.6+
- Xcode 12.0+
- Swift 5.0+

## 🛠 Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/FaizUlHassan123/Continuous-Location.git
   cd "Continuous Location"
   ```

2. **Open in Xcode**
   ```bash
   open "Continuous Location.xcodeproj"
   ```

3. **Configure Permissions**
   The app automatically requests the following permissions:
   - Location Services (When in Use → Always)
   - Push Notifications (Alert, Badge, Sound)

4. **Build and Run**
   - Select a physical device (location services work best on real devices)
   - Build and run the project (⌘+R)

## 🏗 Project Structure

```
Continuous Location/
├── AppDelegate.swift           # App initialization & notification setup
├── SceneDelegate.swift         # Scene lifecycle management
├── ViewController.swift        # Main UI controller with MapKit
├── ContinuesLocationManager.swift  # Core location tracking singleton
├── Constants.swift             # Utility constants & UI extensions
├── Info.plist                 # App configuration & permissions
└── Base.lproj/
    ├── Main.storyboard        # UI layout
    └── LaunchScreen.storyboard # Launch screen
```

## 🔧 Core Components

### ContinuesLocationManager
- **Singleton Pattern**: Manages all location-related functionality
- **Region Monitoring**: Creates and monitors circular geofences
- **Permission Handling**: Automatically escalates from "When in Use" to "Always" permission
- **API Integration**: Ready for backend integration (currently commented out)

### ViewController
- **Map Display**: Shows user location with 1km zoom region
- **Visual Feedback**: Draws 500m radius circles around tracked locations
- **Testing Interface**: Long-press gesture to simulate location changes
- **Real-time Updates**: Responds to location changes automatically

### Key Features Implementation

#### Location Tracking
```swift
// Start tracking with custom coordinates and API endpoint
locationManager.startTrackUser(
    lat: 45.5019, 
    long: -73.5674, 
    apiEndPoint: "your-api-endpoint", 
    userID: 123
)
```

#### Geofencing
- **Radius**: 50 meters
- **Events**: Entry and exit detection
- **Notifications**: Automatic check-in/check-out alerts

#### Background Modes
Configured in `Info.plist`:
- Background App Refresh
- Background Processing

## 🎯 Usage

### Basic Operation
1. **Launch App**: Grants location permissions when prompted
2. **View Map**: See your current location with circular overlay
3. **Automatic Tracking**: App creates geofence around your location
4. **Receive Notifications**: Get alerts when entering/exiting tracked areas

### Testing Features
1. **Simulate Movement**: Long-press anywhere on the map
2. **Visual Feedback**: New circle overlay appears at touched location
3. **Test Geofencing**: Move outside current region to trigger exit notification

### API Integration
The app is prepared for backend integration. Uncomment the API call code in `ContinuesLocationManager.swift` (`checkInOrCheckOutUser` method) and configure your endpoint.

## ⚙️ Configuration

### Default Settings
- **Accuracy**: `kCLLocationAccuracyBestForNavigation`
- **Distance Filter**: No filter (tracks all location changes)
- **Region Radius**: 50 meters
- **Map Region**: 1000 meters (1km zoom)
- **Overlay Radius**: 500 meters (visual indicator)

### Customization
Modify these values in `ContinuesLocationManager.swift`:
```swift
let regionRadius = 50.0  // Geofence radius
let mapRegionMeters = 1000  // Map zoom level
let overlayRadius = 500  // Visual circle radius
```

## 🔒 Privacy & Permissions

### Location Services
- **Initial**: "When in Use" permission
- **Escalation**: Automatically requests "Always" permission
- **Fallback**: Shows settings alert if denied

### Push Notifications
- **Types**: Alert, Badge, Sound
- **Purpose**: Check-in/check-out notifications
- **Timing**: 2-second delay after region events

## 📝 Notes

- **UserDefaults Storage**: App stores tracking parameters for persistence
- **Thread Safety**: Location updates handled on main queue
- **Memory Management**: Proper cleanup when stopping tracking
- **Authorization Flow**: Graceful handling of all permission states

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is available under the MIT License. See the LICENSE file for more info.

---
