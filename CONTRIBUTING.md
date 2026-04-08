# Contributing to firebase_cloud_messaging_dart

First off, thank you for considering contributing to `firebase_cloud_messaging_dart`! It's people like you that make the open-source community such an amazing place to learn, inspire, and create.

All types of contributions are encouraged and valued. See the [Table of Contents](#table-of-contents) for different ways to help and details about how this project handles them. Please make sure to read the relevant section before making your contribution. It will make it a lot easier for us maintainers and smooth out the experience for all involved.

## Table of Contents

- [Contributing to firebase_cloud_messaging_dart](#contributing-to-firebase_cloud_messaging_dart)
  - [Table of Contents](#table-of-contents)
  - [Code of Conduct](#code-of-conduct)
  - [How Can I Contribute?](#how-can-i-contribute)
    - [Reporting Bugs](#reporting-bugs)
    - [Suggesting Enhancements](#suggesting-enhancements)
    - [Pull Requests](#pull-requests)
  - [Development Setup](#development-setup)
    - [Dependencies](#dependencies)
    - [Running Tests](#running-tests)
  - [Architecture Overview](#architecture-overview)
  - [Project Standards](#project-standards)

## Code of Conduct

This project and everyone participating in it is governed by a Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

If you find a bug, please create an issue with:

- A clear title and description.
- Steps to reproduce the bug.
- Actual vs Expected behavior.
- Environment details (Dart/Flutter version).

### Suggesting Enhancements

We welcome ideas for new features or improvements (e.g., adding support for new FCM features as they are released by Google).

### Pull Requests

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes (`flutter test`).
5. Make sure your code lints (`dart analyze`).

## Development Setup

### Dependencies

This project uses `json_serializable` for model mapping. You'll need to run code generation if you modify any models in `lib/src/logic/`.

```bash
# Get dependencies
dart pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs
```

### Running Tests

We use the standard Dart/Flutter test framework.

```bash
# For pure Dart environments
dart test

# For Flutter environments (recommended if you encounter SDK snapshot issues)
flutter test
```

## Architecture Overview

- **`lib/firebase_cloud_messaging_dart.dart`**: The public "barrel" file. Don't add logic here; only exports.
- **`lib/src/firebase_cloud_messaging_server.dart`**: The main service class. Handles authentication and API orchestration.
- **`lib/src/logic/`**: Contains all data models and sub-logic (Android, APNs, WebPush configurations).
- **`example/`**: A working demonstration of the package.

## Project Standards

- **Strict Null-Safety**: Never use `as dynamic` or `!` unless absolutely necessary.
- **Documentation**: Use `///` for all public classes and methods. Explain *why* a certain parameter exists if it's not obvious from the FCM spec.
- **Immutability**: Prefer `final` fields and `const` constructors for data models.
- **Clean API**: Keep the public API surface minimal. Use `internal` or private members for implementation details.

---

Thank you for your help!
