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

## Security and configuration
`index.html` contains the Supabase project URL and anon/public key. The public
key is expected to be visible in a browser application; it is not a privileged
service-role key. Access is enforced by Row Level Security.

New Auth signups must remain unapproved (`profiles.disabled = true`) until an
existing admin enables them. Shared prices are readable only by an approved,
active profile. For an existing database, run
`supabase/security_hardening.sql` once in the Supabase SQL Editor.
