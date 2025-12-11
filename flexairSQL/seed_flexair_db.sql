
-- FLEXAIR SAMPLE DATA SEED

BEGIN;

-- 1) Clear existing data and reset sequences
TRUNCATE TABLE
    public.bookings,
    public.passengers,
    public.flights,
    public.airlines,
    public.airports
RESTART IDENTITY CASCADE;

-- =========================================================
-- 2) Seed AIRLINES
-- =========================================================
INSERT INTO public.airlines (airline_code, airline_name, country)
VALUES
  ('FX', 'FlexAir',          'Cyprus'),
  ('TK', 'Turkish Airlines', 'Turkey'),
  ('BA', 'British Airways',  'United Kingdom'),
  ('EK', 'Emirates',         'United Arab Emirates'),
  ('IR', 'Iran Air',         'Iran'),
  ('CG', 'Congo Airways',    'Congo');

-- =========================================================
-- 3) Seed AIRPORTS
-- =========================================================
INSERT INTO public.airports (airport_code, airport_name, city, country)
VALUES
  ('ECN', 'Ercan International Airport',        'Nicosia',  'Cyprus'),
  ('IST', 'Istanbul Airport',                  'Istanbul', 'Turkey'),
  ('LHR', 'Heathrow Airport',                  'London',   'United Kingdom'),
  ('DXB', 'Dubai International Airport',       'Dubai',    'United Arab Emirates'),
  ('IKA', 'Imam Khomeini International Airport','Tehran',  'Iran'),
  ('FIH', 'N''Djili International Airport',    'Kinshasa', 'Congo');

-- =========================================================
-- 4) Seed FLIGHTS
--    We create 9 flights for dashboard / views / bookings.
-- =========================================================
INSERT INTO public.flights (
    airline_id,
    flight_number,
    departure_airport_id,
    arrival_airport_id,
    departure_time,
    arrival_time,
    price,
    available_seats,
    status
)
VALUES
-- FX100: ECN -> IST (FlexAir)
(
  (SELECT airline_id FROM public.airlines WHERE airline_code = 'FX'),
  'FX100',
  (SELECT airport_id FROM public.airports WHERE airport_code = 'ECN'),
  (SELECT airport_id FROM public.airports WHERE airport_code = 'IST'),
  '2025-12-20 08:00:00+00',
  '2025-12-20 09:30:00+00',
  150.00,
  100,
  'scheduled'
),
-- FX200: ECN -> LHR (FlexAir)
(
  (SELECT airline_id FROM public.airlines WHERE airline_code = 'FX'),
  'FX200',
  (SELECT airport_id FROM public.airports WHERE airport_code = 'ECN'),
  (SELECT airport_id FROM public.airports WHERE airport_code = 'LHR'),
  '2025-12-20 12:00:00+00',
  '2025-12-20 15:00:00+00',
  210.00,
  120,
  'scheduled'
),
-- FX300: ECN -> DXB (FlexAir)
(
  (SELECT airline_id FROM public.airlines WHERE airline_code = 'FX'),
  'FX300',
  (SELECT airport_id FROM public.airports WHERE airport_code = 'ECN'),
  (SELECT airport_id FROM public.airports WHERE airport_code = 'DXB'),
  '2025-12-21 07:30:00+00',
  '2025-12-21 11:00:00+00',
  300.00,
  90,
  'scheduled'
),
-- TK400: IST -> LHR (Turkish)
(
  (SELECT airline_id FROM public.airlines WHERE airline_code = 'TK'),
  'TK400',
  (SELECT airport_id FROM public.airports WHERE airport_code = 'IST'),
  (SELECT airport_id FROM public.airports WHERE airport_code = 'LHR'),
  '2025-12-22 09:00:00+00',
  '2025-12-22 11:30:00+00',
  180.00,
  140,
  'scheduled'
),
-- IR500: IKA -> ECN (Iran Air)
(
  (SELECT airline_id FROM public.airlines WHERE airline_code = 'IR'),
  'IR500',
  (SELECT airport_id FROM public.airports WHERE airport_code = 'IKA'),
  (SELECT airport_id FROM public.airports WHERE airport_code = 'ECN'),
  '2025-12-23 06:30:00+00',
  '2025-12-23 08:30:00+00',
  240.00,
  100,
  'scheduled'
),
-- CG600: FIH -> ECN (Congo Airways)
(
  (SELECT airline_id FROM public.airlines WHERE airline_code = 'CG'),
  'CG600',
  (SELECT airport_id FROM public.airports WHERE airport_code = 'FIH'),
  (SELECT airport_id FROM public.airports WHERE airport_code = 'ECN'),
  '2025-12-24 10:00:00+00',
  '2025-12-24 14:00:00+00',
  260.00,
  110,
  'scheduled'
),
-- BA700: LHR -> DXB (British Airways)
(
  (SELECT airline_id FROM public.airlines WHERE airline_code = 'BA'),
  'BA700',
  (SELECT airport_id FROM public.airports WHERE airport_code = 'LHR'),
  (SELECT airport_id FROM public.airports WHERE airport_code = 'DXB'),
  '2025-12-25 13:00:00+00',
  '2025-12-25 21:00:00+00',
  220.00,
  130,
  'scheduled'
),
-- EK800: DXB -> ECN (Emirates)
(
  (SELECT airline_id FROM public.airlines WHERE airline_code = 'EK'),
  'EK800',
  (SELECT airport_id FROM public.airports WHERE airport_code = 'DXB'),
  (SELECT airport_id FROM public.airports WHERE airport_code = 'ECN'),
  '2025-12-26 09:30:00+00',
  '2025-12-26 12:00:00+00',
  175.00,
  95,
  'scheduled'
),
-- FX900: ECN -> FIH (FlexAir)
(
  (SELECT airline_id FROM public.airlines WHERE airline_code = 'FX'),
  'FX900',
  (SELECT airport_id FROM public.airports WHERE airport_code = 'ECN'),
  (SELECT airport_id FROM public.airports WHERE airport_code = 'FIH'),
  '2025-12-27 07:45:00+00',
  '2025-12-27 12:15:00+00',
  260.00,
  80,
  'scheduled'
);

