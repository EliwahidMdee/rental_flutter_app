# Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │    ADMIN     │  │  LANDLORD    │  │   TENANT     │          │
│  │  Dashboard   │  │  Dashboard   │  │  Dashboard   │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Reports    │  │ Properties   │  │  Payments    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Tenants    │  │ Maintenance  │  │   Lease      │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌────────────────────────────────────────────────┐             │
│  │         Notifications & Messages               │             │
│  └────────────────────────────────────────────────┘             │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                      STATE MANAGEMENT LAYER                      │
│                        (Riverpod Providers)                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Dashboard  │  │   Property   │  │   Payment    │          │
│  │   Provider   │  │   Provider   │  │   Provider   │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │    Lease     │  │   Tenant     │  │ Maintenance  │          │
│  │   Provider   │  │   Provider   │  │   Provider   │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐                             │
│  │Notification  │  │    Report    │                             │
│  │  Provider    │  │   Provider   │                             │
│  └──────────────┘  └──────────────┘                             │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                               │
│                       (Repositories)                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Dashboard  │  │   Property   │  │   Payment    │          │
│  │  Repository  │  │  Repository  │  │  Repository  │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │    Lease     │  │    Tenant    │  │ Maintenance  │          │
│  │  Repository  │  │  Repository  │  │  Repository  │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │Notification  │  │    Report    │  │     Auth     │          │
│  │  Repository  │  │  Repository  │  │  Repository  │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                      NETWORK & STORAGE LAYER                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────────┐        ┌─────────────────────┐         │
│  │     API Client      │        │   Local Storage     │         │
│  │   (Dio + Auth)      │        │   (Hive Boxes)      │         │
│  └─────────────────────┘        └─────────────────────┘         │
│            ↓                              ↓                      │
│  ┌─────────────────────┐        ┌─────────────────────┐         │
│  │   Network Info      │        │  Secure Storage     │         │
│  │  (Connectivity)     │        │    (Tokens)         │         │
│  └─────────────────────┘        └─────────────────────┘         │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                               ↓
                     ┌──────────────────┐
                     │   Backend API    │
                     │    (Laravel)     │
                     └──────────────────┘
```

## Data Flow

### Fetching Data (Read Operations)

```
1. User opens screen
   ↓
2. Screen watches Provider
   ↓
3. Provider calls Repository
   ↓
4. Repository checks Network Info
   ↓
5a. If Online:                    5b. If Offline:
    → Call API Client                 → Read from Local Storage
    → Receive data from API           → Return cached data
    → Cache in Local Storage          
    → Return fresh data               
   ↓
6. Provider notifies Screen
   ↓
7. Screen rebuilds with data
```

### Saving Data (Write Operations)

```
1. User submits form
   ↓
2. Screen calls Provider method
   ↓
3. Provider calls Repository
   ↓
4. Repository sends to API Client
   ↓
5. API Client sends to Backend
   ↓
6. Backend processes & responds
   ↓
7. Repository caches response
   ↓
8. Provider updates state
   ↓
9. Screen shows success/error
```

## Component Responsibilities

### Presentation Layer
- **Screens:** Display UI, handle user interactions
- **Widgets:** Reusable UI components
- **State:** Loading, Error, Empty states

### State Management
- **Providers:** Reactive state management
- **State Notifiers:** Complex state logic
- **Filters:** Query parameters for data

### Data Layer
- **Repositories:** Business logic, caching strategy
- **Models:** Data structures with serialization
- **API Client:** HTTP requests, error handling

### Core Layer
- **Network Info:** Connectivity status
- **Local Storage:** Offline caching
- **Secure Storage:** Token management
- **Utils:** Formatters, validators

## Offline-First Strategy

```
┌─────────────────────────────────────────┐
│         Repository Request              │
└─────────────────────────────────────────┘
                    ↓
         [Check Network Status]
                    ↓
            ┌──────────────┐
            │   Online?    │
            └──────────────┘
                ↙         ↘
          Yes               No
           ↓                 ↓
    ┌──────────┐      ┌──────────┐
    │ Fetch    │      │ Return   │
    │ from API │      │ Cached   │
    └──────────┘      └──────────┘
           ↓                 ↓
    ┌──────────┐            │
    │  Cache   │            │
    │  Result  │            │
    └──────────┘            │
           ↓                ↓
    ┌─────────────────────────┐
    │   Return to Provider    │
    └─────────────────────────┘
```

## Authentication Flow

```
┌──────────────┐
│ Splash Screen│  (Video plays)
└──────────────┘
       ↓
┌──────────────┐
│ Login Screen │
└──────────────┘
       ↓
   [Submit]
       ↓
┌──────────────┐
│ Auth Provider│
└──────────────┘
       ↓
┌──────────────┐
│Auth Repository│
└──────────────┘
       ↓
┌──────────────┐
│  API Client  │
└──────────────┘
       ↓
┌──────────────┐
│ Backend API  │
└──────────────┘
       ↓
  [Response]
       ↓
┌──────────────┐
│ Save Token   │
│ Save User    │
└──────────────┘
       ↓
┌──────────────┐
│ Navigate to  │
│  Dashboard   │
└──────────────┘
```

## Role-Based Navigation

```
Admin User:
┌──────────────┐
│  Dashboard   │ ← Default
├──────────────┤
│   Reports    │
├──────────────┤
│  Payments    │
├──────────────┤
│   Profile    │
└──────────────┘

