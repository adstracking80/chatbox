# ChatBox Project Manual

This manual summarizes the scaffold, how to set it up locally (including Windows notes), and what to implement next.

## Repo structure (scaffold)
- `api/` — PHP backend scaffold (entry: `api/public/index.php`, router/controllers in `api/src/`, config in `api/config/`).
- `web/` — CRM web app placeholder (static HTML in `web/public/index.html`; replace with your SPA at `/login/`).
- `admin/` — Owner/admin placeholder UI (static HTML in `admin/public/index.html`; replace with your admin SPA at `/admin/`).
- `widget/` — Website chat widget starter (`widget/src/widget.js`) to replace WhatsApp; captures email/phone/UTM/GCLID/FBCLID.
- `scripts/sql/` — SQL schema (`001_init.sql`) for CRM + chat + lead lifecycle + custom fields.
- `scripts/deploy/` — reserved for deployment scripts.

## Local setup
1) Clone your GitHub repo:
   ```bash
   git clone https://github.com/adstracking80/chatbox.git
   cd chatbox
   ```
2) Create the directories if missing (Windows PowerShell):
   ```powershell
   mkdir api/public,api/src,api/config,web/public,web/src,widget/src,admin/public,admin/src,scripts/sql,scripts/deploy
   ```
3) Copy the scaffold files (from this repo) into those folders if they’re not present.

## Database schema
Import `scripts/sql/001_init.sql` into MySQL (cPanel) to create:
- CRM: tenants, users, owners, pipelines, stages, deals, contacts, companies, activities, notes, attachments.
- Chat: conversations, messages.
- Lead lifecycle: lead_status + timestamps + reason.
- Attribution: gclid, fbclid, utm_* , referrer, landing_page.
- Custom fields: definitions + values (deal/contact/company).

## Backend (PHP) setup
1) Copy `api/config/config.example.php` to `api/config/config.php` and set DB credentials + JWT secret + allowed CORS origins.
2) Point your vhost/subdomain (e.g., `api.adsandtracking.com`) to `api/public/index.php`.
3) Current controllers are stubs; replace with real DB + JWT logic and input validation.

## Widget integration
- Use `widget/src/widget.js`; set `apiBase`, `tenantId`, `publicKey`, and `allowAnonymous`.
- Embeds email/phone gating, sends attribution (UTM/GCLID/FBCLID/referrer/landing_page) on `/session`, then `/messages`.
- Bundle/minify before embedding (e.g., with your preferred bundler) or drop inline after light minification.

## Web/Admin UI
- `web/public/index.html` and `admin/public/index.html` are modern placeholders. Replace with your React/Vue SPA:
  - `/login/` for CRM users.
  - `/admin/` for owner/admin controls (users/roles, pipelines/stages, custom fields, branding, widget origins).

## Routes to implement (API)
- Auth: `POST /auth/login`, `POST /auth/admin/login`
- Chat (public): `POST /session`, `POST /messages`, `GET /messages`
- Admin chat: `GET /admin/conversations`, `POST /admin/messages`, `POST /admin/conversations/status`, `GET /admin/export.csv`
- Health: `GET /health`

## Deployment (cPanel)
- Ensure HTTPS and PHP version meets your needs.
- Set env/config for DB/JWT; lock down file permissions.
- If WebSockets are blocked, plan a polling/SSE fallback for chat.

## Pushing to GitHub (if blocked from this environment)
- From your machine (with GitHub access):
  ```bash
  git add .
  git commit -m "Add ChatBox CRM scaffold"
  git push origin main
  ```
- If pushing from a restricted network fails (HTTP 403/CONNECT tunnel), switch networks or use a machine with direct GitHub access.

## Next implementation steps
- Replace controller stubs with real DB + JWT auth, validation, and rate limiting.
- Build the SPAs (web/admin) and wire to the API.
- Bundle/minify the widget and embed on your site(s).
- Add tests/checks (linters, PHP unit tests) once logic is added.
