import os
from functools import wraps

from flask import Flask, render_template, redirect, url_for, request, session
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

#  SESSION VERSIONING
SESSION_VERSION = 2


SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_PUBLISHABLE_KEY = os.getenv("SUPABASE_PUBLISHABLE_KEY")

if not SUPABASE_URL or not SUPABASE_PUBLISHABLE_KEY:
    raise RuntimeError("Missing SUPABASE_URL or SUPABASE_PUBLISHABLE_KEY in .env")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY)

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", os.urandom(24))


#  auth middleware 

def login_required(view_func):
    @wraps(view_func)
    def wrapper(*args, **kwargs):
        if (
            not session.get("user")
            or session.get("version") != SESSION_VERSION
        ):
            session.clear()
            return redirect(url_for("login"))
        return view_func(*args, **kwargs)
    return wrapper


#  auth routes

@app.route("/login", methods=["GET", "POST"])
def login():
    error = None

    if request.method == "POST":
        email = request.form.get("email", "").strip()
        password = request.form.get("password", "")

        try:
            auth_resp = supabase.auth.sign_in_with_password({
                "email": email,
                "password": password
            })

            user = auth_resp.user
            if not user:
                return render_template("login.html", error="Invalid credentials")

            profile_resp = (
                supabase.table("profiles")
                .select("*")
                .eq("user_id", user.id)
                .limit(1)
                .execute()
            )

            profile = profile_resp.data[0] if profile_resp.data else None
            if not profile or profile.get("role") != "admin":
                return render_template("login.html", error="Access denied")

            session["user"] = {
                "id": user.id,
                "email": user.email,
                "role": profile["role"]
            }
            session["version"] = SESSION_VERSION

            return redirect(url_for("dashboard"))

        except Exception:
            return render_template("login.html", error="Login failed")

    return render_template("login.html", error=error)


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


#  dashboard 

@app.route("/")
@login_required
def dashboard():
    show = request.args.get("show", "less")

    total_bookings = supabase.table("bookings").select("booking_id", count="exact").execute().count or 0
    total_flights = supabase.table("flights").select("flight_id", count="exact").execute().count or 0
    total_passengers = supabase.table("passengers").select("passenger_id", count="exact").execute().count or 0
    total_users = supabase.table("profiles").select("user_id", count="exact").execute().count or 0

    recent_query = (
        supabase.table("bookings")
        .select("*")
        .order("booking_date", desc=True)
    )

    if show != "all":
        recent_query = recent_query.limit(5)

    recent_bookings = recent_query.execute().data or []

    return render_template(
        "dashboard.html",
        total_bookings=total_bookings,
        total_flights=total_flights,
        total_passengers=total_passengers,
        total_users=total_users,
        recent_bookings=recent_bookings,
        show=show,
    )


#  bookings

@app.route("/bookings")
@login_required
def bookings_list():
    status_filter = request.args.get("status")

    query = (
        supabase.table("bookings")
        .select("*")
        .order("booking_date", desc=True)
        .limit(200)
    )

    if status_filter:
        query = query.eq("status", status_filter)

    bookings = query.execute().data or []

    return render_template(
        "bookings.html",
        bookings=bookings,
        status_filter=status_filter,
    )


@app.route("/bookings/<booking_id>")
@login_required
def booking_detail(booking_id):
    booking_resp = (
        supabase.table("bookings")
        .select("*")
        .eq("booking_id", booking_id)
        .limit(1)
        .execute()
    )

    booking = booking_resp.data[0] if booking_resp.data else None

    passenger = None
    flight = None
    airline = None
    departure_airport = None
    profile = None

    if booking:
        if booking.get("passenger_id"):
            resp = (
                supabase.table("passengers")
                .select("*")
                .eq("passenger_id", booking["passenger_id"])
                .limit(1)
                .execute()
            )
            passenger = resp.data[0] if resp.data else None

        if booking.get("flight_id"):
            resp = (
                supabase.table("flights")
                .select("*")
                .eq("flight_id", booking["flight_id"])
                .limit(1)
                .execute()
            )
            flight = resp.data[0] if resp.data else None

            if flight:
                if flight.get("airline_id"):
                    resp = (
                        supabase.table("airlines")
                        .select("*")
                        .eq("airline_id", flight["airline_id"])
                        .limit(1)
                        .execute()
                    )
                    airline = resp.data[0] if resp.data else None

                if flight.get("departure_airport_id"):
                    resp = (
                        supabase.table("airports")
                        .select("*")
                        .eq("airport_id", flight["departure_airport_id"])
                        .limit(1)
                        .execute()
                    )
                    departure_airport = resp.data[0] if resp.data else None

        if booking.get("user_id"):
            resp = (
                supabase.table("profiles")
                .select("*")
                .eq("user_id", booking["user_id"])
                .limit(1)
                .execute()
            )
            profile = resp.data[0] if resp.data else None

    return render_template(
        "booking_detail.html",
        booking=booking,
        passenger=passenger,
        flight=flight,
        airline=airline,
        departure_airport=departure_airport,
        profile=profile,
    )


