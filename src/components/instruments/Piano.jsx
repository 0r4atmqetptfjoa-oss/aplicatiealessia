import React, { useState, useEffect } from 'react';

// Frequencies for a simple C major scale (C4–B4).  These are used to
// synthesize tones via the Web Audio API when keys are pressed.
const NOTES = [
  { label: 'C', freq: 261.63 },
  { label: 'D', freq: 293.66 },
  { label: 'E', freq: 329.63 },
  { label: 'F', freq: 349.23 },
  { label: 'G', freq: 392.0 },
  { label: 'A', freq: 440.0 },
  { label: 'B', freq: 493.88 },
];

// Helper to play a short tone at the given frequency.  Each call creates a
// new AudioContext to avoid stateful issues across multiple notes.  The
// oscillator stops after a brief duration.
function playTone(freq) {
  const context = new (window.AudioContext || window.webkitAudioContext)();
  const oscillator = context.createOscillator();
  const gain = context.createGain();
  oscillator.type = 'sine';
  oscillator.frequency.setValueAtTime(freq, context.currentTime);
  oscillator.connect(gain);
  gain.connect(context.destination);
  gain.gain.setValueAtTime(0.2, context.currentTime);
  oscillator.start();
  oscillator.stop(context.currentTime + 0.4);
}

/**
 * Piano instrument component.
 *
 * Renders a row of keys corresponding to a C-major scale.  When a key is
 * clicked the appropriate tone plays.  Once the user begins interacting
 * with the piano, a one-minute timer starts; when the timer expires the
 * provided onComplete callback is invoked to mark the activity as finished.
 */
export default function Piano({ onComplete }) {
  const [started, setStarted] = useState(false);

  useEffect(() => {
    if (!started) return;
    const timer = setTimeout(() => {
      if (onComplete) onComplete();
    }, 60 * 1000);
    return () => clearTimeout(timer);
  }, [started, onComplete]);

  const handleKeyPress = (freq) => {
    playTone(freq);
    if (!started) setStarted(true);
  };

  return (
    <div style={{ display: 'flex', justifyContent: 'center', gap: '4px', marginTop: '2rem' }}>
      {NOTES.map(({ label, freq }, idx) => (
        <div
          key={idx}
          onClick={() => handleKeyPress(freq)}
          style={{
            width: '40px',
            height: '150px',
            background: '#fff',
            border: '1px solid #333',
            borderRadius: '4px',
            boxSizing: 'border-box',
            display: 'flex',
            alignItems: 'flex-end',
            justifyContent: 'center',
            cursor: 'pointer',
            userSelect: 'none',
          }}
        >
          <span style={{ fontSize: '0.7rem', marginBottom: '4px', color: '#333' }}>{label}</span>
        </div>
      ))}
    </div>
  );
}