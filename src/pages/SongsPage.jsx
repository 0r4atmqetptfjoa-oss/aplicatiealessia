import React, { useState, useEffect, useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { useAppStore } from '../store/appStore.js';
import MagicButton from '../components/ui/MagicButton.jsx';
import { playSongs, carols } from '../data/songsData.js';

// Placeholder dancing Alessia using a cylinder.  When isPlaying is true the
// model gently moves up and down to simulate dancing.  The theme prop
// influences lighting and background colour to differentiate between
// play songs and colinde.
function DancingScene({ isPlaying, theme }) {
  const background = theme === 'carol' ? '#0a1931' : '#ffe5b4';
  const accent = theme === 'carol' ? '#f5f5f5' : '#f76c6c';
  function Alessia() {
    const ref = useRef();
    useFrame((state, delta) => {
      if (ref.current && isPlaying) {
        ref.current.position.y = Math.sin(state.clock.elapsedTime * 2) * 0.3 - 1;
        ref.current.rotation.y += delta * 0.5;
      }
    });
    return (
      <mesh ref={ref} position={[0, -1, 0]} castShadow>
        <cylinderGeometry args={[0.5, 0.5, 2, 32]} />
        <meshStandardMaterial color={accent} />
      </mesh>
    );
  }
  return (
    <Canvas
      style={{ width: '100%', height: '300px' }}
      camera={{ position: [0, 1, 5], fov: 60 }}
      shadows
    >
      <color attach="background" args={[background]} />
      <ambientLight intensity={0.4} />
      <directionalLight position={[5, 10, 5]} intensity={0.6} castShadow />
      <Alessia />
    </Canvas>
  );
}

/**
 * SongsPage displays two categories of music (cântece de joacă şi colinde),
 * allows selection of a song, and plays a simple animation representing
 * Alessia dancing during playback.  Upon completion of the song (after
 * 30 seconds in this stub implementation), the song's ID is recorded in
 * completedActivities via the global store.
 */
export default function SongsPage() {
  const addCompletedActivity = useAppStore((state) => state.addCompletedActivity);
  const setCurrentPage = useAppStore((state) => state.setCurrentPage);
  const [category, setCategory] = useState(null); // 'play' or 'carol'
  const [song, setSong] = useState(null);
  const [isPlaying, setIsPlaying] = useState(false);

  const handleCategory = (cat) => {
    setCategory(cat);
    setSong(null);
    setIsPlaying(false);
  };

  const startSong = (s) => {
    setSong(s);
    setIsPlaying(true);
    const timer = setTimeout(() => {
      addCompletedActivity(`song-${s.id}`);
      setIsPlaying(false);
      setSong(null);
    }, 30 * 1000);
    return () => clearTimeout(timer);
  };

  const renderCategoryMenu = () => (
    <div style={{ textAlign: 'center' }}>
      <h2>Alege un tip de cântec</h2>
      <div style={{ display: 'flex', justifyContent: 'center', gap: '1rem', marginTop: '1rem' }}>
        <MagicButton onClick={() => handleCategory('play')}>Cântece de joacă</MagicButton>
        <MagicButton onClick={() => handleCategory('carol')}>Colinde</MagicButton>
      </div>
      <div style={{ marginTop: '2rem' }}>
        <MagicButton onClick={() => setCurrentPage('mainMenu')}>Înapoi la meniu</MagicButton>
      </div>
    </div>
  );

  const renderSongList = (list) => (
    <div style={{ textAlign: 'center' }}>
      <h2>{category === 'play' ? 'Cântece de joacă' : 'Colinde'}</h2>
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', marginTop: '1rem' }}>
        {list.map((item) => (
          <MagicButton key={item.id} onClick={() => startSong(item)} style={{ margin: '4px 0' }}>
            {item.title}
          </MagicButton>
        ))}
      </div>
      <div style={{ marginTop: '2rem' }}>
        <MagicButton onClick={() => handleCategory(null)}>Înapoi</MagicButton>
      </div>
    </div>
  );

  const renderPlayer = (songObj) => (
    <div style={{ textAlign: 'center' }}>
      <h2>{songObj.title}</h2>
      <p style={{ width: '80%', margin: '0.5rem auto', color: '#ccc' }}>{songObj.description}</p>
      <DancingScene isPlaying={isPlaying} theme={category === 'carol' ? 'carol' : 'play'} />
      <div style={{ marginTop: '1rem' }}>
        {isPlaying ? (
          <MagicButton onClick={() => {
            setIsPlaying(false);
            setSong(null);
          }}>Opreşte cântecul</MagicButton>
        ) : (
          <MagicButton onClick={() => startSong(songObj)}>Reporneşte</MagicButton>
        )}
      </div>
    </div>
  );

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', paddingTop: '6rem' }}>
      {category === null && renderCategoryMenu()}
      {category !== null && song === null && renderSongList(category === 'play' ? playSongs : carols)}
      {song && renderPlayer(song)}
    </div>
  );
}