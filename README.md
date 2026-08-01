# Pet Care Management Platform — Build Roadmap

## Tech stack

- **Flutter** — single codebase for mobile (Android/iOS), web, and desktop
- **Firebase Auth** — email/password + Google sign-in
- **Cloud Firestore** — main database (profiles, records, bookings, posts)
- **Firebase Storage** — pet photos, vet documents
- **Firebase Cloud Messaging (FCM)** — push notifications for reminders
- **Cloud Functions** (later) — scheduled reminder checks, server-side logic
- **Riverpod** — state management (recommended over Provider/Bloc for a project this size — good balance of power and learning curve)
- **go_router** — navigation, since multi-platform apps need proper URL-based routing on web

## Why this order

"Full platform" (profiles, reminders, vet booking, community) is four different apps glued together. Building all four at once means nothing works for weeks. Instead we build **one vertical slice at a time** — each phase produces something real you can run and show off, and each teaches a distinct Flutter/Firebase skill.

## Phase 0 — Foundation (Week 1)
**Teaches:** project structure, Firebase setup, Auth flow, navigation
- Flutter project scaffold, folder structure (feature-first, not layer-first)
- Firebase project setup (all platforms configured — this is where multi-platform pain shows up early)
- Auth: sign up, login, logout, auth state persistence
- go_router setup with auth-guarded routes

## Phase 1 — Pet Profiles (Weeks 2–3)
**Teaches:** Firestore CRUD, Firebase Storage, forms, state management basics
- Data model: Pet (name, species, breed, DOB, photo, owner household)
- Add/edit/delete pet, photo upload to Storage
- Pet list + detail screens
- Multi-pet household support (one account, many pets)

## Phase 2 — Health Records (Week 4)
**Teaches:** nested Firestore collections, date handling, filtering/sorting
- Vaccination history, weight log, medication log, vet visit notes
- Attach documents/photos (e.g. vaccination certificates) via Storage

## Phase 3 — Reminders & Scheduling (Weeks 5–6)
**Teaches:** local notifications, FCM, background scheduling, Cloud Functions basics
- Recurring reminders: feeding, meds, grooming, vet checkups
- Local notifications (works offline) + FCM push (works when app closed)
- A Cloud Function cron job that checks due reminders daily

## Phase 4 — Vet Booking (Weeks 7–9)
**Teaches:** modeling two-sided marketplaces, availability/calendar logic, transactions
- Vet/clinic profiles (could start as admin-seeded data, not user-generated)
- Appointment slots, booking, cancellation
- Firestore transactions to prevent double-booking

## Phase 5 — Community (Weeks 10–12)
**Teaches:** feeds, pagination, real-time listeners at scale, moderation basics
- Posts (photos, questions), comments, likes
- Feed pagination (Firestore query cursors)
- Basic reporting/moderation flow

## Feature ideas worth considering (beyond the core four)

- **Lost pet alerts** — geolocation-based broadcast to nearby users
- **Shared household access** — invite a partner/family member to co-manage a pet's profile
- **QR code pet tag** — generates a public read-only profile page (useful if pet is found)
- **Expense tracker** — log vet bills, food costs, grooming costs per pet
- **Breed-specific care tips** — static content or a simple API-driven info panel
- **Multi-language support** — Flutter's intl package, worth planning folder structure for early
- **Offline-first** — Firestore's offline persistence is on by default, but worth testing deliberately since owners may use this in vet waiting rooms with poor signal
- **Export health records to PDF** — handy before a vet visit or when switching vets
- **Weight trend charts** — simple line chart per pet using `fl_chart`

## Platform-specific notes to keep in mind

- **Web**: Firebase Auth persistence and Storage CORS need explicit setup (you already hit a related web-specific Firebase issue last time — good sign to sort platform config early)
- **Desktop**: Firebase doesn't have official Windows/Linux SDKs — desktop typically goes through `firebase_core` + REST fallback or community wrappers; this is the trickiest platform and we should confirm it works before building deep into it
- **Responsive UI**: one codebase, but pet profile grids/forms need different layouts on phone vs. wide desktop window — we'll use `LayoutBuilder`/breakpoints rather than separate UIs