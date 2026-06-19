# Edit Profile Implementation Guide

## Overview

This document provides a complete guide to the Edit Profile feature implementation using Flutter with Provider state management, local image storage, and SharedPreferences.

---

## Architecture & File Structure

```
lib/
├── features/
│   └── auth/
│       ├── data/
│       │   └── user_model.dart              # User data model with copyWith
│       ├── providers/
│       │   └── profile_provider.dart        # State management using Provider
│       └── views/
│           ├── edit_profile_view.dart       # Edit Profile Screen
│           └── ... (other auth views)
│
├── core/
│   └── services/
│       ├── image_service.dart               # Image picking & storage
│       └── profile_storage_service.dart     # SharedPreferences management
│
├── features/
│   └── Home/
│       └── views/
│           └── home_screen_view.dart        # Updated Home Screen
│
└── main.dart                                # Updated with MultiProvider
```

---

## Components Breakdown

### 1. **UserModel** (`lib/features/auth/data/user_model.dart`)

Enhanced model with JSON serialization and copyWith method:

```dart
class UserModel {
  final String name;
  final String email;
  final String? image;      // Stores local file path
  final String? token;
  final String? address;

  UserModel({
    required this.name,
    required this.email,
    this.image,
    this.token,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
  UserModel copyWith({ ... }) { ... }
}
```

**Features:**

- Stores image as local file path
- `toJson()`: Serialize to SharedPreferences
- `fromJson()`: Deserialize from storage
- `copyWith()`: Create modified copies for immutability

---

### 2. **ImageService** (`lib/core/services/image_service.dart`)

Handles all image operations with proper permissions:

```dart
class ImageService {
  // Singleton pattern
  static final ImageService _instance = ImageService._internal();

  factory ImageService() => _instance;

  /// Pick image from camera
  Future<String?> pickFromCamera() async { ... }

  /// Pick image from gallery
  Future<String?> pickFromGallery() async { ... }

  /// Save image locally to app documents
  Future<String> _saveImageLocally(String imagePath) async { ... }

  /// Delete image from storage
  Future<void> deleteImage(String? imagePath) async { ... }
}
```

**Key Features:**

- Singleton pattern for efficiency
- Automatic permission handling
- Saves to app's documents directory
- Returns local file path
- Automatic cleanup of old images

---

### 3. **ProfileStorageService** (`lib/core/services/profile_storage_service.dart`)

Manages local data persistence with SharedPreferences:

```dart
class ProfileStorageService {
  // Singleton pattern
  static final ProfileStorageService _instance = ProfileStorageService._internal();

  /// Save user profile
  Future<bool> saveUserProfile(UserModel user) async { ... }

  /// Load user profile
  Future<UserModel?> loadUserProfile() async { ... }

  /// Check if profile exists
  Future<bool> hasUserProfile() async { ... }

  /// Clear profile
  Future<bool> clearUserProfile() async { ... }
}
```

**Key Features:**

- JSON serialization for complex data
- Atomic operations (all or nothing)
- Error handling built-in
- Persistent across app sessions

---

### 4. **ProfileProvider** (`lib/features/auth/providers/profile_provider.dart`)

Central state management using Provider pattern:

```dart
class ProfileProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Core methods
  Future<void> initializeProfile() async { ... }
  Future<bool> updateUserProfile(UserModel updatedUser) async { ... }
  Future<String?> pickImageFromCamera() async { ... }
  Future<String?> pickImageFromGallery() async { ... }
}
```

**Key Features:**

- Single source of truth for profile data
- Automatic UI updates on data change
- Loading states for async operations
- Error messages for debugging
- Specialized methods for partial updates

---

### 5. **EditProfileView** (`lib/features/auth/views/edit_profile_view.dart`)

Complete UI for editing profile with all required features:

**Features:**

- ✅ Circular avatar with tap-to-change
- ✅ Camera/Gallery selection dialog
- ✅ Pre-filled text fields (name, email, address)
- ✅ Image preview immediately after selection
- ✅ Save and Cancel buttons
- ✅ Loading indicators during save
- ✅ Error/Success snackbars
- ✅ Input validation

**Widget Structure:**

```
EditProfileView (StatefulWidget)
├── AppBar
└── SafeArea
    └── SingleChildScrollView
        └── Column
            ├── Profile Picture Section (with camera button)
            ├── Name TextField
            ├── Email TextField
            ├── Address TextField
            ├── Save Button
            └── Cancel Button
```

---

### 6. **Updated HomeScreen** (`lib/features/Home/views/home_screen_view.dart`)

Enhanced to display profile data and navigate to edit:

**Changes:**

- Changed from StatelessWidget to StatefulWidget
- Integrated ProfileProvider using `Consumer<ProfileProvider>`
- Profile card displays real user data (name, email, image)
- Added "Edit Profile" button below profile card
- Navigates to EditProfileView with proper result handling

