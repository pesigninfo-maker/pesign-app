import React from 'react';
import Link from 'next/link';
import { Facebook, Twitter, Instagram, Linkedin, Mail, Phone, MapPin } from 'lucide-react';

export default function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-white border-t border-slate-200 pt-16 pb-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
          
          {/* Brand Column */}
          <div className="col-span-1 md:col-span-1">
            <Link href="/" className="inline-block mb-6">
              <span className="font-extrabold text-2xl tracking-tight text-slate-900">Pesign</span>
            </Link>
            <p className="text-slate-500 text-sm leading-relaxed mb-6">
              India's premier platform for professional graphic design and high-quality printing. Seamless execution from digital canvas to physical delivery.
            </p>
            <div className="flex space-x-4">
              <a href="#" className="text-slate-400 hover:text-blue-600 transition-colors">
                <Facebook className="w-5 h-5" />
              </a>
              <a href="#" className="text-slate-400 hover:text-blue-600 transition-colors">
                <Twitter className="w-5 h-5" />
              </a>
              <a href="#" className="text-slate-400 hover:text-blue-600 transition-colors">
                <Instagram className="w-5 h-5" />
              </a>
              <a href="#" className="text-slate-400 hover:text-blue-600 transition-colors">
                <Linkedin className="w-5 h-5" />
              </a>
            </div>
          </div>

          {/* Platform Links */}
          <div>
            <h4 className="font-semibold text-slate-900 mb-6">Platform</h4>
            <ul className="space-y-4">
              <li><Link href="/products/visiting-cards" className="text-sm text-slate-600 hover:text-blue-600 transition-colors">Visiting Cards</Link></li>
              <li><Link href="/products/banners" className="text-sm text-slate-600 hover:text-blue-600 transition-colors">Flex & Banners</Link></li>
              <li><Link href="/products/corporate" className="text-sm text-slate-600 hover:text-blue-600 transition-colors">Corporate Gifting</Link></li>
              <li><Link href="/design-services" className="text-sm text-slate-600 hover:text-blue-600 transition-colors">Hire a Designer</Link></li>
            </ul>
          </div>

          {/* Company Links */}
          <div>
            <h4 className="font-semibold text-slate-900 mb-6">Company</h4>
            <ul className="space-y-4">
              <li><Link href="/about" className="text-sm text-slate-600 hover:text-blue-600 transition-colors">About Us</Link></li>
              <li><Link href="/vendors" className="text-sm text-slate-600 hover:text-blue-600 transition-colors">Partner as a Printer</Link></li>
              <li><Link href="/careers" className="text-sm text-slate-600 hover:text-blue-600 transition-colors">Careers</Link></li>
              <li><Link href="/blog" className="text-sm text-slate-600 hover:text-blue-600 transition-colors">Print Guide Blog</Link></li>
            </ul>
          </div>

          {/* Contact Information */}
          <div>
            <h4 className="font-semibold text-slate-900 mb-6">Contact</h4>
            <ul className="space-y-4">
              <li className="flex items-start gap-3 text-sm text-slate-600">
                <MapPin className="w-5 h-5 text-blue-600 shrink-0" />
                <span>Agartala, Tripura<br />India</span>
              </li>
              <li className="flex items-center gap-3 text-sm text-slate-600">
                <Phone className="w-5 h-5 text-blue-600 shrink-0" />
                <span>+91 (Support Line)</span>
              </li>
              <li className="flex items-center gap-3 text-sm text-slate-600">
                <Mail className="w-5 h-5 text-blue-600 shrink-0" />
                <span>support@pesign.in</span>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="border-t border-slate-100 pt-8 flex flex-col md:flex-row justify-between items-center gap-4">
          <p className="text-sm text-slate-500">
            © {currentYear} Pesign Platform. All rights reserved.
          </p>
          <div className="flex space-x-6 text-sm text-slate-500">
            <Link href="/privacy" className="hover:text-blue-600 transition-colors">Privacy Policy</Link>
            <Link href="/terms" className="hover:text-blue-600 transition-colors">Terms of Service</Link>
            <Link href="/refunds" className="hover:text-blue-600 transition-colors">Refund Policy</Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
