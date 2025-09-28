import React, { useState } from 'react';
import { useAppStore } from '../store/appStore.js';
import MagicButton from '../components/ui/MagicButton.jsx';
import Piano from '../components/instruments/Piano.jsx';
import Drums from '../components/instruments/Drums.jsx';
import Xylophone from '../components/instruments/Xylophone.jsx';

/**
 * InstrumentsPage provides a sub-menu for selecting between several musical
 * instruments.  Each instrument is implemented as its own component that
 * handles playing sounds and reporting completion after a set duration.
 * Ambient audio can be added here in future missions; for now this page
 * focuses on user interaction and progression tracking.
 */
export default function InstrumentsPage() {
  const addCompletedActivity = useAppStore((state) => state.addCompletedActivity);
  const setCurrentPage = useAppStore((state) => state.setCurrentPage);
  const [selected, setSelected] = useState(null);

  // Handler for when an instrument session completes.  Assign a unique
  // identifier so that the crown can display a gem upon returning to the
  // main menu.  After marking completion, return to the instrument menu.
  const handleComplete = (id) => {
    addCompletedActivity(id);
    setSelected(null);
  };

  // Render instrument component based on selection
  const renderInstrument = () => {
    switch (selected) {
      case 'piano':
        return <Piano onComplete={() => handleComplete('instrument-piano')} />;
      case 'drums':
        return <Drums onComplete={() => handleComplete('instrument-drums')} />;
      case 'xylophone':
        return <Xylophone onComplete={() => handleComplete('instrument-xylophone')} />;
      default:
        return null;
    }
  };

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', paddingTop: '6rem' }}>
      {/* If no instrument is selected, show the sub-menu */}
      {selected === null && (
        <div style={{ textAlign: 'center' }}>
          <h2>Alege un instrument</h2>
          <div style={{ display: 'flex', justifyContent: 'center', gap: '1rem', marginTop: '1rem' }}>
            <MagicButton onClick={() => setSelected('piano')}>Pian</MagicButton>
            <MagicButton onClick={() => setSelected('drums')}>Tobe</MagicButton>
            <MagicButton onClick={() => setSelected('xylophone')}>Xilofon</MagicButton>
          </div>
          <div style={{ marginTop: '2rem' }}>
            <MagicButton onClick={() => setCurrentPage('mainMenu')}>Înapoi la meniu</MagicButton>
          </div>
        </div>
      )}
      {/* If an instrument is selected, display it and a back button */}
      {selected !== null && (
        <div style={{ textAlign: 'center' }}>
          <h2>{selected === 'piano' ? 'Pian' : selected === 'drums' ? 'Tobe' : 'Xilofon'}</h2>
          {renderInstrument()}
          <div style={{ marginTop: '2rem' }}>
            <MagicButton onClick={() => setSelected(null)}>Înapoi</MagicButton>
          </div>
        </div>
      )}
    </div>
  );
}