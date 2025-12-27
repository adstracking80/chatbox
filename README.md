# ChatBox CRM/Chat Scaffold

This repository now includes a starter structure for a Pipedrive-style CRM with an integrated chat widget and dual-scope authentication (/login for users, /admin for owner). The code is intentionally lightweight and scaffold-only so you can copy/paste and extend quickly. The layout is inspired by Laravel-style modularity (see krayin/laravel-crm) but is intentionally framework-lite for cPanel deployments.

## Structure
- `api/` – PHP backend scaffold (public entrypoint, routes, config placeholders).
- `web/` – CRM web app scaffold (login + dashboard placeholder).
- `widget/` – Website chat widget starter (JS to replace WhatsApp popup, with attribution capture).
- `admin/` – Owner/admin UI scaffold (manage users, pipelines, settings).
- `scripts/sql/` – Initial SQL migrations for core CRM + chat + attribution.
- `scripts/deploy/` – Placeholder for deployment scripts.

## Getting started (high level)
1. Copy `scripts/sql/001_init.sql` into your MySQL instance (cPanel) to create core tables.
2. Configure `api/config/config.example.php` into `config.php` with DB creds and JWT secrets.
3. Point your web server to `api/public/index.php` for API traffic (e.g., `api.adsandtracking.com`).
4. Serve `web/public/index.html` for the CRM app at `chatbox.adsandtracking.com` and `/login/` route.
5. Serve `admin/public/index.html` for owner admin at `/admin/`.
6. Embed `widget/src/widget.js` (after bundling/minifying if desired) on your marketing site to replace the WhatsApp widget.

## Notes
- All PHP files are skeletons—fill in routing, controllers, and JWT/session handling.
- Widget starter captures email/phone, supports anonymous mode, and sends attribution (gclid/fbclid/UTM) to the `/session` endpoint you will implement.
- SQL includes lead lifecycle fields (new/qualified/converted/disqualified) and attribution columns.

## API scaffold (inspired by krayin/laravel-crm patterns)
- Auth: `POST /auth/login`, `POST /auth/admin/login`
- Chat (public): `POST /session`, `POST /messages`, `GET /messages`
- Admin chat: `GET /admin/conversations`, `POST /admin/messages`, `POST /admin/conversations/status`, `GET /admin/export.csv`
- Health: `GET /health`

These routes currently return placeholder JSON/CSV. Replace stubs with real DB + JWT logic as you wire up the schema from `scripts/sql/001_init.sql`.

### Optimization notes
- CORS is applied from `config.php` (defaults to allowing configured origins).
- OPTIONS preflight returns 204 to keep the widget snappy.
- JSON helpers parse request bodies; bearer token helper reads `Authorization` headers.
