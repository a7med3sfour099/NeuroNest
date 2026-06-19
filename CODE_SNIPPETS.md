# Code Snippets Reference - Edit Profile Feature

Quick reference for common usage patterns.

## 🎯 Using ProfileProvider in Widgets

### 1. Watch Profile Data (Rebuilds on Change)

```dart
// In any widget
@override
Widget build(BuildContext context) {
  final user = context.watch<ProfileProvider>().user;

  return Text(user?.name ?? 'Unknown');
  // Widget rebuilds whenever user data changes
}
```

### 2. Read Profile Data (No Rebuild)

```dart
// In button onPressed or similar
onPressed: () {
  final provider = context.read<ProfileProvider>();
  print('Current user: ${provider.user?.name}');
}
```

### 3. Use Consumer Pattern (Scoped Rebuild)

```dart
// Only specified widget rebuilds
Consumer<ProfileProvider>(
  builder: (context, profileProvider, child) {
    return Text(profileProvider.user?.name ?? 'Guest');
  },
)
```

---

## 🖼️ Displaying Profile Image

### Display with Fallback

```dart
CircleAvatar(
  radius: 60,
  backgroundColor: Colors.grey.shade200,
  backgroundImage: user?.image != null && user!.image!.isNotEmpty
      ? FileImage(File(user.image!))
      : null,
  child: user?.image == null || user?.image?.isEmpty == true
      ? Icon(Icons.person, size: 50, color: Colors.grey)
      : null,
)
```

### Display from Local File

```dart
Image.file(
  File(user.image!),
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.image_not_supported);
  },
)
```

---

## 📝 Updating Profile Data

### Update Entire Profile

```dart
final provider = context.read<ProfileProvider>();

final updatedUser = UserModel(
  name: 'John Doe',
  email: 'john@example.com',
  address: '123 Main St',
  image: imagePath,
  token: provider.user?.token,
);

final success = await provider.updateUserProfile(updatedUser);

if (success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Profile updated!'))
  );
}
```

### Update Single Field

```dart
final provider = context.read<ProfileProvider>();

// Update name only
await provider.updateUserName('Jane Doe');

// Update email only
await provider.updateUserEmail('jane@example.com');

// Update address only
await provider.updateUserAddress('456 Oak Ave');

// Update image only
await provider.updateUserImage(newImagePath);
```

---

## 🖼️ Image Picking

### Pick from Camera

```dart
final provider = context.read<ProfileProvider>();

final imagePath = await provider.pickImageFromCamera();

if (imagePath != null) {
  // Image selected successfully
  setState(() => _selectedImage = imagePath);
} else {
  // Permission denied or cancelled
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Camera access denied'))
  );
}
```

### Pick from Gallery

```dart
final provider = context.read<ProfileProvider>();

final imagePath = await provider.pickImageFromGallery();

if (imagePath != null) {
  setState(() => _selectedImage = imagePath);
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('No image selected'))
  );
}
```

### Combined Dialog

```dart
void _showImageSourceDialog() {
  showModalBottomSheet(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text('Camera'),
          onTap: () async {
            Navigator.pop(context);
            final path = await context
                .read<ProfileProvider>()
                .pickImageFromCamera();
            if (path != null) {
              setState(() => _selectedImage = path);
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('Gallery'),
          onTap: () async {
            Navigator.pop(context);
            final path = await context
                .read<ProfileProvider>()
                .pickImageFromGallery();
            if (path != null) {
              setState(() => _selectedImage = path);
            }
          },
        ),
      ],
    ),
  );
}
```

---

## 💾 Loading & Saving Profile

### Load Profile on App Start

```dart
// In HomeScreen.initState()
@override
void initState() {
  super.initState();
  Future.microtask(() {
    context.read<ProfileProvider>().initializeProfile();
  });
}
```

### Save Profile

```dart
// Validate
if (_nameController.text.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Please enter name'))
  );
  return;
}

// Create updated user
final updatedUser = UserModel(
  name: _nameController.text,
  email: _emailController.text,
  address: _addressController.text,
  image: _selectedImagePath,
  token: provider.user?.token,
);

// Save
final success = await provider.updateUserProfile(updatedUser);

// Navigate back if successful
if (success && mounted) {
  Navigator.pop(context, true);
}
```

### Refresh Profile

```dart
final provider = context.read<ProfileProvider>();
await provider.refreshProfile();
```

---

## 🛠️ Error Handling

### Try-Catch Pattern

```dart
try {
  final provider = context.read<ProfileProvider>();
  await provider.updateUserProfile(updatedUser);
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${e.toString()}'))
  );
}
```

### Check Error Message

```dart
final provider = context.read<ProfileProvider>();

if (provider.errorMessage != null) {
  print('Error: ${provider.errorMessage}');

  // Clear error after showing
  provider.clearError();
}
```

### Handle Permission Denied

