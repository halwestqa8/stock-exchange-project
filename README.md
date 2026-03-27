# Stock Exchange Project

## Coolify deployment

This repo includes a Docker Compose stack for Coolify with:

- `database`: PostgreSQL
- `api`: Laravel API
- `admin`: Flutter web admin panel
- `staff`: Flutter web staff panel

### Required environment variables in Coolify

- `APP_KEY`
- `DB_DATABASE`
- `DB_USERNAME`
- `DB_PASSWORD`
- `API_BASE_URL`

Suggested public URLs for server `45.32.155.226`:

- `https://ltsmapi.45.32.155.226.sslip.io`
- `https://ltsmadmin.45.32.155.226.sslip.io`
- `https://ltsmstaff.45.32.155.226.sslip.io`

Use:

```text
API_BASE_URL=https://ltsmapi.45.32.155.226.sslip.io
```

### Default seeded accounts

- Super admin: `admin@ltms.app`
- Staff: `staff@ltms.app`
- Driver: `driver@ltms.app`

If you do not override the seed passwords in Coolify, the default password is `password`.
