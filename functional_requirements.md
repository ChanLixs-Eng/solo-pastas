# Functional Requirements - SOLO PASTAS

[cite_start]This document describes the specific actions the system must perform to satisfy the owner's management needs [cite: 2-3].

## 1. Expenses and Logistics Module (Gastos)
* [cite_start]**RF04 - Registro de Insumos**: The system must allow for recording daily raw material purchases (**Harina**, **Queso**, **Tomate**, etc.), including description, amount paid, and date [cite: 8-9].
* [cite_start]**RF05 - Gestión de Cuentas (Gastos Fijos/Variables)**: The system must allow for the registration of service payments (**Luz**, **Agua**, **Gas**, **Alquiler**) separate from kitchen supplies[cite: 10].

## 2. Human Capital Module (Personal)
* [cite_start]**RF06 - Registro de Personal**: The system must store basic employee information and their agreed **Sueldo base** [cite: 11-12].
* [cite_start]**RF07 - Control de Pagos al Personal**: The system must allow for recording every time money is given to an employee (**Sueldos**, **Adelantos**, or **Bonos**), automatically deducting it from the balance[cite: 13].

## 3. Finance and Control Module
* [cite_start]**RF08 - Cierre de Caja Diario**: The system must allow the owner to enter the total daily sales (**Efectivo + Transferencias**) to contrast them against registered expenses [cite: 14-15].
* **RF09 - Cálculo de Utilidad Neta**: The system must automatically calculate real profit using the following formula: 
  [cite_start]**Utilidad = Ingresos Totales - (Insumos + Gastos + Pagos Personal)**[cite: 16].
* [cite_start]**RF10 - Historial de Movimientos**: The system must allow for viewing past **Cierres de Caja** reports for weekly or monthly performance analysis[cite: 17].

---

## Summary of Actions for Development

| Action (**Acción**) | Data Input (**Entrada de Datos**) | Output / Result (**Salida/Resultado**) |
| :--- | :--- | :--- |
| **Registrar gasto** | Description + Amount + Type | Entry in daily expenses |
| **Registrar compra** | Concept + Amount | Reduction in available balance |
| **Pagar sueldo** | Selection of employee + Amount | Entry in **Historial de nómina** |
| **Cerrar caja** | **Ventas brutas** of the day | **Reporte de ganancia limpia** |


