# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**SOLO PASTAS** is a restaurant management mobile app for a pasta restaurant in Bolivia. It tracks daily cash close, staff management, and supply expenses. The owner is the sole user. Currency is Bolivianos (Bs.).

## Architecture

- **Client:** Flutter (Dart) mobile app — handles UI, local validation, and state
- **Server:** Node.js (Express) — REST API with business logic (profit calculations, aggregations)
- **Database:** SQLite (better-sqlite3) — single-file local persistence
- **Auth:** Simple header-based PIN (`X-App-PIN`), not OAuth/JWT

Base URL: `http://localhost:8000/api/v1`

## Modules and API Endpoints

| Module | Endpoints | Purpose |
|---|---|---|
| Gastos | `GET /gastos?fecha=YYYY-MM-DD`, `POST /gastos` | List today's expenses, register new expenses |
| Personal (Capital Humano) | `GET /personal`, `GET /pagos?fecha=YYYY-MM-DD`, `POST /pagos` | Employee list, today's payments, payroll payments |
| Finanzas (Cierre de Caja) | `POST /cierres` | Daily cash close with auto-calculated net profit |

## Core Business Logic

The critical calculation is **Cierre de Caja** (daily cash close), done server-side:

```
Utilidad Neta = Ingresos Ventas - (Sum of gastos for date + Sum of pagos for date)
```

The server aggregates all expenses and payroll for the given date automatically when a closure is created.

## Key Technical Constraints

- All currency values: `Decimal(10,2)` — never use floats for money
- Dates: ISO 8601 (`YYYY-MM-DD`)
- UI language: Spanish throughout
- Expense types (`tipo_gasto`): `Insumo`, `Servicio`, `Otros`
- Payment concepts (`concepto`): `Sueldo`, `Adelanto`, `Bono`

## UI Screens (see mockup JPEGs)

Four main screens accessible via bottom navigation: **Home** (dashboard with today's profit/expenses + quick actions + activity feed from gastos and pagos), **Gastos** (expense registration with numpad and recent history), **Personal** (employee cards with pending salary and pay button), **Reportes** (historical closures).

## Documentation Files

- `functional_requirements.md` — RF01-RF10 functional specs
- `comunication_protocol.md` — API contract and endpoint definitions
- `diagrams.md` — Sequence diagrams for key flows (expense registration, cash close)
- `*.jpeg` — UI mockup screenshots for each screen
