# Pesign UI/UX Strategy & Layout Architecture

## 1. Core Design System
* **Theme:** Premium SaaS (Trust Blue `#2563EB` & Clean White `#FFFFFF`).
* **Typography:** Inter (Google Fonts) for maximum legibility across numbers, pricing, and dense vendor spreadsheets.
* **Icons:** Lucide-React for consistent, scalable vector iconography.
* **Animations:** Framer Motion for micro-interactions (e.g., smooth cart drawers, upload progress bars).

## 2. Layout Isolation Strategy
To maintain security and context, the platform utilizes Next.js Route Groups to create completely isolated layout wrappers:

### A. The Storefront `app/(storefront)/layout.tsx`
* **Target Audience:** Public visitors and corporate customers.
* **UI Elements:** Sticky navigation bar, marketing hero sections, heavy use of imagery, footer with SEO links.
* **Goal:** High conversion, trust-building, and seamless product configuration.

### B. The Vendor Dashboards `app/(dashboards)/layout.tsx`
* **Target Audience:** Internal admins, freelance designers, partner printers.
* **UI Elements:** Collapsible sidebar navigation, dense data tables, minimal padding, focused workspace views.
* **Goal:** Efficiency, speed, and clear task management. No marketing fluff.

## 3. Mobile-First Execution
* All customer flows (especially the product configuration and checkout) are tested on standard 3G/4G Indian mobile networks.
* Touch targets are enforced at a minimum of 48px x 48px.
* Heavy assets are deferred or compressed on the client-side before uploading.
