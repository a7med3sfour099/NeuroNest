# Quick Setup Guide - Edit Profile Feature

## 🚀 Getting Started

### Step 1: Update Dependencies

Run the following command to fetch the new packages:

```bash
flutter pub get
```

**New packages added:**

- `provider: ^6.0.0` - State management
- `image_picker: ^1.0.0` - Image selection from camera/gallery
- `permission_handler: ^11.4.0` - Permission management
- `path_provider: ^2.1.0` - App documents directory access
- `path: ^1.8.3` - Path utilities

### Step 2: Platform-Specific Setup

#### Android Setup

The permissions are already added to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

✅ **No additional configuration needed for Android**

#### iOS Setup

The permissions are already added to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to your camera to take profile photos.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your photo library to select profile images.</string>
```

✅ **No additional configuration needed for iOS**

### Step 3: Run the App

```bash
flutter run
```

---

## 📋 File Structure Summary

All files have been created and integrated:

```
✅ lib/features/auth/data/user_model.dart
   - Enhanced with toJson(), fromJson(), copyWith()

✅ lib/core/services/image_service.dart
   - Image picker with camera/gallery support
   - Local image storage and cleanup

✅ lib/core/services/profile_storage_service.dart
   - SharedPreferences integration
   - JSON serialization

✅ lib/features/auth/providers/profile_provider.dart
   - Provider state management
   - Profile update and image handling

✅ lib/features/auth/views/edit_profile_view.dart
   - Complete Edit Profile screen
   - Image picker dialog
   - Form validation and submission

✅ lib/features/Home/views/home_screen_view.dart
   - Updated to display profile data
   - Added "Edit Profile" button
   - Consumer widget integration

✅ lib/main.dart
   - MultiProvider setup
   - Global ProfileProvider

✅ pubspec.yaml
   - All dependencies added

✅ android/app/src/main/AndroidManifest.xml
   - Permissions configured

✅ ios/Runner/Info.plist
   - Privacy descriptions added
```

---

## 🎯 How to Use

### Navigation Flow

```
Home Screen
    ↓
[Tap "Edit Profile" button]
    ↓
Edit Profile Screen
    ↓
[Select/Capture Image, Edit Fields, Tap Save]
    ↓
Save to:
  - SharedPreferences (user data + image path)
  - Local file system (image file)
    ↓
Back to Home Screen
    ↓
