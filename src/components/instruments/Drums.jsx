import React, { useState, useEffect } from 'react';

// Frequencies for drum-like tones.  Lower frequencies mimic bass drums
// while higher mimic snare or toms.  Using the Web Audio API these tones
// sound percussive when envelopes are applied via gain ramps.
const DRUMS = [
  { label: 'Kick', freq: 100 },
  { label: 'Snare', freq: 200 },
  { label: 'Hi-Hat', freq: 400 },
];

function playDrum(freq, mute = false) {
  if (mute) return;
  const context = new (window.AudioContext || window.webkitAudioContext)();
  const oscillator = context.createOscillator();
  const gain = context.createGain();
  oscillator.type = 'triangle';
  oscillator.frequency.setValueAtTime(freq, context.currentTime);
  oscillator.connect(gain);
  gain.connect(context.destination);
  // Create a quick decay envelope for a percussive sound
  gain.gain.setValueAtTime(0.4, context.currentTime);
  gain.gain.exponentialRampToValueAtTime(0.001, context.currentTime + 0.3);
  oscillator.start();
  oscillator.stop(context.currentTime + 0.3);
}

/**
 * Drums instrument component.
 *
 * Renders three pads corresponding to kick, snare and hi‑hat.  Clicking a pad
 * triggers a percussive tone.  A one-minute timer starts on first
 * interaction and fires the onComplete callback when finished.
 */
import { useAppStore } from '../../store/appStore.js';

export default function Drums({ onComplete }) {
  const [started, setStarted] = useState(false);
  const globalMute = useAppStore((state) => state.globalMute);

  useEffect(() => {
    if (!started) return;
    const timer = setTimeout(() => {
      if (onComplete) onComplete();
    }, 60 * 1000);
    return () => clearTimeout(timer);
  }, [started, onComplete]);

  const handlePad = (freq) => {
    playDrum(freq, globalMute);
    if (!started) setStarted(true);
  };

  return (
    <div style={{ display: 'flex', justifyContent: 'center', gap: '1rem', marginTop: '2rem' }}>
      {DRUMS.map(({ label, freq }, idx) => (
        <div
          key={idx}
          onClick={() => handlePad(freq)}
          style={{
            width: '80px',
            height: '80px',
            borderRadius: '50%',
            background: '#666',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: '#fff',
            fontWeight: 'bold',
            cursor: 'pointer',
            userSelect: 'none',
          }}
        >
          {label}
        </div>
      ))}
    </div>
  );
}