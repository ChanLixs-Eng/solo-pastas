# Communication and Sequence Diagrams - SOLO PASTAS

This document visualizes the communication logic and event sequences for the system to ensure data integrity and a smooth mobile user experience.

## 1. General Architecture (Client-Server)
The system follows a decoupled architecture model where the mobile interface communicates exclusively via JSON with a central server.



- [cite_start]**Client (Flutter):** Manages the UI in Spanish, local validations, and application state [cite: 191-192].
- [cite_start]**Server (FastAPI):** Exposes REST Endpoints and applies business logic (such as profit calculations)[cite: 16].
- [cite_start]**Database (SQLite):** Local data persistence in a single file[cite: 24, 73].

---

## 2. Sequence Diagram: Registro de Gasto
This flow occurs when the owner purchases supplies or pays for a service.



1. [cite_start]**User:** Enters data in the **Registro de Gastos** screen and taps **[ Registrar Gasto ]**[cite: 232].
2. **Client:** Sends a `POST /api/v1/gastos` request with the expense JSON data.
3. [cite_start]**Server:** Validates the amount, assigns the current date, and saves it in the `gastos` table [cite: 40-47, 234].
4. **Server:** Responds with `201 Created`.
5. [cite_start]**Client:** Displays a success message and automatically returns to the previous screen [cite: 235-236].

---

## 3. Sequence Diagram: Cierre de Caja (Business Logic)
This is the most critical process where the server consolidates financial information for the day.



1. [cite_start]**User:** Enters the **Total Ingresado en el Día** and taps **[ Cerrar Caja y Guardar ]**[cite: 254].
2. **Client:** Sends a `POST /api/v1/cierres` request with the sales amount.
3. **Server:** Performs the following internal operations:
    - [cite_start]Sums all records in the `gastos` table for the current date[cite: 65, 70].
    - [cite_start]Sums all payments in the `pagos_nomina` table for the current date[cite: 65, 70].
    - [cite_start]Applies the formula: **Utilidad = Ingresos - (Gastos + Personal)**[cite: 16, 66].
4. [cite_start]**Server:** Saves the result in the `cierres_caja` table [cite: 60-66, 259].
5. **Server:** Responds with the created closure object.
6. [cite_start]**Client:** Notifies success and redirects to **Inicio** (Dashboard) with reset counters [cite: 260-261].

---

## 4. State Diagram: Menu Availability
Shows how status changes affect real-time visualization.



- [cite_start]**Action:** The user taps the **Switch (Disponible/Agotado)**[cite: 222].
- **Transition:** The client sends a `PUT` request to the server.
- [cite_start]**Result:** The server updates the `estado` field in the `productos` table[cite: 39].
- [cite_start]**Feedback:** The UI updates visually to reflect the change (e.g., dimming the item if it is marked as **Agotado**)[cite: 221].
