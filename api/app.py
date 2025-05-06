from flask import Flask, request, jsonify
import pyodbc
import os

app = Flask(__name__)

# Configuración de la conexión a SQL Server usando variables de entorno
# server = os.getenv('SQL_SERVER', 'TU_SERVIDOR_SQL')
# database = os.getenv('SQL_DATABASE', 'TU_BASE_DE_DATOS')
# username = os.getenv('SQL_USERNAME', 'TU_USUARIO')
# password = os.getenv('SQL_PASSWORD', 'TU_CONTRASEÑA')
server = os.getenv('SQL_SERVER', 'localhost')
database = os.getenv('SQL_DATABASE', 'taller_mechanic')
username = os.getenv('SQL_USERNAME', 'clientmwp')
password = os.getenv('SQL_PASSWORD', 'Y6rvrTykzPE6jP4a0yrRr2NBVX43')
connection_string = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'

@app.route('/add_data', methods=['POST'])
def add_data():
    conn = None
    try:
        # Obtener datos del cuerpo de la solicitud
        data = request.json
        nombre = data.get('nombre')
        edad = data.get('edad')

        # Validar datos
        if not nombre or not edad:
            return jsonify({'error': 'Faltan datos: nombre y edad son requeridos'}), 400

        # Conectar a la base de datos
        conn = pyodbc.connect(connection_string)
        cursor = conn.cursor()

        # Insertar datos en la base de datos
        query = "INSERT INTO TuTabla (nombre, edad) VALUES (?, ?)"
        cursor.execute(query, (nombre, edad))
        conn.commit()

        return jsonify({'message': 'Datos añadidos correctamente'}), 200

    except pyodbc.Error as db_err:
        return jsonify({'error': f'Error en la base de datos: {str(db_err)}'}), 500
    except Exception as e:
        return jsonify({'error': f'Error inesperado: {str(e)}'}), 500
    finally:
        # Asegurarse de cerrar la conexión
        if conn:
            conn.close()

if __name__ == '__main__':
    app.run(debug=True)