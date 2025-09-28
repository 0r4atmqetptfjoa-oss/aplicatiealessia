import React, { useState, useEffect } from 'react';

// Frequencies for a C‑major scale one octave higher (C5–B5).  These give
// a bright, bell-like tone when played via the Web Audio API.
const BARS = [
  { label: 'C', freq: 523.25 },
  { label: 'D', freq: 587.33 },
  { label: 'E', freq: 659.25 },
  { label: 'F', freq: 698.46 },
  { label: 'G', freq: 783.99 },
  { label: 'A', freq: 880.0 },
  { label: 'B', freq: 987.77 },
  { label: 'C', freq: 1046.5 },
];

function playBar(freq) {
  const context = new (window.AudioContext || window.webkitAudioContext)();
  const oscillator = context.createOscillator();
  const gain = context.createGain();
  oscillator.type = 'square';
  oscillator.frequency.setValueAtTime(freq, context.currentTime);
  oscillator.connect(gain);
  gain.connect(context.destination);
  gain.gain.setValueAtTime(0.2, context.currentTime);
  gain.gain.exponentialRampToValueAtTime(0.001, context.currentTime + 0.5);
  oscillator.start();
  oscillator.stop(context.currentTime + 0.5);
}

/**
 * Xylophone instrument component.
 *
 * Renders eight colourful bars corresponding to notes of a scale.  Clicking
 * a bar plays a tone.  A one-minute timer starts on first interaction
 * and triggers onComplete when finished.
 */
export default function Xylophone({ onComplete }) {
  const [started, setStarted] = useState(false);

  useEffect(() => {
    if (!started) return;
    const timer = setTimeout(() => {
      if (onComplete) onComplete();
    }, 60 * 1000);
    return () => clearTimeout(timer);
  }, [started, onComplete]);

  const handleBar = (freq) => {
    playBar(freq);
    if (!started) setStarted(true);
  };

  const colours = ['#e74c3c', '#e67e22', '#f1c40f', '#2ecc71', '#1abc9c', '#3498db', '#9b59b6', '#8e44ad'];

  return (
    <div style={{ display: 'flex', justifyContent: 'center', gap: '6px', marginTop: '2rem' }}>
      {BARS.map(({ label, freq }, idx) => (
        <div
          key={idx}
          onClick={() => handleBar(freq)}
          style={{
            width: '40px',
            height: `${100 + idx * 10}px`,
            background: colours[idx % colours.length],
            borderRadius: '4px',
            display: 'flex',
            alignItems: 'flex-end',
            justifyContent: 'center',
            cursor: 'pointer',
            userSelect: 'none',
          }}
        >
          <span style={{ fontSize: '0.7rem', marginBottom: '4px', color: '#fff' }}>{label}</span>
        </div>
      ))}
    </div>
  );
}