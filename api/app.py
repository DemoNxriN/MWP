from flask import Flask, request, jsonify
import pymysql
import os
from flask_cors import CORS 

app = Flask(__name__)
CORS(app)

# Configuración desde variables de entorno
DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_USER = os.environ.get("DB_USER", "mwp")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "Y6rvrTykzPE6jP4a0yrRr2NBVX43")
DB_NAME = os.environ.get("DB_NAME", "dbmwp")

def get_db_connection():
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route("/api/cita", methods=["POST"])
def crear_cita():
    data = request.get_json()

    name = data.get("name")
    email = data.get("email")
    phone = data.get("phone")
    car_make = data.get("car_make")
    car_model = data.get("car_model")
    car_plate = data.get("car_plate")
    service = data.get("service")
    date = data.get("date")

    if not all([name, email, phone, car_make, car_model, car_plate, service, date]):
        return jsonify({"error": "Faltan campos obligatorios"}), 400

    try:
        conn = get_db_connection()
        with conn.cursor() as cursor:
            # Insertar cliente (si no existe)
            cursor.execute("SELECT IdClient FROM Clients WHERE email = %s", (email,))
            client = cursor.fetchone()

            if client:
                client_id = client["IdClient"]
            else:
                cursor.execute(
                    "INSERT INTO Clients (nom, DNI, telefon, email) VALUES (%s, %s, %s, %s)",
                    (name, "00000000X", phone, email)
                )
                client_id = cursor.lastrowid

            # Insertar vehículo (si no existe)
            cursor.execute("SELECT IdVehicle FROM Vehicles WHERE matricula = %s", (car_plate,))
            vehicle = cursor.fetchone()

            if vehicle:
                vehicle_id = vehicle["IdVehicle"]
            else:
                cursor.execute(
                    "INSERT INTO Vehicles (IdClient, matricula, model, any) VALUES (%s, %s, %s, %s)",
                    (client_id, car_plate, f"{car_make} {car_model}", 2020)
                )
                vehicle_id = cursor.lastrowid

            # Insertar cita
            cursor.execute(
                "INSERT INTO Cita (IdClient, data, servei, IdVehicle) VALUES (%s, %s, %s, %s)",
                (client_id, date, service, vehicle_id)
            )

        conn.commit()
        return jsonify({"message": "Cita creada correctamente"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        conn.close()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
