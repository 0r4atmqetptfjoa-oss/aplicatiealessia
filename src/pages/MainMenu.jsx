import React, { useState, useEffect, useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { useAppStore } from '../store/appStore.js';
import MagicButton from '../components/ui/MagicButton.jsx';
import SettingsModal from '../components/ui/SettingsModal.jsx';
import { t } from '../i18n/index.js';
import PerfGuard from '../components/util/PerfGuard.jsx';
// Import crown and gem assets.  These PNGs were generated in the content phase
// and live in the assets folder.  Each gem represents a completed activity.
import crownEmpty from '../assets/crown-empty.png';
import gemRed from '../assets/gem-red.png';
import gemGreen from '../assets/gem-green.png';
import gemBlue from '../assets/gem-blue.png';
import gemPurple from '../assets/gem-purple.png';
import gemYellow from '../assets/gem-yellow.png';
import starImg from '../assets/Asset_Pack/progress/star.png';

// Placeholder princess component.  In a real implementation this would
// import and animate a glTF model of Princess Alessia.  For now it renders
// a simple rotating cylinder to suggest her presence.
function Princess() {
  const ref = useRef();
  useFrame((state, delta) => {
    if (ref.current) {
      ref.current.rotation.y += delta * 0.5;
    }
  });
  return (
    <mesh ref={ref} position={[0, -1, 0]}>
      <cylinderGeometry args={[0.5, 0.5, 2, 32]} />
      <meshStandardMaterial color="#f3b0c3" />
    </mesh>
  );
}

// Simple rain particle system rendered when isRaining is true.  It spawns
// dozens of small spheres falling from above and resets them when they
// reach the ground.  This effect gives the illusion of rain in the scene.
function RainParticles() {
  const group = useRef();
  const count = 100;
  // Initialize an array of random positions for the raindrops
  const positions = useRef(
    Array.from({ length: count }, () => [
      (Math.random() - 0.5) * 10,
      Math.random() * 5 + 2,
      (Math.random() - 0.5) * 10,
    ])
  );
  useFrame((state, delta) => {
    positions.current.forEach((pos) => {
      pos[1] -= delta * 5; // fall speed
      if (pos[1] < -1) pos[1] = Math.random() * 5 + 2;
    });
    if (group.current) {
      // Update mesh positions from array
      group.current.children.forEach((mesh, i) => {
        mesh.position.set(...positions.current[i]);
      });
    }
  });
  return (
    <group ref={group}>
      {positions.current.map((pos, idx) => (
        <mesh key={idx} position={pos}>
          <sphereGeometry args={[0.05, 8, 8]} />
          <meshStandardMaterial color="#9ec9eb" transparent opacity={0.8} />
        </mesh>
      ))}
    </group>
  );
}

export default function MainMenu() {
  const completedActivities = useAppStore((state) => state.completedActivities);
  const dailyQuest = useAppStore((state) => state.dailyQuest);
  const setDailyQuest = useAppStore((state) => state.setDailyQuest);
  const completeDailyQuest = useAppStore((state) => state.completeDailyQuest);
  const setCurrentPage = useAppStore((state) => state.setCurrentPage);
  // Time-of-day state to update sky and lighting.  Update every minute.
  const [now, setNow] = useState(new Date());
  useEffect(() => {
    const interval = setInterval(() => setNow(new Date()), 60 * 1000);
    return () => clearInterval(interval);
  }, []);
  // Occasional rain toggle.
  const [isRaining, setIsRaining] = useState(false);
  useEffect(() => {
    const interval = setInterval(() => {
      if (Math.random() < 0.1) {
        setIsRaining(true);
        setTimeout(() => setIsRaining(false), 8000);
      }
    }, 30000);
    return () => clearInterval(interval);
  }, []);
  // Determine sky color and light intensity from current hour.
  const hour = now.getHours();
  let skyColor = '#87cefa';
  let lightIntensity = 1;
  if (hour >= 6 && hour < 18) {
    skyColor = '#87cefa';
    lightIntensity = 1;
  } else if (hour >= 18 && hour < 20) {
    skyColor = '#fca85d';
    lightIntensity = 0.6;
  } else {
    skyColor = '#0d1b2a';
    lightIntensity = 0.2;
  }
  // List of gem images in the order they should appear.
  const gemImages = [gemRed, gemGreen, gemBlue, gemPurple, gemYellow];
  // Parental gate modal visibility.
  const [settingsOpen, setSettingsOpen] = useState(false);

  // When the component mounts, ensure there is a daily quest set for today.
  useEffect(() => {
    // Save the quest date in localStorage to prevent reassigning on refresh.
    const today = new Date().toDateString();
    const savedDate = localStorage.getItem('questDate');
    if (savedDate !== today || !dailyQuest.id) {
      // Simple quest: encourage child to play any activity (we use ID 'general').
      const newQuest = { id: 'general', completed: false };
      setDailyQuest(newQuest);
      localStorage.setItem('questDate', today);
    }
  }, [dailyQuest.id, setDailyQuest]);

  // When an activity completes that matches the quest ID, mark the quest completed.
  useEffect(() => {
    if (!dailyQuest.completed && dailyQuest.id) {
      if (dailyQuest.id === 'general' && completedActivities.length > 0) {
        completeDailyQuest();
      }
      // Additional quest types can be handled here.
    }
  }, [completedActivities, dailyQuest, completeDailyQuest]);

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%' }}>
      <PerfGuard onDecline={() => setIsRaining(false)} onRecover={() => {}}>
        {(degraded) => (
          <Canvas
            style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%' }}
            camera={{ position: [0, 2, 6], fov: 60 }}
          >
            <color attach="background" args={[skyColor]} />
            <ambientLight intensity={0.3} />
            <directionalLight
              position={[5, 10, 5]}
              intensity={lightIntensity}
              color="#ffffff"
              castShadow
            />
            <Princess />
            {/* Only show rain if not degraded */}
            {isRaining && !degraded && <RainParticles />}
          </Canvas>
        )}
      </PerfGuard>
      {/* Crown UI */}
      <div
        style={{
          position: 'absolute',
          top: '20px',
          left: '20px',
          width: '140px',
          height: '80px',
          zIndex: 10,
        }}
      >
        <img src={crownEmpty} alt="Coroană" style={{ width: '100%', height: 'auto' }} />
        {gemImages.map((src, index) => {
          const leftOffset = 20 + index * 20;
          return (
            <img
              key={index}
              src={src}
              alt="Nestemată"
              style={{
                position: 'absolute',
                top: '18px',
                left: `${leftOffset}px`,
                width: '20px',
                height: '20px',
                opacity: index < completedActivities.length ? 1 : 0.2,
              }}
            />
          );
        })}
        {/* Show a star when the daily quest is completed */}
        {dailyQuest.completed && (
          <img
            src={starImg}
            alt="Stea"
            style={{ position: 'absolute', top: '-10px', left: '100px', width: '24px', height: '24px' }}
          />
        )}
      </div>
      {/* Daily quest message */}
      <div
        style={{ position: 'absolute', top: '110px', left: '20px', color: '#fff', zIndex: 10 }}
      >
        {!dailyQuest.completed ? (
          <p>{t('dailyQuest')}: Joacă o activitate astăzi!</p>
        ) : (
          <p>{t('questCompleted')}</p>
        )}
      </div>
      {/* Navigation buttons */}
      <div
        style={{
          position: 'absolute',
          bottom: '40px',
          left: '50%',
          transform: 'translateX(-50%)',
          display: 'flex',
          gap: '1rem',
          zIndex: 10,
        }}
      >
        <MagicButton onClick={() => setCurrentPage('instruments')}>{t('instruments')}</MagicButton>
        <MagicButton onClick={() => setCurrentPage('sounds')}>{t('sounds')}</MagicButton>
        <MagicButton onClick={() => setCurrentPage('stories')}>{t('stories')}</MagicButton>
        <MagicButton onClick={() => setCurrentPage('songs')}>{t('songs')}</MagicButton>
        <MagicButton onClick={() => setCurrentPage('games')}>{t('games')}</MagicButton>
      </div>
      {/* Parental gate button */}
      <div
        style={{ position: 'absolute', top: '20px', right: '20px', zIndex: 10 }}
      >
        <MagicButton onClick={() => setSettingsOpen(true)}>{t('settings')}</MagicButton>
      </div>
      {settingsOpen && <SettingsModal onClose={() => setSettingsOpen(false)} />}
    </div>
  );
}
    </div>
  );
}