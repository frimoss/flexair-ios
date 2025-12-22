# ✈️ Flexair - Flight Booking System

**Flight Booking & Management System** powered by Supabase (Backend as a Service) and PostgreSQL, including an iOS Mobile Application for Customers and a Web-based Dashboard for Admins.

![screenshots](app-shots/Slide-1.png)


## 🎥 FlexAir Demo Video
https://private-user-images.githubusercontent.com/190701880/529241300-1b0cd23a-e439-4170-82af-67c10bc289c1.mp4?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjY0MTE2NzksIm5iZiI6MTc2NjQxMTM3OSwicGF0aCI6Ii8xOTA3MDE4ODAvNTI5MjQxMzAwLTFiMGNkMjNhLWU0MzktNDE3MC04MmFmLTY3YzEwYmMyODljMS5tcDQ_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUxMjIyJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MTIyMlQxMzQ5MzlaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0yNDQxNGU0MjI5NzFiYTM5ZDdhZDRjYmFiNjk4OTU4Y2Q1YjcyZDc1NzM0NzMwZmE2N2M2ZDI5ZjZhMjJkZjRmJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.Ol6z1wwq_cgAGCWv7eAENvB7Cwi_8TS2dPhzPt3H8Gc

## 📋 Project Information

- **Course**: CMPE344 - Database Management Systems and Programming II
- **Institution**: Cyprus International University
- **Instructor**: Prof Dr Melike Şah Direkoğlu
- **Due Date**: December 21, 2025

## 👥 Team Members

- Mahan Mizani
- Nikolai Piatnov
- Maksim Kalmykov
- Marcel Tshidibi Ngoyi

## 🎯 Features

- Flight search by route and date
- Passenger management
- Booking creation and cancellation
- Booking history
- Management analytics queries

## 🗄️ Database Design

### Tables (7)

1. **auth.users** - User authentication
2. **profiles** - User profiles with roles
3. **airlines** - Airline information
4. **airports** - Airport details
5. **flights** - Flight schedules and pricing
6. **passengers** - Passenger information
7. **bookings** - Booking records

## 🛠️ Technology Stack

- **Database:** PostgreSQL, SQL and PL/pgSQL
- **Backend as a Service (BaaS):** Supabase (Auth, Realtime, PostgREST, Functions, Storage)
- **Authentication:** Supabase Auth
- **Mobile Application:** iOS App (Swift, SwiftUI, MVVM)
- **Admin Interface:** Web-based Dashboard (Python, Flask, Render Cloud)
- **Version Control:** Git


## 🚀 Database Features

### Functions (7)
- `search_flights()` - Search flights
- `add_passenger()` - Add passenger
- `get_passengers()` - Get user passengers
- `update_passenger()` - Update passenger
- `create_booking()` - Create booking
- `get_user_bookings()` - Get bookings
- `cancel_booking()` - Cancel booking

### Triggers (3)
- Auto-update timestamps
- Prevent overbooking
- Restore seats on cancellation

### Views (3)
- Available flights
- User bookings
- Flight statistics

### Management Queries (7)
1. Revenue by airline
2. Popular routes
3. Customer spending
4. Flight occupancy
5. Monthly revenue trends
6. Available seats (subquery)
7. Passenger demographics


## 🔧 Setup

### Database Setup
1. Create Supabase project at https://supabase.com
2. Run scripts in SQL Editor:
   - `schema.sql`
   - `seed-data.sql`
   - `functions.sql`
   - `triggers.sql`
   - `views.sql`

### iOS Application Setup

1. Clone the repository
2. Open `flexair` project in XCode 16 or later
3. Add [Supabase-Swift](https://github.com/supabase/supabase-swift) dependencies in the Project - Packages
4. Copy `Secrets.template.xcconfig` to `Secrets.xcconfig`
5. Add your API keys to `Secrets.xcconfig`
6. Build and run!

#### Required API Keys:
- **Supabase URL**: Open your Supabase project/Project Settings/Data API - Project URL
- **Supabase Key**: Open your Supabase project/Project Settings/API Keys - Publishable key


## 📝 Project Requirements Met

- ✅ 6+ tables with proper Relationships
- ✅ User Authentication and Role-based Access
- ✅ Foreign keys and Constraints
- ✅ 7 PL/SQL Functions
- ✅ 3 Database Triggers
- ✅ 3 Database Views
- ✅ 7 Management queries (JOIN, subquery, GROUP BY, etc.)
- ✅ Mobile Application for Customers
- ✅ Web-based Dashboard for Admins
- ✅ Backend as a Service (Supabase)
- ✅ Cloud deployment (Render)
- ✅ GitHub Repository
  

![screenshots](app-shots/Slide-2.png)

**Academic Project** - CMPE344 Database Management Systems, Cyprus International University (Fall 2025)
