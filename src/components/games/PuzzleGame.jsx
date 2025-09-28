import React, { useState, useEffect } from 'react';
import GameWrapper from './GameWrapper.jsx';

/**
 * PuzzleGame – a lightweight sliding puzzle.  The game displays a 3×3
 * grid of numbered tiles (1–9) in random order.  Players can swap any
 * two tiles by clicking them sequentially.  When the tiles are sorted
 * ascending from 1 to 9 the game ends.  This simplified mechanic avoids
 * implementing drag/drop while still teaching sequencing.
 */
export default function PuzzleGame() {
  // Initialize a shuffled array of numbers 1–9
  const [tiles, setTiles] = useState(() => {
    const arr = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    for (let i = arr.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    return arr;
  });
  const [selected, setSelected] = useState([]);

  return (
    <GameWrapper gameId="game-puzzle">
      {({ finishGame, score, setScore }) => {
        const handleClick = (idx) => {
          setSelected((prev) => {
            const next = [...prev, idx];
            if (next.length === 2) {
              // Swap tiles
              setTiles((current) => {
                const newTiles = [...current];
                const i = next[0];
                const j = next[1];
                [newTiles[i], newTiles[j]] = [newTiles[j], newTiles[i]];
                return newTiles;
              });
              return [];
            }
            return next;
          });
        };
        // Check if sorted on each update
        useEffect(() => {
          if (tiles.every((value, index) => value === index + 1)) {
            finishGame();
          }
        }, [tiles, finishGame]);
        return (
          <div style={{ textAlign: 'center', marginTop: '1rem' }}>
            <h2>Puzzle</h2>
            <p>Fă clic pe două plăcuţe pentru a le schimba. Aranjează-le în ordine crescătoare.</p>
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(3, 60px)',
                gridGap: '10px',
                justifyContent: 'center',
              }}
            >
              {tiles.map((value, idx) => (
                <div
                  key={idx}
                  onClick={() => handleClick(idx)}
                  style={{
                    width: '60px',
                    height: '60px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    backgroundColor: '#4a90e2',
                    color: 'white',
                    fontSize: '1.5rem',
                    borderRadius: '8px',
                    cursor: 'pointer',
                    border: selected.includes(idx) ? '3px solid #f6c' : '3px solid transparent',
                  }}
                >
                  {value}
                </div>
              ))}
            </div>
          </div>
        );
      }}
    </GameWrapper>
  );
}