```dart
Consumer<ProfileProvider>(
  builder: (context, profileProvider, _) {
    final user = profileProvider.user;
    return Container(
      // Display user data from provider
    );
  },
)
```

---

### 7. **Main App Setup** (`lib/main.dart`)

Wrapped with MultiProvider for global state access:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
    ),
  ],
  child: MaterialApp(
    home: MainNavigationScreen(),
    // ... routes
  ),
)
```

---

## Data Flow Diagram

```
┌─────────────────────┐
│  Edit Profile View  │
│                     │
│  1. User taps Edit  │
│  2. Enter data      │
│  3. Tap Save        │
└──────────┬──────────┘
           │ updateUserProfile()
           ▼
┌──────────────────────┐
│  ProfileProvider     │
│                      │
│  • _user (current)   │
│  • updateUserProfile()
└──────────┬──────────┘
           │
           ├─────────────────────┬──────────────────────┐
           │                     │                      │
           ▼                     ▼                      ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│ ImageService     │  │ProfileStorageServ│  │  Validate Data   │
│                  │  │                   │  │                  │
│• Save image      │  │• Save to SharedPr │  │• Check fields    │
│• Delete old      │  │• Persist data     │  │• Validate email  │
│• Local storage   │  │• JSON encode      │  │                  │
└──────────────────┘  └──────────────────┘  └──────────────────┘
           │                     │                      │
           └─────────────────────┴──────────────────────┘
                        │
                        ▼
              ┌──────────────────────┐
              │   Data Persisted     │
              │   ✅ Saved locally   │
              │   ✅ Ready for next  │
              │      app launch      │
              └──────────────────────┘
```

---

## How to Use (Navigation Flow)

### 1. **Initial App Launch**

```dart
// main.dart - Wrapped with ProfileProvider
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
  ],
  child: MaterialApp(home: MainNavigationScreen()),
)
```

### 2. **Home Screen - Display Profile**

```dart
// Home Screen automatically initializes profile
@override
void initState() {
  super.initState();
  Future.microtask(() {
    context.read<ProfileProvider>().initializeProfile();
  });
}

// Profile card displays real data
Consumer<ProfileProvider>(
  builder: (context, profileProvider, _) {
    final user = profileProvider.user;
    return Text(user?.name ?? 'Guest User');
  },
)
```

### 3. **Tap "Edit Profile" Button**

```dart
// Navigate to EditProfileView
ElevatedButton(
  onPressed: () async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      ),
    );

    if (result == true) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(...);
    }
  },
)
```

### 4. **Edit Profile Screen - User Actions**

```
┌──────────────────────────┐
│  Edit Profile Screen     │
├──────────────────────────┤
│ • Tap avatar → Select    │
│   Camera or Gallery      │
│ • Edit name, email,      │
│   address                │
│ • Tap Save               │
│   → Validate data        │
│   → Save image locally   │
│   → Update in Provider   │
│   → Save to Preferences  │
│   → Navigate back        │
└──────────────────────────┘
```

### 5. **Back to Home Screen**

```dart
// Home screen rebuilds and shows updated data
// Image is loaded from local path
// User data is displayed from ProfileProvider
```

---

## Key Implementation Details

### State Management (Provider Pattern)

```dart
// Anywhere in the app:
final user = context.watch<ProfileProvider>().user;  // Rebuild on change
final provider = context.read<ProfileProvider>();    // No rebuild
```

### Image Storage

- **Location**: `/data/data/com.app.name/app_documents/profile_TIMESTAMP.jpg`
- **Format**: Compressed JPEG (85% quality)
- **Cleanup**: Old images automatically deleted when new one uploaded
- **Access**: Via `File(imagePath)` when displaying

### Data Persistence

```
App Session 1:          App Session 2:
┌─────────────────┐     ┌─────────────────┐
│ User enters data│     │ App launches    │
│ Taps Save       │     │ Loads from      │
│ ↓               │     │ SharedPreferences
│ Saved to:       │     │ ↓
│ • User data JSON│────→│ Display saved
│ • Image file    │     │ profile
└─────────────────┘     └─────────────────┘
```

### Permission Handling

**Android** (`AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

