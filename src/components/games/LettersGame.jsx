import React, { useState, useEffect } from 'react';
import GameWrapper from './GameWrapper.jsx';
import MagicButton from '../ui/MagicButton.jsx';

/**
 * LettersGame – teaches letter recognition.  A random uppercase letter
 * from A–Z is displayed and the player must select the matching letter
 * from four options.  After ten correct selections the game is won.
 */
export default function LettersGame() {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

  return (
    <GameWrapper gameId="game-letters">
      {({ finishGame, score, setScore }) => {
        const [target, setTarget] = useState(() => letters[Math.floor(Math.random() * letters.length)]);
        const [round, setRound] = useState(0);
        const generateOptions = () => {
          const opts = [target];
          while (opts.length < 4) {
            const rand = letters[Math.floor(Math.random() * letters.length)];
            if (!opts.includes(rand)) opts.push(rand);
          }
          return opts.sort();
        };
        const [options, setOptions] = useState(generateOptions);

        const handleChoice = (letter) => {
          if (letter === target) {
            setScore((s) => s + 1);
            const newRound = round + 1;
            setRound(newRound);
            if (newRound >= 10) {
              finishGame();
              return;
            }
          }
          // pick new target regardless of correctness
          const newTarget = letters[Math.floor(Math.random() * letters.length)];
          setTarget(newTarget);
          setOptions(() => {
            const opts = [newTarget];
            while (opts.length < 4) {
              const rand = letters[Math.floor(Math.random() * letters.length)];
              if (!opts.includes(rand)) opts.push(rand);
            }
            return opts.sort();
          });
        };
        return (
          <div style={{ textAlign: 'center', marginTop: '1rem' }}>
            <h2>Litere</h2>
            <p>Găseşte litera identică cu cea afişată. Progrese: {round}/10</p>
            <div style={{ fontSize: '4rem', margin: '20px', color: '#f8b195' }}>{target}</div>
            <div style={{ display: 'flex', justifyContent: 'center', gap: '1rem' }}>
              {options.map((opt) => (
                <MagicButton key={opt} onClick={() => handleChoice(opt)} style={{ minWidth: '60px' }}>
                  {opt}
                </MagicButton>
              ))}
            </div>
          </div>
        );
      }}
    </GameWrapper>
  );
}