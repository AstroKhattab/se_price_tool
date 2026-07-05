# Price Intelligence Tool

A multi-user price search, project quoting, and client-tracking web app.
Frontend hosted on GitHub Pages; data and logins on Supabase (free tier).

## How it works
- Everyone signs in with their own email + password.
- **Admin (you)** uploads the databases in the Admin tab — they instantly sync to every user and device:
  - **Price File** (yearly): Admin → File → Upload
  - **GMI files** (quarterly): Admin → File → GMI Price Files
  - **Clients / CAP list**: Admin → CAP Data
- **Users** can search prices, build their own quotes, and track their own clients.
  They can only see their own quotes and clients — enforced by the database, not just the app.
- **You see everything**: the Dashboard has an "All users" filter, and Admin → Log Book
  shows who did what, filterable by user.

## Routine tasks
| Task | Where |
|---|---|
| Update GMI pricing (quarterly) | Admin → File → GMI zones → upload new xlsx |
| Update price file (yearly) | Admin → File → Upload |
| Add a friend/user | Admin → Users → Create User, then send them the link + password |
| Disable a user | Admin → Users → Disable |
| See activity | Admin → Log Book |
| Change your password | Admin → Access (users: same tab, visible to them) |

## On iPad / iPhone
Open the link in Safari → Share button → **Add to Home Screen**.
It installs like an app and works offline with the last-synced data.

## Configuration
`index.html` contains two placeholders filled at deploy time:
- `__SUPABASE_URL__` — your Supabase project URL
- `__SUPABASE_ANON_KEY__` — the project's anon/public key (safe to publish;
  all access is enforced by Row Level Security)

Database schema: `../supabase/schema.sql` (run once in the Supabase SQL Editor).
