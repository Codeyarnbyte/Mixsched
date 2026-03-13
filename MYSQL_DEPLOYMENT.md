# Mixsched MySQL Deployment Guide

This project currently uses browser `localStorage`. To run in a company environment with shared data, migrate persistence/auth to MySQL-backed APIs.

## 1) Create MySQL database/schema

```bash
mysql -u root -p < db/schema.sql
```

This creates:
- `users`
- `makers`
- `models`
- `events`
- `items`

## 2) Backend requirements (recommended)

Implement a backend service (Node/PHP/Python) with endpoints such as:

- `POST /api/auth/login`
- `GET /api/makers`
- `GET /api/makers/:maker/models`
- `GET /api/makers/:maker/events`
- `GET /api/items?maker=&model=&event=`
- `POST /api/items`
- `PUT /api/items/:id`
- `DELETE /api/items/:id`
- `GET /api/summary/pic?maker=&model=&event=`

## 3) Access control for company network

Use server/firewall rules to allow only company subnets (Wi-Fi/VPN/LAN), for example:
- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`

## 4) App migration notes

- Replace `localStorage` reads/writes in `script.js`, `dashscript.js`, and `picsummary.js` with API calls.
- Keep existing role logic (`admin`/`user`) but source session from backend token/cookie.
- Keep business rules:
  - evidence required for resolved statuses
  - `DATE CLOSED` auto-populated when status is `Closed`
  - due detection based on `target_date`

## 5) Security checklist

- Hash passwords using bcrypt/argon2 in backend.
- Use HTTPS in internal network.
- Use secure session cookies or short-lived JWT + refresh flow.
- Add audit logs for admin changes.
