import React, { useState } from 'react';
import { useAppStore } from '../store/appStore.js';
import MagicButton from '../components/ui/MagicButton.jsx';
import MemoryGame from '../components/games/MemoryGame.jsx';
import PuzzleGame from '../components/games/PuzzleGame.jsx';
import ShadowGame from '../components/games/ShadowGame.jsx';
import LettersGame from '../components/games/LettersGame.jsx';
import SortingGame from '../components/games/SortingGame.jsx';
import SimonGame from '../components/games/SimonGame.jsx';

/**
 * GamesPage provides a menu of educational mini games.  When a game is
 * selected, the appropriate component is rendered within the same page.
 * A back button allows returning to the main menu or the game list.
 */
export default function GamesPage() {
  const setCurrentPage = useAppStore((state) => state.setCurrentPage);
  const [currentGame, setCurrentGame] = useState(null);

  const games = [
    { id: 'memory', name: 'Memorie', component: <MemoryGame /> },
    { id: 'puzzle', name: 'Puzzle', component: <PuzzleGame /> },
    { id: 'shadows', name: 'Umbre', component: <ShadowGame /> },
    { id: 'letters', name: 'Litere', component: <LettersGame /> },
    { id: 'sorting', name: 'Sortare', component: <SortingGame /> },
    { id: 'simon', name: 'Simon', component: <SimonGame /> },
  ];

  const renderMenu = () => (
    <div style={{ textAlign: 'center', marginTop: '2rem' }}>
      <h2>Alege un joc</h2>
      <div style={{ display: 'flex', flexWrap: 'wrap', justifyContent: 'center', gap: '1rem', marginTop: '1.5rem' }}>
        {games.map((g) => (
          <MagicButton key={g.id} onClick={() => setCurrentGame(g.id)} style={{ minWidth: '120px' }}>
            {g.name}
          </MagicButton>
        ))}
      </div>
      <div style={{ marginTop: '2rem' }}>
        <MagicButton onClick={() => setCurrentPage('mainMenu')}>Înapoi la meniu</MagicButton>
      </div>
    </div>
  );

  const renderGame = () => {
    const selected = games.find((g) => g.id === currentGame);
    return (
      <div style={{ marginTop: '1rem' }}>
        <div style={{ marginBottom: '1rem' }}>
          <MagicButton onClick={() => setCurrentGame(null)}>Înapoi la jocuri</MagicButton>
        </div>
        {selected ? selected.component : null}
      </div>
    );
  };

  return (
    <div style={{ paddingTop: '6rem', width: '100%', minHeight: '100%', position: 'relative' }}>
      {currentGame === null ? renderMenu() : renderGame()}
    </div>
  );
}