# Specification: User Authentication Flow

## Overview
Implement a comprehensive and secure user authentication system for the Flutter e-commerce app using Supabase. This includes standard email/password sign-up and log-in, along with local biometric authentication (Fingerprint/FaceID) for returning users.

## User Stories
- As a new user, I want to create an account using my email and password so I can access personalized features.
- As a returning user, I want to log in securely with my credentials.
- As a returning user, I want to use my device's biometrics to log in quickly without re-entering my password.
- As a user, I want to be able to reset my password if I forget it.

## Functional Requirements
- **Sign-Up:**
  - Email and password input with validation.
  - Integration with Supabase Auth `signUp`.
  - Automatic profile creation in Supabase `profiles` table.
- **Log-In:**
  - Email and password input.
  - Integration with Supabase Auth `signInWithPassword`.
- **Biometric Auth:**
  - Check for biometric availability using `local_auth`.
  - Securely store a "biometric enabled" flag in `GetStorage`.
  - Prompt for biometrics on app start or return if enabled.
- **Session Management:**
  - Persist authentication state using Supabase's built-in session handling.
  - Automatic redirection to Home view if authenticated, or Login view if not.

## Non-Functional Requirements
- **Security:** Passwords are never stored locally. Sensitive data is handled by Supabase.
- **Responsiveness:** All auth screens must be responsive using `flutter_screenutil`.
- **UX:** Provide clear error messages for invalid credentials or network issues. Use loading indicators (shimmers/spinners) during async operations.

## Tech Stack Integration
- **Backend:** Supabase Auth
- **State Management:** GetX (Controllers and Bindings)
- **Local Storage:** GetStorage (for biometric flags)
- **Biometrics:** `local_auth` package
- **Forms:** `flutter_form_builder`