-- =========================================================
-- 5) Seed PASSENGERS
--    user_id values come from our existing profiles:
--      57ea0851-... = admin
--      abd375f7-... = customer
-- =========================================================
INSERT INTO public.passengers (
    first_name,
    last_name,
    date_of_birth,
    gender,
    nationality,
    user_id
)
VALUES
  -- 1
  ('Mike',   'Moralez',        '1990-03-15', 'Male',   'UK',
   '57ea0851-4366-4688-98c5-910e24c4c1dc'),
  -- 2
  ('Alice',  'Wise',           '2000-09-05', 'Female', 'US',
   '57ea0851-4366-4688-98c5-910e24c4c1dc'),
  -- 3
  ('Will',   'Smith',          '1980-01-12', 'Male',   'EU',
   '57ea0851-4366-4688-98c5-910e24c4c1dc'),
  -- 4
  ('Brain',  'Diaz',           '2002-11-12', 'Male',   'Germany',
   '57ea0851-4366-4688-98c5-910e24c4c1dc'),
  -- 5  (Mahan)
  ('Mahan',  'Mizani',         '2001-09-20', 'Female', 'IR',
   'abd375f7-1511-4ec6-8bd3-11c80010a630'),
  -- 6  (Marcel)
  ('Marcel', 'Tshidibi-Ngoyi', '2000-01-01', 'Male',   'CG',
   'abd375f7-1511-4ec6-8bd3-11c80010a630'),
  -- 7
  ('Sophia', 'Keller',         '1995-04-10', 'Female', 'DE',
   'abd375f7-1511-4ec6-8bd3-11c80010a630'),
  -- 8
  ('Daniel', 'Rossi',          '1988-07-22', 'Male',   'IT',
   'abd375f7-1511-4ec6-8bd3-11c80010a630'),
  -- 9
  ('Emma',   'Johnson',        '1999-11-03', 'Female', 'US',
   'abd375f7-1511-4ec6-8bd3-11c80010a630'),
  -- 10
  ('Lucas',  'Anderson',       '1993-03-14', 'Male',   'CA',
   'abd375f7-1511-4ec6-8bd3-11c80010a630'),
  -- 11
  ('Hana',   'Takimoto',       '2002-06-18', 'Female', 'JP',
   'abd375f7-1511-4ec6-8bd3-11c80010a630'),
  -- 12
  ('Yusuf',  'Al-Masri',       '1985-08-09', 'Male',   'AE',
   'abd375f7-1511-4ec6-8bd3-11c80010a630'),
  -- 13
  ('Carla',  'Fernandez',      '1991-01-25', 'Female', 'ES',
   'abd375f7-1511-4ec6-8bd3-11c80010a630'),
  -- 14
  ('Victor', 'Novak',          '1987-10-11', 'Male',   'PL',
   'abd375f7-1511-4ec6-8bd3-11c80010a630');

