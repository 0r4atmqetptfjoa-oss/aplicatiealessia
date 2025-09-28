import React, { useState, useEffect, useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { useAppStore } from '../store/appStore.js';
import MagicButton from '../components/ui/MagicButton.jsx';
import SettingsModal from '../components/ui/SettingsModal.jsx';
// Import crown and gem assets.  These PNGs were generated in the content phase
// and live in the assets folder.  Each gem represents a completed activity.
import crownEmpty from '../assets/crown-empty.png';
import gemRed from '../assets/gem-red.png';
import gemGreen from '../assets/gem-green.png';
import gemBlue from '../assets/gem-blue.png';
import gemPurple from '../assets/gem-purple.png';
import gemYellow from '../assets/gem-yellow.png';

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
  const setCurrentPage = useAppStore((state) => state.setCurrentPage);

  // Track the current time of day; update every minute to allow the
  // background colour and lighting to reflect the real world clock.
  const [now, setNow] = useState(new Date());
  useEffect(() => {
    const interval = setInterval(() => setNow(new Date()), 60 * 1000);
    return () => clearInterval(interval);
  }, []);

  // Optionally start a rain effect occasionally.  We toggle a boolean
  // periodically; when true, a simple particle rain is rendered.
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

  // Derive sky and light properties from the current hour.
  const hour = now.getHours();
  let skyColor = '#87cefa'; // Daytime sky
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

  // List of gem images in the order they should appear in the crown.
  const gemImages = [gemRed, gemGreen, gemBlue, gemPurple, gemYellow];

  // State controlling visibility of the parental gate settings modal
  const [settingsOpen, setSettingsOpen] = useState(false);

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%' }}>
      <Canvas
        style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%' }}
        camera={{ position: [0, 2, 6], fov: 60 }}
      >
        {/* Set the scene background colour based on time of day */}
        <color attach="background" args={[skyColor]} />
        {/* Ambient and directional light to simulate sun/moon */}
        <ambientLight intensity={0.3} />
        <directionalLight
          position={[5, 10, 5]}
          intensity={lightIntensity}
          color="#ffffff"
          castShadow
        />
        {/* Render the princess placeholder */}
        <Princess />
        {/* Optional rain particles: simple instanced spheres falling from above */}
        {isRaining && <RainParticles />}
      </Canvas>
      {/* Crown UI overlay */}
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
        {/* Base crown image */}
        <img src={crownEmpty} alt="Coroană" style={{ width: '100%', height: 'auto' }} />
        {/* Gems positioned relative to the crown.  Adjust offsets to sit nicely
             along the top of the crown image. */}
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
      </div>
      {/* Navigation buttons at the bottom of the screen.  We omit the settings
          button here because the main menu only needs five entries. */}
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
        <MagicButton onClick={() => setCurrentPage('instruments')}>Instrumente</MagicButton>
        <MagicButton onClick={() => setCurrentPage('sounds')}>Sunete</MagicButton>
        <MagicButton onClick={() => setCurrentPage('stories')}>Povești</MagicButton>
        <MagicButton onClick={() => setCurrentPage('songs')}>Cântece</MagicButton>
        <MagicButton onClick={() => setCurrentPage('games')}>Jocuri</MagicButton>
      </div>

      {/* Parental gate button positioned in the top-right corner */}
      <div
        style={{ position: 'absolute', top: '20px', right: '20px', zIndex: 10 }}
      >
        <MagicButton onClick={() => setSettingsOpen(true)}>Poarta părinţilor</MagicButton>
      </div>

      {/* Render the settings modal when activated */}
      {settingsOpen && <SettingsModal onClose={() => setSettingsOpen(false)} />}
    </div>
  );
}