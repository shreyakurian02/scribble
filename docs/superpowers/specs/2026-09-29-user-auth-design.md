# Admin user signup / signin / signout

## Goal
Admin dashboard users (authors) can sign up, sign in and sign out with email
and password. Sessions use `has_secure_token`. The public reader flow (shared
site password + `X-Auth-Token`, anonymous `X-Visitor-Token`) is unchanged.

## Current state
- Admin API (`/api/v1/*`) has no authentication; `current_user` is
  `@site.users.first` (`LoadCurrentUser`).
- `User` has no password or token columns. `bcrypt` is already in the Gemfile.

## Data
Migration on `users`: add `password_digest` (string) and
`authentication_token` (string, unique index).

`User`:
- `has_secure_password`; password minimum length 6.
- `has_secure_token :authentication_token` (generated on create).
- Signout calls `regenerate_authentication_token`, invalidating the old token.

## API (under `api/v1`, admin side)
- `POST /signup` -> `users#create`: first_name, last_name, email, password,
  password_confirmation. Creates the user on the current site; returns user
  and token. Signup is open (no invitation/first-user restriction).
- `POST /session` -> `sessions#create`: email, password. Returns user and
  token; 401 with one generic message for unknown email or bad password.
- `DELETE /session` -> `sessions#destroy`: regenerates the token.

## Enforcing auth
- New `AdminAuthenticatable` concern in a base admin controller. A
  `before_action` reads `X-User-Token`, looks the user up by token within the
  site, and sets `current_user`; otherwise responds 401.
- Replaces `LoadCurrentUser`'s `site.users.first` for admin controllers.
- Categories, redirections, articles, bulk and site controllers inherit it.
  Signup and session create are exempt. Public controllers are untouched.
- Action Cable accepts only `/cable?token=<user token>`; a bare email is no
  longer trusted.
- The home page no longer embeds `User.first` (`get_user` helper removed).

## Frontend
- Login and signup pages; token stored in `localStorage`.
- Axios sends `X-User-Token`; a 401 clears the token and redirects to login.
- Dashboard routes are guarded; logout button in the navbar.
- Public routes unchanged.

## Tests
- Model: password validation, token generated on create, regenerated on signout.
- Controllers: signup, signin (success, bad email, bad password), signout
  (old token rejected afterwards), admin endpoints 401 without a token.
- Existing admin controller tests send a token header via a shared helper.

## Known consequences
- One token per user: signout on one device signs out all devices.
- Existing seeded users have no password; seeds/rake task must set one.
- Token is stored in plaintext, matching the existing `Site#authentication_token`.
