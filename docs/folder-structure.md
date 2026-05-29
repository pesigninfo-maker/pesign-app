# Pesign Master Directory Map

This is the standard architectural tree for the Pesign Next.js repository. Adherence to this structure is mandatory for all commits.

```text
pesigninfo-maker/
├── .github/                   # CI/CD Actions and automated deployment rules
│   └── workflows/             # YAML files for GitHub-to-Vercel pipelines
├── app/                       # Next.js 14 App Router Core
│   ├── (storefront)/          # Public-facing eCommerce pages
│   ├── (dashboards)/          # Secure vendor/admin operational pages
│   ├── api/                   # Webhook endpoints (Razorpay, Clerk, etc.)
│   ├── layout.tsx             # Root HTML document and global providers
│   └── page.tsx               # Primary landing page
├── components/                # Reusable React UI Assets
│   ├── ui/                    # Atomic design elements (Buttons, Inputs)
│   ├── storefront/            # Complex modules (Navbars, Product Grids)
│   └── dashboards/            # Operational UI (Data tables, Uploaders)
├── docs/                      # Engineering and Architecture Documentation
├── public/                    # Static assets (Logos, manifest.json, robots.txt)
├── styles/                    # Global CSS and Tailwind injections
├── database/                  # SQL Schemas and migration files
├── next.config.js             # Webpack and Next.js compiler settings
├── tailwind.config.ts         # Design system tokens and plugins
├── package.json               # Node dependencies and core scripts
└── README.md                  # Project onboarding manual
