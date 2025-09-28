import React, { useState } from 'react';
import { useAppStore } from '../store/appStore.js';
import MagicButton from '../components/ui/MagicButton.jsx';
// Category icons generated in the asset pack.  Each corresponds to a category key.
import farmIcon from '../assets/Asset_Pack/categories/farm.png';
import wildIcon from '../assets/Asset_Pack/categories/wild.png';
import seaIcon from '../assets/Asset_Pack/categories/sea.png';
import vehiclesIcon from '../assets/Asset_Pack/categories/vehicles.png';
import houseIcon from '../assets/Asset_Pack/categories/house.png';
import natureIcon from '../assets/Asset_Pack/categories/nature.png';
import ambientIcon from '../assets/Asset_Pack/categories/ambient.png';
import soundsData from '../data/soundsData.js';
import { t } from '../i18n/index.js';
import { soundsIcons } from '../data/soundsIcons.js';

// Map internal category keys to friendly display names.  Only the first
// six categories are used in the UI per mission requirements.
const CATEGORY_NAMES = {
  farm: 'Animale de fermă',
  wild: 'Animale sălbatice',
  sea: 'Animale marine',
  vehicles: 'Vehicule',
  house: 'Sunete din casă',
  nature: 'Natură',
};

// Map category keys to corresponding icons.  These images are loaded above.
const CATEGORY_ICONS = {
  farm: farmIcon,
  wild: wildIcon,
  sea: seaIcon,
  vehicles: vehiclesIcon,
  house: houseIcon,
  nature: natureIcon,
  ambient: ambientIcon,
};

// Play a short synthetic click sound when a sound item is selected.  This
// function uses the Web Audio API to provide immediate feedback without
// requiring external audio files.  Each call creates a new context.
function playClick(mute = false) {
  if (mute) return;
  const ctx = new (window.AudioContext || window.webkitAudioContext)();
  const osc = ctx.createOscillator();
  const gain = ctx.createGain();
  osc.type = 'square';
  osc.frequency.setValueAtTime(880, ctx.currentTime);
  osc.connect(gain);
  gain.connect(ctx.destination);
  gain.gain.setValueAtTime(0.2, ctx.currentTime);
  gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.15);
  osc.start();
  osc.stop(ctx.currentTime + 0.15);
}

/**
 * SoundsPage allows children to explore categories of everyday sounds.  The
 * UI displays six categories as buttons; selecting one shows a list of
 * descriptive labels representing individual sound clips.  When a child
 * clicks at least five different items within a category, that category's
 * identifier is added to the global completedActivities state.  This
 * component does not yet load actual audio files but can be easily
 * extended to do so by associating each label with an imported sound.
 */
export default function SoundsPage() {
  const addCompletedActivity = useAppStore((state) => state.addCompletedActivity);
  const setCurrentPage = useAppStore((state) => state.setCurrentPage);
  const globalMute = useAppStore((state) => state.globalMute);
  // selected category key or null
  const [selectedCategory, setSelectedCategory] = useState(null);
  // track which items have been listened per category
  const [listened, setListened] = useState({});

  const handleItemClick = (category, label) => {
    playClick(globalMute);
    setListened((prev) => {
      const set = new Set(prev[category] || []);
      set.add(label);
      const updated = { ...prev, [category]: set };
      // If five or more unique items listened and not already completed
      if (set.size >= 5) {
        addCompletedActivity(`sounds-${category}`);
      }
      return updated;
    });
  };

  const renderCategoryMenu = () => (
    <div style={{ textAlign: 'center' }}>
      <h2>Alege o categorie de sunete</h2>
      <div style={{ display: 'flex', flexWrap: 'wrap', justifyContent: 'center', gap: '1rem', marginTop: '1rem' }}>
        {Object.keys(CATEGORY_NAMES).map((key) => (
          <MagicButton key={key} onClick={() => setSelectedCategory(key)} style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <img src={CATEGORY_ICONS[key]} alt={CATEGORY_NAMES[key]} style={{ width: '24px', height: '24px' }} />
            <span>{CATEGORY_NAMES[key]}</span>
          </MagicButton>
        ))}
      </div>
      <div style={{ marginTop: '2rem' }}>
        <MagicButton onClick={() => setCurrentPage('mainMenu')}>Înapoi la meniu</MagicButton>
      </div>
    </div>
  );

  const renderCategoryItems = (category) => {
    const items = soundsData[category] || [];
    const listenedSet = listened[category] || new Set();
    // Helper to convert a label into a slug used for icon lookup
    const slugifyLabel = (lbl) => {
      // Remove any parenthetical text e.g. "(muget de vacă)"
      let noParen = lbl.replace(/\([^)]*\)/g, '').trim();
      // Normalize diacritics
      noParen = noParen.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
      // Split into words and take the last word as base name
      const parts = noParen.split(/\s+/);
      let slug = parts[parts.length - 1] || '';
      // Remove non word characters
      slug = slug.toLowerCase().replace(/[^a-z0-9_]/g, '');
      return slug;
    };
    return (
      <div style={{ textAlign: 'center' }}>
        <h2>{CATEGORY_NAMES[category]}</h2>
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', marginTop: '1rem' }}>
          {items.map((label, index) => {
            const slug = slugifyLabel(label);
            const icon = (soundsIcons[category] && soundsIcons[category][slug]) || null;
            return (
              <button
                key={index}
                onClick={() => handleItemClick(category, label)}
                style={{
                  width: '70%',
                  margin: '4px 0',
                  padding: '0.5rem 1rem',
                  borderRadius: '8px',
                  border: '1px solid #666',
                  background: listenedSet.has(label) ? 'rgba(255,255,255,0.2)' : 'rgba(255,255,255,0.1)',
                  color: '#fff',
                  cursor: 'pointer',
                  textAlign: 'left',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.5rem',
                }}
              >
                {icon && <img src={icon} alt={slug} style={{ width: '24px', height: '24px' }} />}
                <span>{label}</span>
              </button>
            );
          })}
        </div>
        <div style={{ marginTop: '2rem' }}>
          <MagicButton onClick={() => setSelectedCategory(null)}>Înapoi</MagicButton>
        </div>
      </div>
    );
  };

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', paddingTop: '6rem' }}>
      {selectedCategory === null ? renderCategoryMenu() : renderCategoryItems(selectedCategory)}
    </div>
  );
}