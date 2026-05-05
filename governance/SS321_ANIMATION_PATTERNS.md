# SS321 Animation Patterns — Locked May 5, 2026

## Pattern 1: The "21" Spin Animation
File: src/pages/Billboard.tsx
Trigger: useRef on <span>, useEffect with setTimeout + setInterval
Timing: First fire at 1000ms, repeat every 15000ms (15s)
Duration: 1584ms total
Easing: cubic-bezier(0.34, 1.56, 0.64, 1) (bouncy overshoot)

Keyframes (Web Animations API):
  { transform: 'translateY(0px) rotate(0deg) scale(1)', color: '#facc15' }
  { transform: 'translateY(-40px) rotate(180deg) scale(2.1)', color: '#a855f7', offset: 0.55 }
  { transform: 'translateY(-40px) rotate(360deg) scale(2.1)', color: '#facc15', offset: 0.83 }
  { transform: 'translateY(0px) rotate(360deg) scale(1)', color: '#facc15' }

Colors: gold (#facc15) -> electric purple (#a855f7) -> gold (#facc15)
Effect: floats up 40px, spins 360deg, scales to 2.1x at peak, returns
Use for: any number/badge that needs to grab attention periodically

---

## Pattern 2: The "s" Morph Pill Animation
File: src/pages/Billboard.tsx
Trigger: useState(false) toggled by useEffect cycle
Timing: First fire at 3000ms, repeat every 18000ms (18s)
Hold duration: 3000ms (3s expanded), then collapse
Transition: CSS transition-all duration-500

Collapsed state classes:
  text-[18px] -top-2 right-0 font-medium font-sans tracking-tight
  text-electric-purple leading-none

Expanded state classes:
  text-xs -top-6 -right-20 whitespace-nowrap
  bg-electric-purple/10 px-2 py-0.5 rounded-full
  border border-electric-purple/30

Content: collapsed = single character label, expanded = full phrase
Colors: electric-purple throughout
Effect: small label morphs into pill showing full meaning, holds, collapses
Use for: any abbreviation/acronym that should periodically reveal its meaning

---

## Reuse Notes
- Both patterns respect prefers-reduced-motion if added
- Both use cleanup (clearTimeout + clearInterval) in useEffect return
- Pattern 1 requires Web Animations API (supported all modern browsers)
- Pattern 2 is pure CSS + React state (works everywhere)
- Combine both on same element for layered animation effects