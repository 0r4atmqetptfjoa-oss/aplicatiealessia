import React, { useState } from 'react';
import GameWrapper from './GameWrapper.jsx';

/**
 * SortingGame – players must arrange numbers in ascending order.  We
 * present a list of five numbers and allow the user to swap adjacent
 * items by clicking arrow buttons.  Once the numbers are in order the
 * game completes.  This teaches ordering and basic algorithmic thinking.
 */
export default function SortingGame() {
  return (
    <GameWrapper gameId="game-sorting">
      {({ finishGame, score, setScore }) => {
        const [list, setList] = useState(() => {
          const arr = [1, 2, 3, 4, 5];
          // shuffle
          for (let i = arr.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [arr[i], arr[j]] = [arr[j], arr[i]];
          }
          return arr;
        });

        const swap = (i, j) => {
          setList((current) => {
            const newArr = [...current];
            [newArr[i], newArr[j]] = [newArr[j], newArr[i]];
            return newArr;
          });
        };

        // Check for completion
        React.useEffect(() => {
          if (list.every((val, idx, arr) => idx === 0 || arr[idx - 1] <= val)) {
            finishGame();
          }
        }, [list, finishGame]);

        return (
          <div style={{ textAlign: 'center', marginTop: '1rem' }}>
            <h2>Sortare</h2>
            <p>Aranjează numerele în ordine crescătoare folosind săgeţile.</p>
            <ul style={{ listStyle: 'none', padding: 0, display: 'inline-block' }}>
              {list.map((num, idx) => (
                <li
                  key={idx}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    marginBottom: '8px',
                    gap: '8px',
                  }}
                >
                  <span
                    style={{
                      display: 'inline-block',
                      width: '40px',
                      height: '40px',
                      lineHeight: '40px',
                      borderRadius: '6px',
                      backgroundColor: '#355c7d',
                      color: 'white',
                      textAlign: 'center',
                    }}
                  >
                    {num}
                  </span>
                  <div>
                    <button
                      onClick={() => idx > 0 && swap(idx, idx - 1)}
                      style={{ marginRight: '4px' }}
                    >
                      ↑
                    </button>
                    <button
                      onClick={() => idx < list.length - 1 && swap(idx, idx + 1)}
                    >
                      ↓
                    </button>
                  </div>
                </li>
              ))}
            </ul>
          </div>
        );
      }}
    </GameWrapper>
  );
}