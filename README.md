📌 Overview

This is a modern, minimalistic Task Management App built using Flutter, Riverpod, and sqflite.
The entire UI is designed in a clean black & white Notion-inspired theme, with smooth interactions, a calm aesthetic, and heavy emphasis on clarity and simplicity.

Users can create task lists, add tasks with metadata (due date, priority, status), search globally, toggle themes, and enjoy a polished UX on both light/dark modes.

This project was created by Adil, a Flutter mobile developer passionate about building clean, user-friendly interfaces.

✨ Features
✅ 1. Notion-Style Modern Minimalistic UI

Pure black & white theme

Beautiful typography powered by GoogleFonts.Poppins

Large spacing, soft edges, smooth transitions

Consistent design system across all screens

Reusable widgets:

CustomAppBar

CustomTextField

PrimaryButton

SectionHeader

CustomDrawer

Everything is intentionally kept minimal and clean.

✅ 2. Onboarding Flow

The app displays a short, simple, three-page onboarding experience on first launch:

Smooth PageView animations

Skip → jumps to last page

Next → continues pages

Done → Saves onboarding preference & navigates to app

The user never sees onboarding again after first use.

✅ 3. Task Lists

Create new task lists

Rename lists

Delete lists with confirmation

Clean and minimal list tiles

Navigation to task page using simple routing

Riverpod ensures reactive updates

✅ 4. Tasks & Editing Flow

For each list, users can manage tasks with:

Title (required)

Description

Due date

Priority (Low/Med/High)

Task status: todo ✅ or done ✅

Long press for edit/delete

Smooth UI updates using Riverpod

Notion-style clean task tiles

✅ 5. Filters & Sorting

Inside the Tasks screen:

Filter by: All, Todo, Done

Sort tasks by due date:

Ascending ↑

Descending ↓

Filters are live-reactive and instantly update the UI

Sorting & filtering combined produce correct results

✅ 6. Global Search

Search tasks across the entire app by:

Title

Tags (optional extra)

Instant search results

Clean search results UI with list reference

✅ 7. Offline Storage with sqflite

All lists and tasks are stored locally

Uses sqflite for persistent offline storage

Supports database schema versioning

Includes at least one migration (priority column)

Uses in-memory database during tests

✅ 8. State Management with Riverpod

The app follows a clean, layered architecture:

UI → State (Riverpod) → Repository → DAO → sqflite database


Riverpod providers handle:

Lists

Tasks

Filters

Sorting

Search queries

Theme mode

No widget ever talks directly to the database.

✅ 9. Light & Dark Mode Toggle

Inside the custom drawer:

Toggle between Light Mode ⬜ and Dark Mode ⬛

Saves preference in SharedPreferences

Applies instantly across the whole app

Matches Notion’s clean contrast ratios

✅ 10. Testing

Includes 5 clean tests:

Repository test

State update test

Widget tap & toggle test

Golden test

Form validation test

Follows Credes Task Assessment requirements.

🎯 Nice-to-Have Features Implemented

Based on the Candidate Task PDF:

Minimal UI with animations

Tag support (optional depending on your branch)

"Due soon" section (optional)

Fully modular reusable components

Dark / Light theme persistence

Smooth transitions for onboarding, tasks, drawers

Clean, readable comment style for humans

🛠️ Tech Stack

Flutter (UI)

Riverpod (state management)

sqflite (database)

SharedPreferences (theme & onboarding persistence)

Google Fonts (Poppins across the app)

Smooth Page Indicator (onboarding flow)

📂 Project Structure (Simplified)
lib/
 ├─ main.dart
 ├─ database.dart
 ├─ models.dart
 ├─ widgets/
 │    ├─ custom_appbar.dart
 │    ├─ custom_textfield.dart
 │    ├─ primary_button.dart
 │    ├─ section_header.dart
 │    └─ custom_drawer.dart
 ├─ features/
 │    ├─ lists_screen.dart
 │    ├─ tasks_screen.dart
 │    ├─ task_editor.dart
 │    └─ search_screen.dart
 ├─ onboarding/
 │    ├─ onboarding_screen.dart
 │    ├─ screen_1.dart
 │    ├─ screen_2.dart
 │    └─ screen_3.dart
 └─ app_providers.dart


Simple, easy to understand, easy to explore.

🧑‍💻 About the Creator — Adil

Hi! I’m Adil, a Flutter developer who enjoys creating clean, modern, minimalist interfaces that feel natural to use.

This project is part of my journey toward improving:

Mobile app UI/UX

State management patterns

Local database implementation

Clean architecture

Reusable widget systems

I enjoy building apps that feel professional but remain simple under the hood — just like this one.

If you're viewing this on GitHub, feel free to check out more of my work or reach out!

✅ Setup Instructions

Clone the repo:

git clone <your-repo-url>
cd task_management_app


Install dependencies:

flutter pub get


Run the app:

flutter run


Run tests:

flutter test

✅ Conclusion

This app is a polished, modern, Notion-inspired task manager designed with clean architecture, offline capability, and a calm minimalist UI. It includes every feature listed in the Credes Candidate Task, plus thoughtful enhancements.