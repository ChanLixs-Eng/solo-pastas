# RESTful API Communication Protocol - SOLO PASTAS

This document defines the communication standards between the **Flutter** mobile client and the **FastAPI** server for the "SOLO PASTAS" restaurant management system.

## 1. General Configuration
- **Base URL:** `http://localhost:8000/api/v1` (Development)
- **Data Format:** `application/json`
- [cite_start]**Authentication:** Simple Header-based PIN authentication (`X-App-PIN`)[cite: 21].
- [cite_start]**Persistence:** SQLite database[cite: 24].

## 2. API Endpoints

### 2.1 Módulo de Menú y Precios
[cite_start]Allows management of products and categories[cite: 4].

* **GET `/productos`**
    * [cite_start]**Description:** Retrieves the full menu organized by categories[cite: 7, 68].
    * **Response (200 OK):** List of products with `id_producto`, `nombre`, `precio_venta`, and `estado`.

* **PUT `/productos/{id}`**
    * [cite_start]**Description:** Updates the price or availability status of an item[cite: 6].
    * [cite_start]**Request Body:** `{ "precio_venta": decimal, "estado": boolean }`[cite: 37, 39].
    * [cite_start]**UI Action:** Triggered by editing the input or tapping the **Switch (Disponible/Agotado)**[cite: 111, 130].

---

### 2.2 Módulo de Gastos
[cite_start]Handles supplies and service payments[cite: 8].

* **POST `/gastos`**
    * [cite_start]**Description:** Registers a new expense entry[cite: 9, 10].
    * [cite_start]**Request Body:** `{ "descripcion": string, "monto": decimal, "tipo_gasto": string }`[cite: 44, 45, 47].
    * [cite_start]**UI Action:** Triggered by tapping the **[ Registrar Gasto ]** button[cite: 121, 125].

---

### 2.3 Módulo de Capital Humano
[cite_start]Manages personnel and payroll payments[cite: 11].

* **GET `/personal`**
    * [cite_start]**Description:** Retrieves all employees and their **Sueldo pendiente**[cite: 12, 149].
    * **Response (200 OK):** List of employees with `id_personal`, `nombre`, `cargo`, and last payment date.

* **POST `/pagos`**
    * [cite_start]**Description:** Records a money transfer to an employee[cite: 13, 54].
    * [cite_start]**Request Body:** `{ "id_personal": int, "monto_pagado": decimal, "concepto": string }`[cite: 56, 57, 59].
    * [cite_start]**UI Action:** Triggered by tapping the **[ Pagar ]** button[cite: 147, 159].

---

### 2.4 Módulo de Finanzas (Cierre de Caja)
[cite_start]Finalizes the daily operations and calculates profit[cite: 14].

* **POST `/cierres`**
    * [cite_start]**Description:** Generates the **Cierre de Caja** for the current date[cite: 15, 60].
    * [cite_start]**Request Body:** `{ "ingresos_ventas": decimal, "fecha": string }`[cite: 63, 64].
    * [cite_start]**Logic:** The server automatically aggregates all expenses and payroll for the date to calculate **Utilidad Neta**[cite: 16, 66].
    * [cite_start]**UI Action:** Triggered by the **[ Cerrar Caja y Guardar ]** button[cite: 189].

## 3. Error Handling
The server must return standard HTTP status codes:
- **400 Bad Request:** Missing fields or validation errors (e.g., negative amounts).
- [cite_start]**401 Unauthorized:** Invalid or missing PIN[cite: 21].
- [cite_start]**409 Conflict:** Referential integrity issues (e.g., trying to delete a category with active products)[cite: 72].
- **500 Internal Server Error:** Database or server-side logic failure.

## 4. Technical Constraints
- [cite_start]All currency values must be handled as **Decimal(10,2)** or integers (cents) to avoid rounding errors[cite: 73].
- Dates must follow the ISO 8601 format (`YYYY-MM-DD`).