[Data persisted and displayed]
```

### User Interactions

**1. From Home Screen:**

- Profile card displays current user data
- Click "Edit Profile" button

**2. In Edit Profile Screen:**

- Tap circular avatar → Choose camera or gallery
- Edit name, email, address fields
- Click "Save Changes"

**3. Data is Saved:**

- Image saved locally
- Profile data saved to SharedPreferences
- Returns to Home with updated data

---

## ✨ Features Implemented

### Profile Picture Management

- ✅ Circular avatar with camera icon overlay
- ✅ Tap to open camera/gallery dialog
- ✅ Image preview immediately after selection
- ✅ Saves image locally to app documents
- ✅ Stores path in SharedPreferences
- ✅ Automatic cleanup of old images
- ✅ Handles "no image" state gracefully

### Form Fields

- ✅ Name field (pre-filled from saved data)
- ✅ Email field (pre-filled from saved data)
- ✅ Address field (pre-filled from saved data)
- ✅ All fields editable

### Save Functionality

- ✅ Validates all required fields
- ✅ Shows loading indicator during save
- ✅ Saves to SharedPreferences
- ✅ Navigates back with success
- ✅ Shows error snackbar on failure

### Home Screen Integration

- ✅ Displays saved profile picture
- ✅ Shows saved name
- ✅ Shows saved email
- ✅ Loads on app initialization
- ✅ Updates when returning from edit

### Permission Handling

- ✅ Camera permission request
- ✅ Photo library permission request
- ✅ Graceful degradation if denied
- ✅ Platform-specific handling (Android/iOS)

### Error Handling

- ✅ Permission denied handling
- ✅ Image save failure handling
- ✅ SharedPreferences failure handling
- ✅ Network/Storage errors caught
- ✅ User-friendly error messages

---

## 🔍 Testing Checklist

### Test 1: Basic Profile Update

- [ ] Launch app
- [ ] Tap "Edit Profile" button
- [ ] Change name to "John Doe"
- [ ] Tap "Save Changes"
- [ ] Verify name updated on Home screen

### Test 2: Image from Camera

- [ ] Tap profile avatar
- [ ] Select "Take Photo from Camera"
- [ ] Take a photo
- [ ] Verify preview appears
- [ ] Tap Save
- [ ] Verify image appears on Home screen

### Test 3: Image from Gallery

- [ ] Tap profile avatar
- [ ] Select "Choose from Gallery"
- [ ] Select an image
- [ ] Verify preview
- [ ] Save and verify on Home screen

### Test 4: Data Persistence

- [ ] Edit profile with all details
- [ ] Save
- [ ] Kill app (swipe from recent apps)
- [ ] Relaunch app
- [ ] Verify all data persists

### Test 5: Permission Handling

- [ ] Deny camera permission
- [ ] Verify graceful error message
- [ ] Still able to save without image

### Test 6: Empty Fields Validation

- [ ] Clear name field
- [ ] Try to save
- [ ] Verify error message
- [ ] Fill field and try again

### Test 7: Cancel Operation

- [ ] Tap "Edit Profile"
- [ ] Change some data
- [ ] Tap "Cancel"
- [ ] Verify changes not saved

---

## 🐛 Debugging Tips

### Check Saved Data

```dart
// In any widget with Provider access:
final provider = context.read<ProfileProvider>();
print('User: ${provider.user?.name}');
print('Image: ${provider.user?.image}');
print('Email: ${provider.user?.email}');
```

### Verify SharedPreferences Storage

```dart
// In console/debugger:
final prefs = await SharedPreferences.getInstance();
print(prefs.getString('user_profile_data'));
```

### Check File System

```dart
// Verify image file exists:
final file = File(provider.user?.image ?? '');
print('Image exists: ${await file.exists()}');
```

### Enable Provider Logging

```dart
// In main.dart for debugging:
// Just observe provider changes in widgets
```

---

## 📱 Testing on Device/Emulator

### Android Emulator

```bash
flutter run
```

- Tap "Take Photo from Camera" → built-in camera works
- Tap "Choose from Gallery" → built-in gallery works

### iOS Simulator

```bash
flutter run -d iPhone
```

- Permissions will be requested
- Gallery access works automatically

### Physical Device

```bash
flutter run -d <device-id>
```

- Grant camera permission when prompted
- Grant photo library permission when prompted

---

## 🚨 Common Issues & Solutions

### Issue: Image not saving

**Solution:** Check permissions in AndroidManifest.xml and Info.plist are set correctly

### Issue: Provider not updating UI

**Solution:** Use `Consumer<ProfileProvider>` or `context.watch()` to rebuild

### Issue: Data not persisting

**Solution:** Verify SharedPreferences package is initialized: `flutter pub get`

### Issue: Permission denied

**Solution:** This is handled gracefully - user can still save without image

### Issue: Build errors

**Solution:** Run `flutter clean && flutter pub get && flutter run`

---

## 🎓 Learning Resources

### Provider Documentation

- https://pub.dev/packages/provider
- Pattern used: ChangeNotifier + Consumer

### Image Picker Documentation

- https://pub.dev/packages/image_picker
- Handles camera and gallery selection

### Permission Handler Documentation

- https://pub.dev/packages/permission_handler
- Cross-platform permission management

### SharedPreferences Documentation

- https://pub.dev/packages/shared_preferences
- Local data persistence

---

## 📞 Support

If you encounter issues:

1. Check the implementation guide: `EDIT_PROFILE_IMPLEMENTATION.md`
2. Review error messages in logcat/console
3. Verify all files are created in correct locations
4. Ensure all dependencies are installed: `flutter pub get`
5. Try `flutter clean` and rebuild

---

## ✅ Production Ready

This implementation includes:

- ✅ Error handling
- ✅ Loading states
- ✅ Permission management
- ✅ Data validation
- ✅ User feedback (snackbars)
- ✅ Proper state management
- ✅ Memory efficiency
- ✅ Cross-platform support
- ✅ Local persistence
- ✅ Clean architecture

**You're ready to ship!** 🚀
