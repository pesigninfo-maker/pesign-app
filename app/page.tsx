import React from 'react';
import Link from 'next/link';
import { ArrowRight, Printer, Palette, Truck, CheckCircle2 } from 'lucide-react';

export default function HomePage() {
  return (
    <div className="w-full flex flex-col items-center justify-center">
      
      {/* 1. HERO SECTION */}
      <section className="w-full bg-white border-b border-slate-200 pt-24 pb-32 px-6 lg:px-8 flex flex-col items-center text-center">
        <div className="max-w-4xl mx-auto">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-50 border border-blue-100 text-blue-700 text-sm font-medium mb-8">
            <span className="flex h-2 w-2 rounded-full bg-blue-600"></span>
            Pesign Platform v1.0 is Live
          </div>
          
          <h1 className="text-5xl md:text-7xl font-extrabold tracking-tight text-slate-900 mb-6">
            Instant Design. <br className="hidden md:block" />
            <span className="text-blue-600">Flawless Print.</span> Fast Delivery.
          </h1>
          
          <p className="text-lg md:text-xl text-slate-600 max-w-2xl mx-auto mb-10 leading-relaxed">
            The all-in-one centralized platform for corporate branding, high-GSM printing, and localized logistics. Upload your vision, we handle the execution.
          </p>
          
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link 
              href="/products" 
              className="w-full sm:w-auto px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-semibold transition-all flex items-center justify-center gap-2 shadow-sm"
            >
              Start Printing
              <ArrowRight className="w-5 h-5" />
            </Link>
            <Link 
              href="/design-services" 
              className="w-full sm:w-auto px-8 py-4 bg-white border border-slate-200 hover:border-slate-300 hover:bg-slate-50 text-slate-700 rounded-xl font-semibold transition-all flex items-center justify-center gap-2"
            >
              Hire a Designer
            </Link>
          </div>
        </div>
      </section>

      {/* 2. CORE SERVICES ARCHITECTURE SECTION */}
      <section className="w-full bg-slate-50 py-24 px-6 lg:px-8">
        <div className="max-w-6xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-slate-900 mb-4">The Pesign Ecosystem</h2>
            <p className="text-slate-600 text-lg">One platform to manage your entire physical branding pipeline.</p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            {/* Feature 1 */}
            <div className="bg-white p-8 rounded-2xl border border-slate-100 shadow-sm hover:shadow-md transition-shadow">
              <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center mb-6">
                <Palette className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-slate-900 mb-3">Studio Design</h3>
              <p className="text-slate-600 leading-relaxed mb-6">
                Professional designers ready to vectorize logos, layout visiting cards, and create high-conversion flex banners.
              </p>
              <ul className="space-y-2">
                {['Unlimited Revisions', 'AI Margin Checks', 'Print-Ready Exports'].map((item, i) => (
                  <li key={i} className="flex items-center gap-2 text-sm text-slate-700">
                    <CheckCircle2 className="w-4 h-4 text-blue-500" />
                    {item}
                  </li>
                ))}
              </ul>
            </div>

            {/* Feature 2 */}
            <div className="bg-white p-8 rounded-2xl border border-slate-100 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden">
              <div className="absolute top-0 right-0 bg-blue-600 text-white text-xs font-bold px-3 py-1 rounded-bl-lg">CORE</div>
              <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center mb-6">
                <Printer className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-slate-900 mb-3">Precision Printing</h3>
              <p className="text-slate-600 leading-relaxed mb-6">
                Enterprise-grade printing presses utilizing premium GSM papers, UV spotting, and durable PVC materials.
              </p>
              <ul className="space-y-2">
                {['300+ GSM Art Board', 'Matte & Gloss Finishes', 'Large Format Flex'].map((item, i) => (
                  <li key={i} className="flex items-center gap-2 text-sm text-slate-700">
                    <CheckCircle2 className="w-4 h-4 text-blue-500" />
                    {item}
                  </li>
                ))}
              </ul>
            </div>

            {/* Feature 3 */}
            <div className="bg-white p-8 rounded-2xl border border-slate-100 shadow-sm hover:shadow-md transition-shadow">
              <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center mb-6">
                <Truck className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-slate-900 mb-3">Hyper-Local Logistics</h3>
              <p className="text-slate-600 leading-relaxed mb-6">
                Direct-to-door delivery with live visual tracking. From the printer's tray straight to your corporate office.
              </p>
              <ul className="space-y-2">
                {['Live GPS Tracking', 'Secure Packaging', 'Priority Dispatch'].map((item, i) => (
                  <li key={i} className="flex items-center gap-2 text-sm text-slate-700">
                    <CheckCircle2 className="w-4 h-4 text-blue-500" />
                    {item}
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>
      </section>

    </div>
  );
}
