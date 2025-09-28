// src/hooks/useAudioUnlock.js
import { useEffect, useRef } from 'react';

/** Unlock a WebAudio context on first user interaction (Android WebView autoplay policies). */
export function useAudioUnlock() {
  const ctxRef = useRef(null);
  useEffect(() => {
    const Ctx = window.AudioContext || window.webkitAudioContext;
    if (!Ctx) return;
    const ctx = new Ctx();
    ctxRef.current = ctx;
    const unlock = () => { ctx.resume?.(); remove(); };
    const remove = () => {
      window.removeEventListener('touchstart', unlock);
      window.removeEventListener('pointerdown', unlock);
    };
    window.addEventListener('touchstart', unlock, { once: true });
    window.addEventListener('pointerdown', unlock, { once: true });
    return () => { try { ctx.close(); } catch {} remove(); };
  }, []);
  return ctxRef;
}
