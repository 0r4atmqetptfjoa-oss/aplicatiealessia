import React, { useState } from 'react';
import { useAppStore } from '../../store/appStore.js';
import MagicButton from './MagicButton.jsx';
import { t } from '../../i18n/index.js';

/**
 * SettingsModal implements the parental gate (“Poarta Părinților”).  When
 * opened, it initially presents an arithmetic question to verify that
 * an adult is accessing the settings.  Only after answering correctly
 * are the parental controls revealed.  The modal overlays the entire
 * screen and can be dismissed at any time using the close button.
 *
 * Props:
 *   onClose (function) – callback invoked when the modal should be closed.
 */
export default function SettingsModal({ onClose }) {
  const [stage, setStage] = useState('gate'); // 'gate' or 'settings'
  // Generate a simple arithmetic question (addition of two numbers 3–9)
  const [a] = useState(() => Math.floor(Math.random() * 7) + 3);
  const [b] = useState(() => Math.floor(Math.random() * 7) + 3);
  const correctAnswer = a + b;
  const [input, setInput] = useState('');
  const resetProgress = useAppStore((state) => state.resetProgress);
  const completedActivities = useAppStore((state) => state.completedActivities);
  const pageCounts = useAppStore((state) => state.pageCounts);
  const globalMute = useAppStore((state) => state.globalMute);
  const setGlobalMute = useAppStore((state) => state.setGlobalMute);
  const timeLimit = useAppStore((state) => state.timeLimit);
  const setTimeLimit = useAppStore((state) => state.setTimeLimit);
  // Local form state for time limit input
  const [limitInput, setLimitInput] = useState(timeLimit || '');

  const verify = () => {
    if (parseInt(input, 10) === correctAnswer) {
      setStage('settings');
    } else {
      alert('Răspuns greşit. Încearcă din nou.');
    }
  };

  const modalStyle = {
    position: 'fixed',
    top: 0,
    left: 0,
    width: '100%',
    height: '100%',
    backgroundColor: 'rgba(0,0,0,0.8)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 1000,
  };
  const contentStyle = {
    backgroundColor: '#1e293b',
    padding: '2rem',
    borderRadius: '8px',
    width: '90%',
    maxWidth: '400px',
    color: '#fff',
    textAlign: 'center',
  };
  return (
    <div style={modalStyle}>
      <div style={contentStyle}>
        <h2>Poarta Părinților</h2>
        {stage === 'gate' && (
          <div>
            <p>Te rugăm să rezolvi operaţia pentru a accesa setările:</p>
            <p style={{ fontSize: '1.5rem', margin: '1rem 0' }}>{a} + {b} = ?</p>
            <input
              type="number"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              style={{ padding: '0.5rem', width: '80%', marginBottom: '1rem' }}
            />
            <div style={{ display: 'flex', justifyContent: 'center', gap: '1rem' }}>
              <MagicButton onClick={verify}>Verifică</MagicButton>
              <MagicButton onClick={onClose}>Închide</MagicButton>
            </div>
          </div>
        )}
        {stage === 'settings' && (
          <div>
            <p>{t('totalCompleted')}: {completedActivities.length}</p>
            {/* Analytics: show page visit counts */}
            <div style={{ textAlign: 'left', marginBottom: '1rem' }}>
              <h4>Statistici pagini</h4>
              <ul>
                {Object.entries(pageCounts).map(([page, count]) => (
                  <li key={page}>{page}: {count}</li>
                ))}
              </ul>
            </div>
            {/* Time limit control */}
            <div style={{ marginBottom: '1rem' }}>
              <label>
                {t('timeLimit')}:
                <input
                  type="number"
                  min="0"
                  value={limitInput}
                  onChange={(e) => setLimitInput(e.target.value)}
                  style={{ marginLeft: '0.5rem', padding: '0.25rem', width: '60px' }}
                />
                <MagicButton
                  onClick={() => {
                    const minutes = parseInt(limitInput, 10);
                    if (!isNaN(minutes) && minutes > 0) {
                      setTimeLimit(minutes);
                      alert(`Limita de timp setată la ${minutes} minute.`);
                    } else {
                      setTimeLimit(null);
                      alert('Limită dezactivată.');
                    }
                  }}
                >Aplică</MagicButton>
              </label>
            </div>
            {/* Global mute toggle */}
            <div style={{ marginBottom: '1rem' }}>
              <label>
                <input
                  type="checkbox"
                  checked={globalMute}
                  onChange={(e) => setGlobalMute(e.target.checked)}
                />{' '}
                {t('muteAudio')}
              </label>
            </div>
            {/* Reset progress button */}
            <div style={{ marginBottom: '1rem' }}>
              <MagicButton
                onClick={() => {
                  if (window.confirm('Sigur doreşti să ştergi progresul?')) {
                    resetProgress();
                  }
                }}
              >
                {t('resetProgress')}
              </MagicButton>
            </div>
            <div>
              <MagicButton onClick={onClose}>{t('close')}</MagicButton>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}