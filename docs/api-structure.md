# Pesign API & Server Action Architecture

This document outlines the data-flow strategy for the Pesign platform. We utilize Next.js 14 App Router, moving away from traditional `/pages/api` in favor of highly secure Server Actions for internal mutations and Route Handlers for external webhooks.

## 1. External Webhooks (Route Handlers)
Located in `src/app/api/webhooks/`

These endpoints are strictly for server-to-server communication with third-party vendors.
* **`clerk/route.ts`**: Listens for user creation/deletion events from Clerk Auth and synchronizes the profile data into our Neon PostgreSQL database.
* **`razorpay/route.ts`**: Highly secure endpoint that verifies payment signatures. Once validated, it changes the order status to `PAYMENT_CONFIRMED` and triggers the vendor assignment workflow.
* **`delivery/route.ts`**: Webhook for logistics partners (e.g., Shiprocket/Delhivery) to push live GPS and status updates to our platform.

## 2. Internal Server Actions
Located in `src/app/actions/`

These are asynchronous functions executed securely on the Vercel edge/server, directly called from client components.
* **`orders/create-intent.ts`**: Calculates total price (base + GSM upcharge + shipping), applies corporate GST discounts, and generates a Razorpay Order ID.
* **`workflows/assign-vendor.ts`**: Algorithmic router that matches paid orders to the next available designer or printer based on workload capacity.
* **`workflows/submit-proof.ts`**: Handles the Cloudinary secure URL upload when a designer submits a vectorized file for customer approval.

## 3. Database ORM
* **Drizzle ORM** is used for complete type safety.
* Schemas map 1:1 with Neon DB tables. If a schema changes, API types automatically update, preventing runtime crashes.