```dart
final imagePath = await provider.pickImageFromCamera();

if (imagePath == null) {
  // Permission denied OR user cancelled
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Camera access is required to take photos'
      ),
      action: SnackBarAction(
        label: 'Settings',
        onPressed: () {
          // Open app settings
          openAppSettings();
        },
      ),
    ),
  );
}
```

---

## 🔄 Navigation

### Navigate to Edit Screen

```dart
onPressed: () async {
  final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (context) => const EditProfileView(),
    ),
  );

  if (result == true && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully'))
    );
  }
}
```

### Using Named Routes

```dart
// In main.dart routes
'/edit-profile': (context) => const EditProfileView(),

// Navigate
Navigator.pushNamed(context, '/edit-profile').then((result) {
  if (result == true) {
    // Profile updated
  }
});
```

---

## 🎨 Building UI Components

### Profile Card with Data

```dart
Consumer<ProfileProvider>(
  builder: (context, profileProvider, _) {
    final user = profileProvider.user;

    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: user?.image != null
                ? FileImage(File(user!.image!))
                : null,
            child: user?.image == null
                ? Icon(Icons.person)
                : null,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? 'Unknown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                user?.email ?? 'unknown@example.com',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  },
)
```

### Edit Profile Button

```dart
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProfileView()),
    );
  },
  icon: Icon(Icons.edit),
  label: Text('Edit Profile'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
)
```

---

## 🔒 Data Persistence Examples

### Manually Save to SharedPreferences

```dart
// Save
final user = UserModel(
  name: 'John',
  email: 'john@example.com',
  address: '123 St',
);
await context.read<ProfileProvider>().updateUserProfile(user);

// Load
final loadedUser = await context.read<ProfileProvider>().initializeProfile();
```

### Check if Profile Exists

```dart
final provider = context.read<ProfileProvider>();

if (provider.user != null) {
  // Profile loaded
  print('Current user: ${provider.user!.name}');
} else {
  // No profile saved yet
  print('No profile found');
}
```

---

## 📱 Testing Code Examples

### Test Profile Update

```dart
void testProfileUpdate() async {
  final provider = ProfileProvider();

  // Initialize
  await provider.initializeProfile();

  // Update
  final updated = UserModel(
    name: 'Test User',
    email: 'test@example.com',
    address: 'Test Address',
  );

  final success = await provider.updateUserProfile(updated);

  // Verify
  assert(success == true);
  assert(provider.user?.name == 'Test User');
}
```

### Test Image Saving

```dart
void testImageSave() async {
  final imageService = ImageService();

  // Simulate picking image (you need actual file path)
  final testImagePath = '/path/to/test/image.jpg';

  // Save
  final savedPath = await imageService._saveImageLocally(testImagePath);

  // Verify
  assert(savedPath.isNotEmpty);
  assert(await File(savedPath).exists());
}
```

---

## ⚠️ Common Mistakes to Avoid

### ❌ DON'T: Modify user object directly

```dart
// WRONG - won't persist changes
provider.user?.name = 'New Name';
```

### ✅ DO: Use updateUserProfile or copyWith

```dart
// RIGHT - creates new object and saves
final updated = provider.user!.copyWith(name: 'New Name');
await provider.updateUserProfile(updated);
```

---

### ❌ DON'T: Use read() in build method

```dart
// WRONG - won't rebuild on changes
Widget build(BuildContext context) {
  final user = context.read<ProfileProvider>().user;
  return Text(user?.name ?? ''); // Won't update
}
```

### ✅ DO: Use watch() or Consumer in build

```dart
// RIGHT - rebuilds on changes
Widget build(BuildContext context) {
  final user = context.watch<ProfileProvider>().user;
  return Text(user?.name ?? ''); // Updates automatically
}
```

---

### ❌ DON'T: Ignore error states

```dart
// WRONG
await provider.updateUserProfile(user);
// No error handling
```

### ✅ DO: Check success and handle errors

```dart
// RIGHT
final success = await provider.updateUserProfile(user);
if (!success) {
  print('Error: ${provider.errorMessage}');
}
```

---

## 🚀 Performance Tips

### Use select() for specific fields

```dart
// Only rebuilds when specific field changes
final name = context.select<ProfileProvider, String?>(
  (provider) => provider.user?.name,
);
```

### Cache frequently accessed values

```dart
late final ProfileProvider provider;

@override
void initState() {
  super.initState();
  provider = context.read<ProfileProvider>();
}
```

### Avoid rebuilding unnecessary widgets

```dart
// Good: Consumer wraps only widget that needs data
Container(
  child: Consumer<ProfileProvider>(
    builder: (_, provider, __) => Text(provider.user?.name ?? ''),
  ),
)

// Bad: Consumer wraps whole screen
Consumer<ProfileProvider>(
  builder: (_, provider, __) => Scaffold(
    // Entire screen rebuilds on any change
  ),
)
```

---

**Use these snippets as templates for your implementation!** 🎯
