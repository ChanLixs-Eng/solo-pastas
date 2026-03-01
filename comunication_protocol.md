# RESTful API Communication Protocol - SOLO PASTAS

This document defines the communication standards between the **Flutter** mobile client and the **Node.js/Express** server for the "SOLO PASTAS" restaurant management system.

## 1. General Configuration
- **Base URL:** `http://localhost:8000/api/v1` (Development). Use `--dart-define=API_HOST=<ip>` for LAN/device.
- **Data Format:** `application/json`
- **Authentication:** Simple Header-based PIN authentication (`X-App-PIN`).
- **Persistence:** SQLite database (better-sqlite3).

## 2. API Endpoints

### 2.1 Módulo de Gastos
Handles supplies and service payments.

* **GET `/gastos?fecha=YYYY-MM-DD`**
    * **Description:** Retrieves all expenses for a given date, sorted by time descending.
    * **Response (200 OK):** List of gastos with `id_gasto`, `descripcion`, `monto`, `tipo_gasto`, `fecha`, `hora`.

* **POST `/gastos`**
    * **Description:** Registers a new expense entry.
    * **Request Body:** `{ "descripcion": string, "monto": decimal, "tipo_gasto": string }`
    * Valid `tipo_gasto` values: `Insumo`, `Servicio`, `Otros`
    * **UI Action:** Triggered by tapping the **[ Registrar Gasto ]** button.

---

### 2.2 Módulo de Capital Humano
Manages personnel and payroll payments.

* **GET `/personal`**
    * **Description:** Retrieves all employees with their pending salary and last payment date.
    * **Response (200 OK):** List of employees with `id_personal`, `nombre`, `cargo`, `sueldo_pendiente`, `ultimo_pago`.

* **POST `/personal`**
    * **Description:** Creates a new employee.
    * **Request Body:** `{ "nombre": string, "cargo": string, "sueldo_base": decimal }`

* **DELETE `/personal/{id}`**
    * **Description:** Deletes an employee and their associated payments.

* **GET `/pagos?fecha=YYYY-MM-DD`**
    * **Description:** Retrieves all payroll payments for a given date, with employee name joined.
    * **Response (200 OK):** List of pagos with `id_pago`, `id_personal`, `monto_pagado`, `concepto`, `fecha`, `nombre_empleado`.

* **POST `/pagos`**
    * **Description:** Records a money transfer to an employee.
    * **Request Body:** `{ "id_personal": int, "monto_pagado": decimal, "concepto": string }`
    * Valid `concepto` values: `Sueldo`, `Adelanto`, `Bono`
    * **UI Action:** Triggered by tapping the **[ Pagar ]** button.

---

### 2.3 Módulo de Finanzas (Cierre de Caja)
Finalizes the daily operations and calculates profit.

* **GET `/cierres?fecha=YYYY-MM-DD`**
    * **Description:** Retrieves all closures for a given date.
    * **Response (200 OK):** List of cierres with `id_cierre`, `ingresos_ventas`, `total_gastos`, `total_pagos`, `utilidad_neta`, `fecha`.

* **GET `/cierres/resumen-dia?fecha=YYYY-MM-DD`**
    * **Description:** Returns aggregated expense and payment totals for the day.
    * **Response (200 OK):** `{ "fecha": string, "total_gastos": decimal, "total_pagos": decimal }`

* **POST `/cierres`**
    * **Description:** Generates the **Cierre de Caja** for the current date.
    * **Request Body:** `{ "ingresos_ventas": decimal, "fecha": string }`
    * **Logic:** The server automatically aggregates all expenses and payroll for the date to calculate **Utilidad Neta**.
    * **UI Action:** Triggered by the **[ Cerrar Caja y Guardar ]** button.

## 3. Error Handling
The server returns standard HTTP status codes:
- **400 Bad Request:** Missing fields or validation errors (e.g., negative amounts).
- **401 Unauthorized:** Invalid or missing PIN.
- **404 Not Found:** Resource not found (e.g., employee does not exist).
- **500 Internal Server Error:** Database or server-side logic failure.

## 4. Technical Constraints
- All currency values must be handled as **Decimal(10,2)** to avoid rounding errors.
- Dates must follow the ISO 8601 format (`YYYY-MM-DD`).
