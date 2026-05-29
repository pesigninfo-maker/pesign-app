import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "../styles/globals.css";

// Initialize the Inter font (Premium SaaS standard)
const inter = Inter({ subsets: ["latin"] });

// Centralized SEO and Metadata for the entire platform
export const metadata: Metadata = {
  title: "Pesign | Premium AI Design, Print & Delivery",
  description: "India's most advanced centralized platform for professional graphic design, corporate printing, and lightning-fast logistics.",
  keywords: ["printing", "graphic design", "B2B printing", "AI design", "fast delivery India", "visiting cards", "banners"],
  openGraph: {
    title: "Pesign | Premium AI Design & Print",
    description: "Instant Design + Print + Delivery. Built for scale.",
    url: "https://pesignApp.com",
    siteName: "Pesign",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="scroll-smooth">
      <body 
        className={`${inter.className} bg-slate-50 text-slate-900 antialiased min-h-screen flex flex-col`}
      >
        {/* Global Navigation will be injected here in Phase 5 */}
        
        <main className="flex-grow w-full">
          {children}
        </main>

        {/* Global Footer will be injected here in Phase 5 */}
      </body>
    </html>
  );
}
