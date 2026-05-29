// src/components/orders/OrderTimelineTracker.tsx
'use client';

import React from 'react';
import { motion } from 'framer-motion';

interface StepProps {
  label: string;
  isComplete: boolean;
  isActive: boolean;
}

export function OrderTimelineTracker({ currentStatus }: { currentStatus: string }) {
  const roadmapSteps = [
    { label: 'Payment', keys: ['PAYMENT_CONFIRMED', 'DESIGNING', 'DESIGN_APPROVED', 'PRINTING', 'PRINT_COMPLETED', 'SHIPPED', 'DELIVERED'] },
    { label: 'Studio Design', keys: ['DESIGNING', 'DESIGN_APPROVED', 'PRINTING', 'PRINT_COMPLETED', 'SHIPPED', 'DELIVERED'] },
    { label: 'Production Print', keys: ['PRINTING', 'PRINT_COMPLETED', 'SHIPPED', 'DELIVERED'] },
    { label: 'Dispatch Delivery', keys: ['SHIPPED', 'DELIVERED'] }
  ];

  return (
    <div className="w-full bg-white rounded-2xl p-6 border border-slate-100 shadow-sm max-w-md mx-auto">
      <h4 className="text-slate-900 font-semibold mb-4 text-sm tracking-tight">Tracking Progress ID</h4>
      <div className="flex justify-between relative items-center">
        {roadmapSteps.map((step, idx) => {
          const isComplete = step.keys.includes(currentStatus) && currentStatus !== step.keys[0];
          const isActive = currentStatus === step.keys[0] || (idx === 0 && currentStatus === 'PENDING_PAYMENT');
          
          return (
            <div key={idx} className="flex flex-col items-center flex-1 z-10">
              <motion.div 
                initial={{ scale: 0.8 }}
                animate={{ scale: isActive ? 1.1 : 1 }}
                className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs ${
                  isComplete ? 'bg-blue-600 text-white' : isActive ? 'bg-blue-50 text-blue-600 border-2 border-blue-600' : 'bg-slate-100 text-slate-400'
                }`}
              >
                {isComplete ? '✓' : idx + 1}
              </motion.div>
              <span className={`text-[11px] font-medium mt-2 tracking-tight ${isActive ? 'text-blue-600 font-semibold' : 'text-slate-500'}`}>
                {step.label}
              </span>
            </div>
          );
        })}
        <div className="absolute top-4 left-0 right-0 h-[2px] bg-slate-100 -z-0 mx-6" />
      </div>
    </div>
  );
}