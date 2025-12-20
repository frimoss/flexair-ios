


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."add_passenger"("p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_nationality" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    INSERT INTO passengers (
        user_id,
        first_name,
        last_name,
        date_of_birth,
        gender,
        nationality
    ) VALUES (
        p_user_id,
        p_first_name,
        p_last_name,
        p_date_of_birth,
        p_gender,
        p_nationality
    );
    
    -- No return value needed!
END;
$$;


ALTER FUNCTION "public"."add_passenger"("p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_nationality" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."add_passenger"("p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_passport_number" "text", "p_nationality" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$BEGIN
    INSERT INTO passengers (
        user_id,
        first_name,
        last_name,
        date_of_birth,
        gender,
        passport_number,
        nationality
    ) VALUES (
        p_user_id,
        p_first_name,
        p_last_name,
        p_date_of_birth,
        p_gender,
        p_passport_number,
        p_nationality
    );
    
    -- No return value needed!
END;$$;


ALTER FUNCTION "public"."add_passenger"("p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_passport_number" "text", "p_nationality" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cancel_booking"("p_booking_id" integer, "p_user_id" "uuid") RETURNS TABLE("booking_id" integer, "status" "text", "success" boolean)
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    v_flight_id INTEGER;
BEGIN
    -- Check if booking belongs to user
    IF NOT EXISTS (
        SELECT 1 FROM bookings 
        WHERE bookings.booking_id = p_booking_id 
        AND bookings.user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'Booking not found or unauthorized';
    END IF;
    
    -- Get flight_id before updating
    SELECT flight_id INTO v_flight_id
    FROM bookings
    WHERE bookings.booking_id = p_booking_id;
    
    -- Update booking status to cancelled
    UPDATE bookings
    SET status = 'cancelled'
    WHERE bookings.booking_id = p_booking_id
      AND bookings.user_id = p_user_id;
    
    -- Restore available seats
    UPDATE flights
    SET available_seats = available_seats + 1
    WHERE flight_id = v_flight_id;
    
    RETURN QUERY
    SELECT 
        p_booking_id,
        'cancelled'::TEXT,
        TRUE;
END;
$$;


ALTER FUNCTION "public"."cancel_booking"("p_booking_id" integer, "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_booking"("p_user_id" "uuid", "p_flight_id" integer, "p_passenger_id" integer) RETURNS TABLE("booking_id" integer, "booking_reference" "text", "flight_number" "text", "total_price" numeric, "status" "text")
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    v_booking_id INTEGER;
    v_booking_reference TEXT;
    v_flight_price DECIMAL(10, 2);
    v_flight_number TEXT;
    v_available_seats INTEGER;
BEGIN
    -- Check flight availability
    SELECT f.price, f.available_seats, f.flight_number
    INTO v_flight_price, v_available_seats, v_flight_number
    FROM flights f
    WHERE f.flight_id = p_flight_id;
    
    IF v_available_seats <= 0 THEN
        RAISE EXCEPTION 'No seats available for this flight';
    END IF;

    -- Generate unique 6-character booking reference PNR code: like "9Y3TQ2" (no confusing chars)
    v_booking_reference := (
        SELECT STRING_AGG(
            SUBSTR('ABCDEFGHJKLMNPQRSTUVWXZ23456789', FLOOR(RANDOM() * 32 + 1)::INT, 1),
            ''
        )
        FROM GENERATE_SERIES(1, 6)
    );
    
    
    -- Create booking
    INSERT INTO bookings (
        user_id,
        flight_id,
        passenger_id,
        booking_reference,
        total_price,
        status
    ) VALUES (
        p_user_id,
        p_flight_id,
        p_passenger_id,
        v_booking_reference,
        v_flight_price,
        'confirmed'
    )
    RETURNING bookings.booking_id INTO v_booking_id;
    
    -- Update available seats
    UPDATE flights
    SET available_seats = available_seats - 1
    WHERE flight_id = p_flight_id;
    
    RETURN QUERY
    SELECT 
        v_booking_id,
        v_booking_reference,
        v_flight_number,
        v_flight_price,
        'confirmed'::TEXT;
END;
$$;


ALTER FUNCTION "public"."create_booking"("p_user_id" "uuid", "p_flight_id" integer, "p_passenger_id" integer) OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."passengers" (
    "passenger_id" integer NOT NULL,
    "first_name" "text" NOT NULL,
    "last_name" "text" NOT NULL,
    "date_of_birth" "date" NOT NULL,
    "gender" "text",
    "nationality" "text",
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "user_id" "uuid" NOT NULL
);


ALTER TABLE "public"."passengers" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_passengers"("p_user_id" "uuid") RETURNS SETOF "public"."passengers"
    LANGUAGE "sql" STABLE
    AS $$
  SELECT p.* 
  FROM passengers p
  WHERE p.user_id = p_user_id
  ORDER BY p.created_at DESC;
$$;


ALTER FUNCTION "public"."get_passengers"("p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_bookings"("p_user_id" "uuid") RETURNS TABLE("booking_id" integer, "booking_reference" "text", "booking_date" timestamp with time zone, "status" "text", "total_price" numeric, "flight_id" integer, "flight_number" "text", "airline_name" "text", "departure_airport_code" "text", "departure_airport_name" "text", "departure_city" "text", "arrival_airport_code" "text", "arrival_airport_name" "text", "arrival_city" "text", "departure_time" timestamp with time zone, "arrival_time" timestamp with time zone, "passenger_id" integer, "passenger_first_name" "text", "passenger_last_name" "text", "passport_number" "text", "date_of_birth" "date")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.booking_id,
        b.booking_reference,
        b.booking_date,
        b.status,
        b.total_price,
        f.flight_id,
        f.flight_number,
        al.airline_name,
        dep.airport_code AS departure_airport_code,
        dep.airport_name AS departure_airport_name,
        dep.city AS departure_city,
        arr.airport_code AS arrival_airport_code,
        arr.airport_name AS arrival_airport_name,
        arr.city AS arrival_city,
        f.departure_time,
        f.arrival_time,
        p.passenger_id,
        p.first_name AS passenger_first_name,
        p.last_name AS passenger_last_name,
        p.passport_number,
        p.date_of_birth
    FROM bookings b
    INNER JOIN flights f ON b.flight_id = f.flight_id
    INNER JOIN airlines al ON f.airline_id = al.airline_id
    INNER JOIN airports dep ON f.departure_airport_id = dep.airport_id
    INNER JOIN airports arr ON f.arrival_airport_id = arr.airport_id
    INNER JOIN passengers p ON b.passenger_id = p.passenger_id
    WHERE b.user_id = p_user_id
    ORDER BY f.departure_time;
END;
$$;


ALTER FUNCTION "public"."get_user_bookings"("p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.profiles (user_id)
  VALUES (NEW.id);   -- NEW.id = auth.users.id

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."hello_world"() RETURNS "text"
    LANGUAGE "sql"
    AS $$
  select 'Hello world';
$$;


ALTER FUNCTION "public"."hello_world"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."prevent_overbooking"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  v_available_seats INTEGER;
BEGIN
  SELECT available_seats
  INTO v_available_seats
  FROM flights
  WHERE flight_id = NEW.flight_id;

  IF v_available_seats IS NULL THEN
    RAISE EXCEPTION 'Flight % not found', NEW.flight_id;
  END IF;

  IF v_available_seats <= 0 THEN
    RAISE EXCEPTION 'No seats available for flight %', NEW.flight_id;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."prevent_overbooking"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."restore_seat_on_cancellation"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  IF OLD.status <> 'cancelled' AND NEW.status = 'cancelled' THEN
    UPDATE flights
    SET available_seats = available_seats + 1
    WHERE flight_id = NEW.flight_id;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."restore_seat_on_cancellation"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."search_flights"("p_departure_airport_code" "text", "p_arrival_airport_code" "text", "p_departure_date" "date") RETURNS TABLE("flight_id" integer, "flight_number" "text", "airline_name" "text", "airline_code" "text", "departure_airport_code" "text", "departure_airport_name" "text", "departure_city" "text", "arrival_airport_code" "text", "arrival_airport_name" "text", "arrival_city" "text", "departure_time" timestamp with time zone, "arrival_time" timestamp with time zone, "price" numeric, "available_seats" integer, "status" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.flight_id,
        f.flight_number,
        al.airline_name,
        al.airline_code,
        dep.airport_code AS departure_airport_code,
        dep.airport_name AS departure_airport_name,
        dep.city AS departure_city,
        arr.airport_code AS arrival_airport_code,
        arr.airport_name AS arrival_airport_name,
        arr.city AS arrival_city,
        f.departure_time,
        f.arrival_time,
        f.price,
        f.available_seats,
        f.status
    FROM flights f
    INNER JOIN airlines al ON f.airline_id = al.airline_id
    INNER JOIN airports dep ON f.departure_airport_id = dep.airport_id
    INNER JOIN airports arr ON f.arrival_airport_id = arr.airport_id
    WHERE dep.airport_code = p_departure_airport_code
      AND arr.airport_code = p_arrival_airport_code
      AND DATE(f.departure_time) = p_departure_date
      AND f.status = 'scheduled'
      AND f.available_seats > 0
    ORDER BY f.departure_time;
END;
$$;


ALTER FUNCTION "public"."search_flights"("p_departure_airport_code" "text", "p_arrival_airport_code" "text", "p_departure_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_profiles_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  NEW.updated_at := (now() AT TIME ZONE 'utc');
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."set_profiles_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_passenger"("p_passenger_id" integer, "p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_nationality" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- Security check: Make sure passenger belongs to this user
    IF NOT EXISTS (
        SELECT 1 FROM passengers 
        WHERE passenger_id = p_passenger_id 
        AND user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'Passenger not found or unauthorized';
    END IF;
    
    -- Update the passenger
    UPDATE passengers
    SET 
        first_name = p_first_name,
        last_name = p_last_name,
        date_of_birth = p_date_of_birth,
        gender = p_gender,
        nationality = p_nationality
    WHERE passenger_id = p_passenger_id
      AND user_id = p_user_id;
    
    -- Done! No return value needed.
END;
$$;


ALTER FUNCTION "public"."update_passenger"("p_passenger_id" integer, "p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_nationality" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_passenger"("p_passenger_id" integer, "p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_passport_number" "text", "p_nationality" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- Security check: Make sure passenger belongs to this user
    IF NOT EXISTS (
        SELECT 1 FROM passengers 
        WHERE passenger_id = p_passenger_id 
        AND user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'Passenger not found or unauthorized';
    END IF;
    
    -- Update the passenger
    UPDATE passengers
    SET 
        first_name = p_first_name,
        last_name = p_last_name,
        date_of_birth = p_date_of_birth,
        gender = p_gender,
        passport_number = p_passport_number,
        nationality = p_nationality
    WHERE passenger_id = p_passenger_id
      AND user_id = p_user_id;
    
    -- Done! No return value needed.
END;
$$;


ALTER FUNCTION "public"."update_passenger"("p_passenger_id" integer, "p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_passport_number" "text", "p_nationality" "text") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."airlines" (
    "airline_id" integer NOT NULL,
    "airline_code" "text" NOT NULL,
    "airline_name" "text" NOT NULL,
    "country" "text"
);


ALTER TABLE "public"."airlines" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."airlines_airline_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."airlines_airline_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."airlines_airline_id_seq" OWNED BY "public"."airlines"."airline_id";



CREATE TABLE IF NOT EXISTS "public"."airports" (
    "airport_id" integer NOT NULL,
    "airport_code" "text" NOT NULL,
    "airport_name" "text" NOT NULL,
    "city" "text" NOT NULL,
    "country" "text" NOT NULL
);


ALTER TABLE "public"."airports" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."airports_airport_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."airports_airport_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."airports_airport_id_seq" OWNED BY "public"."airports"."airport_id";



CREATE TABLE IF NOT EXISTS "public"."bookings" (
    "booking_id" integer NOT NULL,
    "flight_id" integer NOT NULL,
    "passenger_id" integer NOT NULL,
    "booking_reference" "text" NOT NULL,
    "booking_date" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "total_price" numeric(10,2) NOT NULL,
    "status" "text" DEFAULT 'confirmed'::"text" NOT NULL,
    "user_id" "uuid" NOT NULL
);


ALTER TABLE "public"."bookings" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."bookings_booking_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."bookings_booking_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."bookings_booking_id_seq" OWNED BY "public"."bookings"."booking_id";



CREATE TABLE IF NOT EXISTS "public"."flights" (
    "flight_id" integer NOT NULL,
    "airline_id" integer NOT NULL,
    "flight_number" "text" NOT NULL,
    "departure_airport_id" integer NOT NULL,
    "arrival_airport_id" integer NOT NULL,
    "departure_time" timestamp with time zone NOT NULL,
    "arrival_time" timestamp with time zone NOT NULL,
    "price" numeric(10,2) NOT NULL,
    "available_seats" integer NOT NULL,
    "status" "text" DEFAULT 'scheduled'::"text"
);


ALTER TABLE "public"."flights" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."flights_flight_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."flights_flight_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."flights_flight_id_seq" OWNED BY "public"."flights"."flight_id";



CREATE SEQUENCE IF NOT EXISTS "public"."passengers_passenger_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."passengers_passenger_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."passengers_passenger_id_seq" OWNED BY "public"."passengers"."passenger_id";



CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "role" "text" DEFAULT 'customer'::"text" NOT NULL
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_available_flights" WITH ("security_invoker"='true') AS
 SELECT "f"."flight_id",
    "f"."flight_number",
    "al"."airline_name",
    "al"."airline_code",
    "dep"."airport_code" AS "departure_airport_code",
    "dep"."airport_name" AS "departure_airport_name",
    "dep"."city" AS "departure_city",
    "arr"."airport_code" AS "arrival_airport_code",
    "arr"."airport_name" AS "arrival_airport_name",
    "arr"."city" AS "arrival_city",
    "f"."departure_time",
    "f"."arrival_time",
    "f"."price",
    "f"."available_seats",
    "f"."status"
   FROM ((("public"."flights" "f"
     JOIN "public"."airlines" "al" ON (("f"."airline_id" = "al"."airline_id")))
     JOIN "public"."airports" "dep" ON (("f"."departure_airport_id" = "dep"."airport_id")))
     JOIN "public"."airports" "arr" ON (("f"."arrival_airport_id" = "arr"."airport_id")))
  WHERE (("f"."status" = 'scheduled'::"text") AND ("f"."available_seats" > 0));


ALTER VIEW "public"."v_available_flights" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_current_booked_passengers" WITH ("security_invoker"='true') AS
 SELECT "b"."booking_id",
    "b"."booking_reference",
    "b"."status",
    "b"."booking_date",
    "b"."user_id",
    "f"."flight_id",
    "f"."flight_number",
    "f"."departure_time",
    "f"."arrival_time",
    "dep"."airport_code" AS "departure_airport_code",
    "dep"."airport_name" AS "departure_airport_name",
    "arr"."airport_code" AS "arrival_airport_code",
    "arr"."airport_name" AS "arrival_airport_name",
    "p"."passenger_id",
    "p"."first_name",
    "p"."last_name",
    "p"."nationality",
    "p"."gender",
    "p"."date_of_birth",
    "p"."created_at"
   FROM (((("public"."bookings" "b"
     JOIN "public"."flights" "f" ON (("b"."flight_id" = "f"."flight_id")))
     JOIN "public"."passengers" "p" ON (("b"."passenger_id" = "p"."passenger_id")))
     JOIN "public"."airports" "dep" ON (("f"."departure_airport_id" = "dep"."airport_id")))
     JOIN "public"."airports" "arr" ON (("f"."arrival_airport_id" = "arr"."airport_id")))
  WHERE (("b"."status" = 'confirmed'::"text") AND ("f"."departure_time" >= "now"()))
  ORDER BY "f"."departure_time", "b"."booking_id";


ALTER VIEW "public"."v_current_booked_passengers" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_flight_statistics" WITH ("security_invoker"='true') AS
 SELECT "f"."flight_id",
    "f"."flight_number",
    "al"."airline_name",
    "al"."airline_code",
    "dep"."airport_code" AS "departure_airport_code",
    "arr"."airport_code" AS "arrival_airport_code",
    "f"."departure_time",
    "f"."arrival_time",
    "f"."price",
    "f"."available_seats",
    COALESCE("count"("b"."booking_id") FILTER (WHERE ("b"."status" = 'confirmed'::"text")), (0)::bigint) AS "confirmed_bookings",
    ("f"."available_seats" + COALESCE("count"("b"."booking_id") FILTER (WHERE ("b"."status" = 'confirmed'::"text")), (0)::bigint)) AS "inferred_capacity",
        CASE
            WHEN (("f"."available_seats" + COALESCE("count"("b"."booking_id") FILTER (WHERE ("b"."status" = 'confirmed'::"text")), (0)::bigint)) > 0) THEN "round"((((COALESCE("count"("b"."booking_id") FILTER (WHERE ("b"."status" = 'confirmed'::"text")), (0)::bigint))::numeric / (("f"."available_seats" + COALESCE("count"("b"."booking_id") FILTER (WHERE ("b"."status" = 'confirmed'::"text")), (0)::bigint)))::numeric) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS "load_factor_percent"
   FROM (((("public"."flights" "f"
     JOIN "public"."airlines" "al" ON (("f"."airline_id" = "al"."airline_id")))
     JOIN "public"."airports" "dep" ON (("f"."departure_airport_id" = "dep"."airport_id")))
     JOIN "public"."airports" "arr" ON (("f"."arrival_airport_id" = "arr"."airport_id")))
     LEFT JOIN "public"."bookings" "b" ON (("b"."flight_id" = "f"."flight_id")))
  GROUP BY "f"."flight_id", "f"."flight_number", "al"."airline_name", "al"."airline_code", "dep"."airport_code", "arr"."airport_code", "f"."departure_time", "f"."arrival_time", "f"."price", "f"."available_seats";


ALTER VIEW "public"."v_flight_statistics" OWNER TO "postgres";


ALTER TABLE ONLY "public"."airlines" ALTER COLUMN "airline_id" SET DEFAULT "nextval"('"public"."airlines_airline_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."airports" ALTER COLUMN "airport_id" SET DEFAULT "nextval"('"public"."airports_airport_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."bookings" ALTER COLUMN "booking_id" SET DEFAULT "nextval"('"public"."bookings_booking_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."flights" ALTER COLUMN "flight_id" SET DEFAULT "nextval"('"public"."flights_flight_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."passengers" ALTER COLUMN "passenger_id" SET DEFAULT "nextval"('"public"."passengers_passenger_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."airlines"
    ADD CONSTRAINT "airlines_airline_code_key" UNIQUE ("airline_code");



ALTER TABLE ONLY "public"."airlines"
    ADD CONSTRAINT "airlines_pkey" PRIMARY KEY ("airline_id");



ALTER TABLE ONLY "public"."airports"
    ADD CONSTRAINT "airports_airport_code_key" UNIQUE ("airport_code");



ALTER TABLE ONLY "public"."airports"
    ADD CONSTRAINT "airports_pkey" PRIMARY KEY ("airport_id");



ALTER TABLE ONLY "public"."bookings"
    ADD CONSTRAINT "bookings_booking_reference_key" UNIQUE ("booking_reference");



ALTER TABLE ONLY "public"."bookings"
    ADD CONSTRAINT "bookings_pkey" PRIMARY KEY ("booking_id");



ALTER TABLE ONLY "public"."flights"
    ADD CONSTRAINT "flights_pkey" PRIMARY KEY ("flight_id");



ALTER TABLE ONLY "public"."passengers"
    ADD CONSTRAINT "passengers_pkey" PRIMARY KEY ("passenger_id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("user_id");



CREATE OR REPLACE TRIGGER "trg_prevent_overbooking" BEFORE INSERT ON "public"."bookings" FOR EACH ROW EXECUTE FUNCTION "public"."prevent_overbooking"();



CREATE OR REPLACE TRIGGER "trg_profiles_set_updated_at" BEFORE UPDATE ON "public"."profiles" FOR EACH ROW EXECUTE FUNCTION "public"."set_profiles_updated_at"();



CREATE OR REPLACE TRIGGER "trg_restore_seat_on_cancellation" AFTER UPDATE ON "public"."bookings" FOR EACH ROW EXECUTE FUNCTION "public"."restore_seat_on_cancellation"();



ALTER TABLE ONLY "public"."bookings"
    ADD CONSTRAINT "bookings_flight_id_fkey" FOREIGN KEY ("flight_id") REFERENCES "public"."flights"("flight_id");



ALTER TABLE ONLY "public"."bookings"
    ADD CONSTRAINT "bookings_passenger_id_fkey" FOREIGN KEY ("passenger_id") REFERENCES "public"."passengers"("passenger_id");



ALTER TABLE ONLY "public"."bookings"
    ADD CONSTRAINT "bookings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("user_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."flights"
    ADD CONSTRAINT "flights_airline_id_fkey" FOREIGN KEY ("airline_id") REFERENCES "public"."airlines"("airline_id");



ALTER TABLE ONLY "public"."flights"
    ADD CONSTRAINT "flights_arrival_airport_id_fkey" FOREIGN KEY ("arrival_airport_id") REFERENCES "public"."airports"("airport_id");



ALTER TABLE ONLY "public"."flights"
    ADD CONSTRAINT "flights_departure_airport_id_fkey" FOREIGN KEY ("departure_airport_id") REFERENCES "public"."airports"("airport_id");



ALTER TABLE ONLY "public"."passengers"
    ADD CONSTRAINT "passengers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("user_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



CREATE POLICY "Admin manage airlines" ON "public"."airlines" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."profiles" "pr"
  WHERE (("pr"."user_id" = "auth"."uid"()) AND ("pr"."role" = 'admin'::"text"))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."profiles" "pr"
  WHERE (("pr"."user_id" = "auth"."uid"()) AND ("pr"."role" = 'admin'::"text")))));



CREATE POLICY "Admin manage airports" ON "public"."airports" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."profiles" "pr"
  WHERE (("pr"."user_id" = "auth"."uid"()) AND ("pr"."role" = 'admin'::"text"))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."profiles" "pr"
  WHERE (("pr"."user_id" = "auth"."uid"()) AND ("pr"."role" = 'admin'::"text")))));



CREATE POLICY "Customer delete own bookings" ON "public"."bookings" FOR DELETE TO "authenticated" USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Customer delete own passengers" ON "public"."passengers" FOR DELETE TO "authenticated" USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Customer insert own bookings" ON "public"."bookings" FOR INSERT TO "authenticated" WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Customer insert own passengers" ON "public"."passengers" FOR INSERT TO "authenticated" WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Customer read own bookings" ON "public"."bookings" FOR SELECT TO "authenticated" USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Customer read own passengers" ON "public"."passengers" FOR SELECT TO "authenticated" USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Customer update own bookings" ON "public"."bookings" FOR UPDATE TO "authenticated" USING (("user_id" = "auth"."uid"())) WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Customer update own passengers" ON "public"."passengers" FOR UPDATE TO "authenticated" USING (("user_id" = "auth"."uid"())) WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Enable users to view their own data only" ON "public"."profiles" FOR SELECT TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));



CREATE POLICY "Public read airlines" ON "public"."airlines" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Public read airports" ON "public"."airports" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Public read flights" ON "public"."flights" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Staff manage all bookings" ON "public"."bookings" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."profiles" "pr"
  WHERE (("pr"."user_id" = "auth"."uid"()) AND ("pr"."role" = ANY (ARRAY['admin'::"text", 'employee'::"text"])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."profiles" "pr"
  WHERE (("pr"."user_id" = "auth"."uid"()) AND ("pr"."role" = ANY (ARRAY['admin'::"text", 'employee'::"text"]))))));



CREATE POLICY "Staff manage all passengers" ON "public"."passengers" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."profiles" "pr"
  WHERE (("pr"."user_id" = "auth"."uid"()) AND ("pr"."role" = ANY (ARRAY['admin'::"text", 'employee'::"text"])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."profiles" "pr"
  WHERE (("pr"."user_id" = "auth"."uid"()) AND ("pr"."role" = ANY (ARRAY['admin'::"text", 'employee'::"text"]))))));



CREATE POLICY "Staff manage flights" ON "public"."flights" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."profiles" "pr"
  WHERE (("pr"."user_id" = "auth"."uid"()) AND ("pr"."role" = ANY (ARRAY['admin'::"text", 'employee'::"text"])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."profiles" "pr"
  WHERE (("pr"."user_id" = "auth"."uid"()) AND ("pr"."role" = ANY (ARRAY['admin'::"text", 'employee'::"text"]))))));



CREATE POLICY "User read own profile" ON "public"."profiles" FOR SELECT TO "authenticated" USING (("user_id" = "auth"."uid"()));



CREATE POLICY "User update own profile" ON "public"."profiles" FOR UPDATE TO "authenticated" USING (("user_id" = "auth"."uid"())) WITH CHECK (("user_id" = "auth"."uid"()));



ALTER TABLE "public"."airlines" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."airports" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."bookings" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."flights" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."passengers" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

























































































































































GRANT ALL ON FUNCTION "public"."add_passenger"("p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_nationality" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."add_passenger"("p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_nationality" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_passenger"("p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_nationality" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."add_passenger"("p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_passport_number" "text", "p_nationality" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."add_passenger"("p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_passport_number" "text", "p_nationality" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_passenger"("p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_passport_number" "text", "p_nationality" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."cancel_booking"("p_booking_id" integer, "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."cancel_booking"("p_booking_id" integer, "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."cancel_booking"("p_booking_id" integer, "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_booking"("p_user_id" "uuid", "p_flight_id" integer, "p_passenger_id" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."create_booking"("p_user_id" "uuid", "p_flight_id" integer, "p_passenger_id" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_booking"("p_user_id" "uuid", "p_flight_id" integer, "p_passenger_id" integer) TO "service_role";



GRANT ALL ON TABLE "public"."passengers" TO "anon";
GRANT ALL ON TABLE "public"."passengers" TO "authenticated";
GRANT ALL ON TABLE "public"."passengers" TO "service_role";



GRANT ALL ON FUNCTION "public"."get_passengers"("p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_passengers"("p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_passengers"("p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_bookings"("p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_bookings"("p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_bookings"("p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."hello_world"() TO "anon";
GRANT ALL ON FUNCTION "public"."hello_world"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."hello_world"() TO "service_role";



GRANT ALL ON FUNCTION "public"."prevent_overbooking"() TO "anon";
GRANT ALL ON FUNCTION "public"."prevent_overbooking"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."prevent_overbooking"() TO "service_role";



GRANT ALL ON FUNCTION "public"."restore_seat_on_cancellation"() TO "anon";
GRANT ALL ON FUNCTION "public"."restore_seat_on_cancellation"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."restore_seat_on_cancellation"() TO "service_role";



GRANT ALL ON FUNCTION "public"."search_flights"("p_departure_airport_code" "text", "p_arrival_airport_code" "text", "p_departure_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."search_flights"("p_departure_airport_code" "text", "p_arrival_airport_code" "text", "p_departure_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."search_flights"("p_departure_airport_code" "text", "p_arrival_airport_code" "text", "p_departure_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."set_profiles_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_profiles_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_profiles_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_passenger"("p_passenger_id" integer, "p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_nationality" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."update_passenger"("p_passenger_id" integer, "p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_nationality" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_passenger"("p_passenger_id" integer, "p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_nationality" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_passenger"("p_passenger_id" integer, "p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_passport_number" "text", "p_nationality" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."update_passenger"("p_passenger_id" integer, "p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_passport_number" "text", "p_nationality" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_passenger"("p_passenger_id" integer, "p_user_id" "uuid", "p_first_name" "text", "p_last_name" "text", "p_date_of_birth" "date", "p_gender" "text", "p_passport_number" "text", "p_nationality" "text") TO "service_role";


















GRANT ALL ON TABLE "public"."airlines" TO "anon";
GRANT ALL ON TABLE "public"."airlines" TO "authenticated";
GRANT ALL ON TABLE "public"."airlines" TO "service_role";



GRANT ALL ON SEQUENCE "public"."airlines_airline_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."airlines_airline_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."airlines_airline_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."airports" TO "anon";
GRANT ALL ON TABLE "public"."airports" TO "authenticated";
GRANT ALL ON TABLE "public"."airports" TO "service_role";



GRANT ALL ON SEQUENCE "public"."airports_airport_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."airports_airport_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."airports_airport_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."bookings" TO "anon";
GRANT ALL ON TABLE "public"."bookings" TO "authenticated";
GRANT ALL ON TABLE "public"."bookings" TO "service_role";



GRANT ALL ON SEQUENCE "public"."bookings_booking_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."bookings_booking_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."bookings_booking_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."flights" TO "anon";
GRANT ALL ON TABLE "public"."flights" TO "authenticated";
GRANT ALL ON TABLE "public"."flights" TO "service_role";



GRANT ALL ON SEQUENCE "public"."flights_flight_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."flights_flight_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."flights_flight_id_seq" TO "service_role";



GRANT ALL ON SEQUENCE "public"."passengers_passenger_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."passengers_passenger_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."passengers_passenger_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."v_available_flights" TO "anon";
GRANT ALL ON TABLE "public"."v_available_flights" TO "authenticated";
GRANT ALL ON TABLE "public"."v_available_flights" TO "service_role";



GRANT ALL ON TABLE "public"."v_current_booked_passengers" TO "anon";
GRANT ALL ON TABLE "public"."v_current_booked_passengers" TO "authenticated";
GRANT ALL ON TABLE "public"."v_current_booked_passengers" TO "service_role";



GRANT ALL ON TABLE "public"."v_flight_statistics" TO "anon";
GRANT ALL ON TABLE "public"."v_flight_statistics" TO "authenticated";
GRANT ALL ON TABLE "public"."v_flight_statistics" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