-- =========================================================
-- 6) Seed BOOKINGS
--    9 bookings passenger to show in admin dashboard
--    We reference flights by flight_number to keep it stable.
-- =========================================================
INSERT INTO public.bookings (
    flight_id,
    passenger_id,
    booking_reference,
    booking_date,
    total_price,
    status,
    user_id
)
VALUES
-- Alice on FX100 (admin user)
(
  (SELECT flight_id FROM public.flights WHERE flight_number = 'FX100'),
  2,
  'BK-A02',
  '2025-12-11 13:00:21+00',
  150.00,
  'confirmed',
  '57ea0851-4366-4688-98c5-910e24c4c1dc'
),
-- Will on FX200
(
  (SELECT flight_id FROM public.flights WHERE flight_number = 'FX200'),
  3,
  'BK-W03',
  '2025-12-11 13:00:21+00',
  210.00,
  'confirmed',
  '57ea0851-4366-4688-98c5-910e24c4c1dc'
),
-- Brain on FX300
(
  (SELECT flight_id FROM public.flights WHERE flight_number = 'FX300'),
  4,
  'BK-B04',
  '2025-12-11 13:00:21+00',
  300.00,
  'confirmed',
  '57ea0851-4366-4688-98c5-910e24c4c1dc'
),
-- Mahan on IR500 (Iran Air)
(
  (SELECT flight_id FROM public.flights WHERE flight_number = 'IR500'),
  5,
  'BK-MH05',
  '2025-12-11 13:00:21+00',
  180.00,
  'confirmed',
  'abd375f7-1511-4ec6-8bd3-11c80010a630'
),
-- Marcel on CG600 (Congo Airways)
(
  (SELECT flight_id FROM public.flights WHERE flight_number = 'CG600'),
  6,
  'BK-MC06',
  '2025-12-11 13:00:21+00',
  240.00,
  'confirmed',
  'abd375f7-1511-4ec6-8bd3-11c80010a630'
),
-- Sophia on TK400
(
  (SELECT flight_id FROM public.flights WHERE flight_number = 'TK400'),
  7,
  'BK-S07',
  '2025-12-11 13:00:21+00',
  130.00,
  'confirmed',
  'abd375f7-1511-4ec6-8bd3-11c80010a630'
),
-- Emma on BA700
(
  (SELECT flight_id FROM public.flights WHERE flight_number = 'BA700'),
  9,
  'BK-E09',
  '2025-12-11 13:00:21+00',
  210.00,
  'confirmed',
  'abd375f7-1511-4ec6-8bd3-11c80010a630'
),
-- Hana on EK800
(
  (SELECT flight_id FROM public.flights WHERE flight_number = 'EK800'),
  11,
  'BK-H11',
  '2025-12-11 13:00:21+00',
  175.00,
  'confirmed',
  'abd375f7-1511-4ec6-8bd3-11c80010a630'
),
-- Carla on FX900
(
  (SELECT flight_id FROM public.flights WHERE flight_number = 'FX900'),
  13,
  'BK-C13',
  '2025-12-11 13:00:21+00',
  260.00,
  'confirmed',
  'abd375f7-1511-4ec6-8bd3-11c80010a630'
);

COMMIT;
