import React from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { ArrowRight } from 'lucide-react';

const PRODUCT_CATALOG = [
  {
    id: 'visiting-cards',
    title: 'Premium Visiting Cards',
    description: '300+ GSM art board with matte, gloss, or spot UV finishes. Perfect for corporate networking.',
    price: 'Starting at ₹299 / 100 qty',
    badge: 'Best Seller',
    imageBg: 'bg-blue-50'
  },
  {
    id: 'flex-banners',
    title: 'Large Format Flex & Banners',
    description: 'High-durability Star Flex material. Weather-resistant prints for outdoor advertising.',
    price: 'Starting at ₹15 / sq.ft',
    badge: null,
    imageBg: 'bg-indigo-50'
  },
  {
    id: 'standees',
    title: 'Roll-up Standees',
    description: 'Portable, lightweight aluminum base with high-resolution non-tearable media print.',
    price: 'Starting at ₹1,499',
    badge: 'Events',
    imageBg: 'bg-slate-100'
  }
];

export default function Products() {
  return (
    <section className="py-24 bg-white w-full">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Section Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-16 gap-6">
          <div className="max-w-2xl">
            <h2 className="text-3xl md:text-4xl font-bold text-slate-900 mb-4">
              Professional Print Catalog
            </h2>
            <p className="text-lg text-slate-600">
              Industry-standard materials combined with high-precision printing technology. Select a product to configure specifications.
            </p>
          </div>
          <Link 
            href="/products" 
            className="group flex items-center gap-2 text-blue-600 font-semibold hover:text-blue-700 transition-colors"
          >
            View Full Catalog
            <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
          </Link>
        </div>

        {/* Product Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {PRODUCT_CATALOG.map((product) => (
            <Link 
              key={product.id} 
              href={`/products/${product.id}`}
              className="group flex flex-col bg-white rounded-2xl border border-slate-200 overflow-hidden hover:shadow-xl transition-all duration-300 hover:-translate-y-1"
            >
              {/* Product Image Area Placeholder */}
              <div className={`w-full h-64 ${product.imageBg} relative flex items-center justify-center p-6`}>
                {product.badge && (
                  <span className="absolute top-4 left-4 bg-white px-3 py-1 text-xs font-bold text-slate-900 rounded-full shadow-sm">
                    {product.badge}
                  </span>
                )}
                <div className="w-full h-full border-2 border-dashed border-slate-300/50 rounded-xl flex items-center justify-center">
                  <span className="text-slate-400 font-medium text-sm">Product Mockup Area</span>
                </div>
              </div>
              
              {/* Product Details */}
              <div className="p-6 flex flex-col flex-grow">
                <h3 className="text-xl font-bold text-slate-900 mb-2 group-hover:text-blue-600 transition-colors">
                  {product.title}
                </h3>
                <p className="text-slate-600 text-sm leading-relaxed mb-6 flex-grow">
                  {product.description}
                </p>
                <div className="flex items-center justify-between mt-auto pt-4 border-t border-slate-100">
                  <span className="font-semibold text-slate-900">{product.price}</span>
                  <div className="w-8 h-8 rounded-full bg-slate-50 flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-colors">
                    <ArrowRight className="w-4 h-4" />
                  </div>
                </div>
              </div>
            </Link>
          ))}
        </div>

      </div>
    </section>
  );
}