Landlord User:
┌──────────────┐
│  Dashboard   │ ← Default
├──────────────┤
│ Properties   │
├──────────────┤
│   Tenants    │
├──────────────┤
│   Profile    │
└──────────────┘

Tenant User:
┌──────────────┐
│  Dashboard   │ ← Default
├──────────────┤
│  Payments    │
├──────────────┤
│ Maintenance  │
├──────────────┤
│   Profile    │
└──────────────┘
```

## Error Handling

```
┌────────────────────┐
│  API Call Fails    │
└────────────────────┘
         ↓
┌────────────────────┐
│  Repository        │
│  catches error     │
└────────────────────┘
         ↓
┌────────────────────┐
│  Provider          │
│  receives error    │
└────────────────────┘
         ↓
┌────────────────────┐
│  Screen shows      │
│  ErrorDisplay      │
└────────────────────┘
         ↓
  [User taps Retry]
         ↓
┌────────────────────┐
│  Invalidate        │
│  Provider          │
└────────────────────┘
         ↓
   [Try again]
```

## Caching Strategy

```
Data Types:

┌─────────────────────────────────────────┐
│ Short-lived (Clear on logout)           │
│ - Dashboard stats                       │
│ - Notifications                         │
│ - Recent payments                       │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ Long-lived (Persist until changed)      │
│ - Properties                            │
│ - Tenants                               │
│ - Leases                                │
│ - Maintenance history                   │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ Secure (Encrypted storage)              │
│ - Auth token                            │
│ - User credentials                      │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ Permanent (Never cleared)               │
│ - Settings                              │
│ - Theme preference                      │
└─────────────────────────────────────────┘
```

## Technology Stack

```
┌─────────────────────────────────────────┐
│           Frontend (Flutter)            │
├─────────────────────────────────────────┤
│ • Flutter 3.x                           │
│ • Dart 3.2+                             │
│ • Material 3 Design                     │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│         State Management                │
├─────────────────────────────────────────┤
│ • Riverpod 2.5+                         │
│ • State Notifier                        │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│            Networking                   │
├─────────────────────────────────────────┤
│ • Dio 5.4+ (HTTP Client)                │
│ • Connectivity Plus                     │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│          Local Storage                  │
├─────────────────────────────────────────┤
│ • Hive 2.2+ (Caching)                   │
│ • Secure Storage (Tokens)               │
│ • Shared Preferences (Settings)         │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│            Navigation                   │
├─────────────────────────────────────────┤
│ • GoRouter 17.0+                        │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│           UI Components                 │
├─────────────────────────────────────────┤
│ • Google Fonts                          │
│ • Cached Network Image                  │
│ • Video Player + Chewie                 │
│ • FL Chart (Reports)                    │
│ • Shimmer (Loading)                     │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│       Backend (Existing)                │
├─────────────────────────────────────────┤
│ • Laravel                               │
│ • Sanctum (Auth)                        │
│ • MySQL                                 │
└─────────────────────────────────────────┘
```

## Key Design Decisions

### 1. Offline-First Architecture
- **Why:** Ensures app works without internet
- **How:** Hive caching with network checks
- **Benefit:** Better UX, faster load times

### 2. Repository Pattern
- **Why:** Separates data logic from UI
- **How:** Repositories handle API + cache
- **Benefit:** Testable, maintainable, reusable

### 3. Riverpod State Management
- **Why:** Modern, reactive, type-safe
- **How:** Providers watch repositories
- **Benefit:** Less boilerplate, better DX

### 4. Clean Architecture
- **Why:** Scalable, maintainable codebase
- **How:** Layered separation of concerns
- **Benefit:** Easy to test, modify, extend

### 5. Material 3 Design
- **Why:** Modern, accessible, consistent
- **How:** Theme configuration + widgets
- **Benefit:** Professional appearance

### 6. Role-Based Navigation
- **Why:** Different user needs
- **How:** AppShell with role checks
- **Benefit:** Focused user experience

## Performance Optimizations

### 1. Lazy Loading
- Providers use `.autoDispose`
- Data released when not needed

### 2. Pagination
- Lists load in chunks
- Reduces memory usage

### 3. Image Caching
- Cached Network Image
- Reduces bandwidth

### 4. State Preservation
- Hive caching
- Instant app startup

### 5. Video Optimization
- Splash video compressed
- Fallback to image

## Security Measures

### 1. Token Management
- Secure storage for tokens
- Auto-logout on expiration

### 2. API Security
- Bearer token authentication
- HTTPS only

### 3. Input Validation
- Client-side validation
- Server-side verification

### 4. Error Handling
- No sensitive data in errors
- Safe error messages

### 5. Role-Based Access
- UI level checks
- API level enforcement

## Future Enhancements

1. **Push Notifications:** Firebase Cloud Messaging
2. **Real-time Updates:** WebSockets or Polling
3. **Advanced Search:** Filters and sorting
4. **File Uploads:** Image picker integration
5. **Analytics:** Usage tracking
6. **Biometric Auth:** Fingerprint/Face ID
7. **Multi-language:** Internationalization
8. **Tablet Support:** Responsive layouts
9. **Dark Mode:** Already supported!
10. **Accessibility:** Screen reader support
