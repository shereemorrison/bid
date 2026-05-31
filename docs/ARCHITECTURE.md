# B.I.D. App Architecture

## Overview

Flutter e-commerce app using **Riverpod** for state, **GoRouter** for navigation, and **Supabase** for auth, database, and edge functions (Stripe).

## Folder layout

```
lib/
├── components/     # Reusable UI (address, checkout, product, auth)
├── layouts/        # App shell (tabs, web drawer)
├── models/         # Data classes
├── pages/          # Route screens
├── providers.dart  # DI + global providers (split over time into core/providers/)
├── respositories/  # Supabase data access (rename → repositories planned)
├── routes/         # GoRouter config
├── services/       # Payment, Mapbox, app state coordinator
├── state/          # Notifiers: auth, cart, wishlist, orders, products
├── themes/         # Light/dark themes
└── supabase/       # Client config (gitignored; use .example)
```

## State (simplified)

| Area | Provider | Notes |
|------|----------|--------|
| Auth | `authProvider` | Login, profile, sign-out |
| Session | `sessionProvider` | Guest `user_id` after address save |
| Cart | `cartProvider` | In-memory cart |
| Catalog | `productsProvider` | Categories + products |
| Checkout flags | `checkoutCompleteProvider`, `orderConfirmationIdProvider` | Post-payment navigation |

**User IDs:** `currentUserIdProvider` returns `public.users.user_id` (not Supabase `auth.uid()`).

## Checkout flow

1. `/cart/checkout` → `SimpleCheckoutPage` (shipping → payment → review)
2. Guest: `AddressForm` creates guest row in `users`, saves `addresses`, sets session guest id
3. Payment: Stripe `CardField` + `PaymentService` → `orders`, `order_items`, `order_payments`
4. Navigate to `/order-confirmation?order_id=...`

## Supabase

See `supabase/README.md` and `supabase/migrations/00001_initial_schema.sql`.