# flights 

# @app.route("/flights")
# @login_required
# def flights_list():
#     flights = (
#         supabase.table("flights")
#         .select("*")
#         .order("arrival_time", desc=True)
#         .execute()
#         .data or []
#     )
#     return render_template("flights.html", flights=flights)
@app.route("/flights")
@login_required
def flights_list():
    query_text = request.args.get("q", "").strip()

    query = (
        supabase.table("flights")
        .select("*")
        # .order("created_at", desc=True)
    )

    if query_text:
        query = query.or_(
            f"flight_number.ilike.%{query_text}%,"
            f"status.ilike.%{query_text}%"
        )

    flights = query.execute().data or []

    return render_template(
        "flights.html",
        flights=flights,
        query_text=query_text
    )


@app.route("/flights/<flight_id>")
@login_required
def flight_detail(flight_id):
    resp = (
        supabase.table("flights")
        .select("*")
        .eq("flight_id", flight_id)
        .limit(1)
        .execute()
    )

    flight = resp.data[0] if resp.data else None

    airline = None
    departure_airport = None
    bookings = []

    if flight:
        if flight.get("airline_id"):
            resp = (
                supabase.table("airlines")
                .select("*")
                .eq("airline_id", flight["airline_id"])
                .limit(1)
                .execute()
            )
            airline = resp.data[0] if resp.data else None

        if flight.get("departure_airport_id"):
            resp = (
                supabase.table("airports")
                .select("*")
                .eq("airport_id", flight["departure_airport_id"])
                .limit(1)
                .execute()
            )
            departure_airport = resp.data[0] if resp.data else None

        bookings = (
            supabase.table("bookings")
            .select("*")
            .eq("flight_id", flight_id)
            .order("booking_date", desc=True)
            .limit(200)
            .execute()
            .data or []
        )

    return render_template(
        "flight_detail.html",
        flight=flight,
        airline=airline,
        departure_airport=departure_airport,
        bookings=bookings,
    )

# add flight
@app.route("/flights/add", methods=["GET", "POST"])
@login_required
def add_flight():
    error = None

    if request.method == "POST":
        flight_no = request.form.get("flight_no", "").strip()
        airline = request.form.get("airline", "").strip()
        departure = request.form.get("departure", "").strip()
        arrival_airport_id = request.form.get("arrival_airport_id", "").strip()
        departure_time = request.form.get("departure_time")
        arrival_time = request.form.get("arrival_time")
        price = request.form.get("price")
        seats = request.form.get("seats")
        status = request.form.get("status", "active")

        # validation
        if not all([
            flight_no,
            airline,
            departure,
            arrival_airport_id,
            departure_time,
            arrival_time,
            price,
            seats
        ]):
            error = "All fields are required"
        else:
            try:
                supabase.table("flights").insert({
                    "flight_number": flight_no,
                    "airline_id": airline,
                    "departure_airport_id": departure,
                    "arrival_airport_id": arrival_airport_id,
                    "departure_time": departure_time,  
                    "arrival_time": arrival_time,
                    "price": price,
                    "available_seats": seats,
                    "status": status,
                }).execute()

                return redirect(url_for("flights_list"))

            except Exception as e:
                print(e)
                error = str(e)

    return render_template("flight_add.html", error=error)

@app.route("/flights/<flight_id>/delete", methods=["POST"])
@login_required
def delete_flight(flight_id):
    # 1. Check if flight exists
    flight_resp = (
        supabase.table("flights")
        .select("flight_id")
        .eq("flight_id", flight_id)
        .limit(1)
        .execute()
    )

    if not flight_resp.data:
        return redirect(url_for("flights_list"))

    # 2. Check if flight has bookings
    bookings_resp = (
        supabase.table("bookings")
        .select("booking_id", count="exact")
        .eq("flight_id", flight_id)
        .execute()
    )

    if bookings_resp.count and bookings_resp.count > 0:
        # Flight has bookings → do NOT delete
        return redirect(url_for("flights_list"))

    # 3. Safe to delete
    supabase.table("flights").delete().eq("flight_id", flight_id).execute()

    return redirect(url_for("flights_list"))





#  passengers

@app.route("/passengers")
@login_required
def passengers_list():
    passengers = (
        supabase.table("passengers")
        .select("*")
        .order("created_at", desc=True)
        .limit(200)
        .execute()
        .data or []
    )
    return render_template("passengers.html", passengers=passengers)


if __name__ == "__main__":
    app.run(port=5000, debug=True)
