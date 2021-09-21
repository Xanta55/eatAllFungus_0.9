# Eat All Fungus

A mobile app which will run our onlinegame

## Getting Started

To Connect a Database, the according Firebasedocuments have to be installed

## Commands you may need

### Flutter

```
flutter doctor
```
If you want to check for general problems


```
dart pub get
```
For pulling packages and plugins, after specifying these in the pubspec.yaml

### Generating Dataclasses

```
flutter pub run build_runner build
```
This will generate the freezed Dataclasses


## Explanation on different Models

### User
This is a Firebasemodel and holds for example the email and is responsible for a Login.
The User is implemented with the help of Auth-Classes

A quick explanation - [FireFlutterDev](https://firebase.flutter.dev/docs/auth/usage)

### Userprofile
This holds the Metadata of each unique User.
For example the In-Game name is stored in that model

Modelfile - [UserProfile](lib/models/userProfile.dart)

### Player
This is a Player in an ongoing world.
This Model holds Data like the inventory or current Position

Modelfile - TBD