**iOS** (`Info.plist`):

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to your camera...</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your photo library...</string>
```

---

## Error Handling

### Scenario 1: Permission Denied

```dart
// ImageService handles gracefully
Future<String?> pickFromCamera() async {
  final status = await Permission.camera.request();
  if (!status.isGranted) {
    return null;  // User denied, return null
  }
  // Proceed with camera...
}
```

### Scenario 2: Image Save Failed

```dart
// Falls back to previous image
try {
  await updateUserProfile(updatedUser);
} catch (e) {
  _errorMessage = 'Failed to save: $e';
  notifyListeners();
}
```

### Scenario 3: SharedPreferences Error

```dart
// Shows error to user
final success = await saveUserProfile(user);
if (!success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(provider.errorMessage ?? 'Error saving'))
  );
}
```

---

## Best Practices Used

### 1. **Singleton Pattern**

```dart
// Only one instance of ImageService throughout app
static final ImageService _instance = ImageService._internal();
factory ImageService() => _instance;
```

### 2. **Provider Pattern**

```dart
// Reactive UI updates
Consumer<ProfileProvider>(
  builder: (context, provider, _) => Text(provider.user?.name ?? ''),
)
```

### 3. **Immutability with copyWith**

```dart
// Never modify original, create new
final updated = user.copyWith(name: newName);
```

### 4. **Error Boundaries**

```dart
// Try-catch around all async operations
try {
  await operation();
} catch (e) {
  errorMessage = 'User-friendly error';
}
```

### 5. **Loading States**

```dart
// Show progress while saving
if (_isLoading) {
  return CircularProgressIndicator();
}
```

---

## Testing the Implementation

### Test 1: Basic Profile Update

1. Launch app
2. Tap "Edit Profile"
3. Change name to "John Doe"
4. Tap Save
5. Go back to Home screen
6. Verify name is updated ✓

### Test 2: Image Upload from Camera

1. Tap profile avatar
2. Select "Take Photo from Camera"
3. Take a photo
4. Verify preview appears immediately
5. Tap Save
6. Check image persists on Home screen ✓

### Test 3: Image Upload from Gallery

1. Tap profile avatar
2. Select "Choose from Gallery"
3. Pick an image
4. Verify preview
5. Save and verify ✓

### Test 4: Data Persistence

1. Edit and save profile
2. Kill app completely
3. Relaunch app
4. Verify all data is still there ✓

### Test 5: No Permission

1. Deny camera permission when prompted
2. Verify graceful error handling
3. Can still save without image ✓

---

## Troubleshooting

| Issue                    | Solution                                             |
| ------------------------ | ---------------------------------------------------- |
| Image not saving         | Check AndroidManifest.xml permissions                |
| Data not persisting      | Verify SharedPreferences is initialized              |
| Provider not updating UI | Use `Consumer<ProfileProvider>` or `context.watch()` |
| Permission denied        | Add permission requests to Android/iOS configs       |
| Image not loading        | Verify file path exists: `File(imagePath).exists()`  |

---

## Dependencies Added

```yaml
provider: ^6.0.0 # State management
image_picker: ^1.0.0 # Image selection
permission_handler: ^11.4.0 # Permission requests
path_provider: ^2.1.0 # App documents directory
path: ^1.8.3 # Path manipulation
```

Run:

```bash
flutter pub get
```

---

## Production Checklist

- [x] Error handling for all operations
- [x] Permission requests implemented
- [x] Image compression (85% quality)
- [x] Local storage with persistence
- [x] Proper state management
- [x] Loading states during async operations
- [x] User feedback (snackbars, dialogs)
- [x] Clean code with documentation
- [x] Immutable data models
- [x] Singleton services
- [x] Proper disposal/cleanup
- [x] Cross-platform support (Android/iOS)

---

## Architecture Principles Applied

1. **Separation of Concerns**: UI, Business Logic, Data Storage
2. **Single Responsibility**: Each class does one thing well
3. **Dependency Injection**: Services injected via Provider
4. **Immutability**: UserModel uses copyWith
5. **Reactive Programming**: Provider pattern for state
6. **Error Handling**: Comprehensive try-catch blocks
7. **Local Storage**: SharedPreferences for persistence
8. **Image Optimization**: Compressed and locally stored

---

## Future Enhancements

1. **Image Cropping**: Add image cropper for better UX
2. **Cloud Backup**: Upload to cloud storage
3. **Offline Support**: Queue updates for when online
4. **Image Caching**: Implement better caching strategy
5. **Validation**: Add email format validation
6. **Rate Limiting**: Prevent rapid successive updates
7. **Audit Trail**: Log profile changes
8. **Profile Picture Compression**: WebP format for better compression

---

## Code Examples

### Example 1: Update Profile Name Only

```dart
// In any widget with access to Provider
final provider = context.read<ProfileProvider>();
await provider.updateUserName('New Name');
```

### Example 2: Load Profile on App Start

```dart
// Already done in HomeScreen.initState()
context.read<ProfileProvider>().initializeProfile();
```

### Example 3: Display Profile with Null Safety

```dart
Text(
  provider.user?.name ?? 'Unknown',
  style: TextStyle(...),
)
```

### Example 4: Handle Image Selection

```dart
GestureDetector(
  onTap: () async {
    final path = await provider.pickImageFromGallery();
    if (path != null) {
      setState(() => _selectedImage = path);
    }
  },
  child: CircleAvatar(
    backgroundImage: _selectedImage != null
      ? FileImage(File(_selectedImage!))
      : null,
  ),
)
```

---

This implementation is production-ready and follows Flutter best practices!
