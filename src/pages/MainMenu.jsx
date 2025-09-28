import React, { useEffect, useMemo, useState } from 'react';
import { Canvas } from '@react-three/fiber';
import AnimatedBackground from '../components/scenes/AnimatedBackground.jsx';
import MagicButton from '../components/ui/MagicButton.jsx';
import SettingsModal from '../components/ui/SettingsModal.jsx';
import { useAppStore } from '../store/appStore.js';

// Crown & gems (keep these paths as in your repo)
import crownEmpty from '../assets/crown-empty.png';
import gemRed from '../assets/gem-red.png';
import gemGreen from '../assets/gem-green.png';
import gemBlue from '../assets/gem-blue.png';
import gemPurple from '../assets/gem-purple.png';
import gemYellow from '../assets/gem-yellow.png';

// Safe MainMenu that avoids JSX parser pitfalls.
// - No '//' inside JSX (uses {/* ... */})
// - All conditional blocks wrapped in parentheses
// - Balanced parentheses/braces everywhere

export default function MainMenu() {
  const { setCurrentPage, completedActivities = [] } = useAppStore();
  const [showSettings, setShowSettings] = useState(false);

  // Simple gem layout on crown (Up to 5 gems; extra are ignored visually)
  const gemImages = [gemRed, gemGreen, gemBlue, gemPurple, gemYellow];
  const gemsToShow = useMemo(() => {
    const n = Math.min(completedActivities.length || 0, 5);
    return gemImages.slice(0, n);
  }, [completedActivities]);

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden' }}>
      {/* 3D / animated background layer */}
      <div style={{ position: 'absolute', inset: 0 }}>
        <Canvas camera={{ position: [0, 1.2, 3.5], fov: 50 }}>
          {/* If you had lights/scene, keep them minimal and safe */}
          <ambientLight intensity={0.6} />
          <directionalLight position={[3, 5, 2]} intensity={1.1} />
          {/* Background procedural scene */}
          <AnimatedBackground />
        </Canvas>
      </div>

      {/* Top bar buttons */}
      <div style={{
        position: 'absolute', top: 16, left: 16, right: 16,
        display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12
      }}>
        <MagicButton onClick={() => setCurrentPage('stories')}>Povești</MagicButton>
        <div style={{ display: 'flex', gap: 12 }}>
          <MagicButton onClick={() => setCurrentPage('sounds')}>Sunete</MagicButton>
          <MagicButton onClick={() => setCurrentPage('songs')}>Cântece</MagicButton>
          <MagicButton onClick={() => setCurrentPage('games')}>Jocuri</MagicButton>
          <MagicButton onClick={() => setCurrentPage('instruments')}>Instrumente</MagicButton>
        </div>
        <MagicButton onClick={() => setShowSettings(true)}>Setări</MagicButton>
      </div>

      {/* Crown with gems (progress) */}
      <div style={{ position: 'absolute', top: 16, right: 16, width: 140, height: 110 }}>
        <div style={{ position: 'absolute', inset: 0 }}>
          <img src={crownEmpty} alt="Coroană" style={{ width: '100%', height: '100%', objectFit: 'contain' }} />
        </div>
        {/* Place gems on top */}
        <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none' }}>
          <div style={{
            position: 'absolute', left: 8, top: 45, width: 24, height: 24
          }}>{gemsToShow[0] && <img src={gemsToShow[0]} alt="gem" style={{ width: '100%', height: '100%' }} />}</div>
          <div style={{
            position: 'absolute', left: 38, top: 22, width: 24, height: 24
          }}>{gemsToShow[1] && <img src={gemsToShow[1]} alt="gem" style={{ width: '100%', height: '100%' }} />}</div>
          <div style={{
            position: 'absolute', left: 58, top: 10, width: 24, height: 24
          }}>{gemsToShow[2] && <img src={gemsToShow[2]} alt="gem" style={{ width: '100%', height: '100%' }} />}</div>
          <div style={{
            position: 'absolute', left: 80, top: 22, width: 24, height: 24
          }}>{gemsToShow[3] && <img src={gemsToShow[3]} alt="gem" style={{ width: '100%', height: '100%' }} />}</div>
          <div style={{
            position: 'absolute', left: 110, top: 45, width: 24, height: 24
          }}>{gemsToShow[4] && <img src={gemsToShow[4]} alt="gem" style={{ width: '100%', height: '100%' }} />}</div>
        </div>
      </div>

      {/* Center panel (title / CTA) */}
      <div style={{
        position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center'
      }}>
        <div style={{
          background: 'rgba(255,255,255,0.7)',
          padding: 24, borderRadius: 16, backdropFilter: 'blur(6px)',
          boxShadow: '0 8px 24px rgba(0,0,0,0.15)', textAlign: 'center'
        }}>
          <h1 style={{ margin: 0, fontFamily: 'system-ui, sans-serif' }}>Lumea Alesiei</h1>
          <p style={{ marginTop: 8, marginBottom: 16 }}>Alege o lume și pornește aventura!</p>
          <div style={{ display: 'flex', gap: 12, justifyContent: 'center', flexWrap: 'wrap' }}>
            <MagicButton onClick={() => setCurrentPage('stories')}>Povești</MagicButton>
            <MagicButton onClick={() => setCurrentPage('songs')}>Cântece</MagicButton>
            <MagicButton onClick={() => setCurrentPage('sounds')}>Sunete</MagicButton>
            <MagicButton onClick={() => setCurrentPage('games')}>Jocuri</MagicButton>
            <MagicButton onClick={() => setCurrentPage('instruments')}>Instrumente</MagicButton>
          </div>
        </div>
      </div>

      {showSettings && (
        <SettingsModal onClose={() => setShowSettings(false)} />
      )}
    </div>
  );
}
