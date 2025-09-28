import React, { useState, useEffect } from 'react';
import GameWrapper from './GameWrapper.jsx';
import MagicButton from '../ui/MagicButton.jsx';

/**
 * SimonGame – replicates the classic Simon sequence memory game.  The
 * computer plays a sequence of colours which the player must repeat by
 * clicking the buttons in the same order.  Each round adds a new
 * colour.  After five rounds the game ends.  If the player makes a
 * mistake the game restarts from the first round.
 */
export default function SimonGame() {
  const colours = ['#f67280', '#99b898', '#f8b195', '#6c5b7b'];
  return (
    <GameWrapper gameId="game-simon">
      {({ finishGame, score, setScore }) => {
        const [sequence, setSequence] = useState([]);
        const [playerInput, setPlayerInput] = useState([]);
        const [isShowing, setIsShowing] = useState(false);
        const [round, setRound] = useState(0);

        // Start new game on mount
        useEffect(() => {
          nextRound();
        }, []);

        // When sequence updates, show it to the player
        useEffect(() => {
          if (sequence.length > 0) {
            playSequence();
          }
        }, [sequence]);

        const nextRound = () => {
          setRound((r) => r + 1);
          setSequence((seq) => [...seq, Math.floor(Math.random() * colours.length)]);
          setPlayerInput([]);
        };

        const playSequence = async () => {
          setIsShowing(true);
          for (let i = 0; i < sequence.length; i++) {
            await new Promise((resolve) => setTimeout(resolve, 600));
            flashButton(sequence[i]);
            await new Promise((resolve) => setTimeout(resolve, 600));
          }
          setIsShowing(false);
        };

        const flashButton = (index) => {
          const btn = document.getElementById(`simon-${index}`);
          if (btn) {
            btn.style.opacity = '1';
            setTimeout(() => {
              btn.style.opacity = '0.5';
            }, 300);
          }
        };

        const handleClick = (idx) => {
          if (isShowing) return;
          flashButton(idx);
          const newInput = [...playerInput, idx];
          setPlayerInput(newInput);
          // Check if correct so far
          for (let i = 0; i < newInput.length; i++) {
            if (newInput[i] !== sequence[i]) {
              // wrong – reset game
              setScore(0);
              setRound(0);
              setSequence([]);
              setTimeout(() => nextRound(), 500);
              return;
            }
          }
          if (newInput.length === sequence.length) {
            setScore((s) => s + 1);
            if (sequence.length >= 5) {
              finishGame();
            } else {
              setTimeout(() => nextRound(), 500);
            }
          }
        };

        return (
          <div style={{ textAlign: 'center', marginTop: '1rem' }}>
            <h2>Simon</h2>
            <p>Repetă secvenţa de culori. Runda: {round}/5</p>
            <div style={{ display: 'flex', justifyContent: 'center', gap: '1rem', marginTop: '20px' }}>
              {colours.map((colour, idx) => (
                <div
                  key={idx}
                  id={`simon-${idx}`}
                  onClick={() => handleClick(idx)}
                  style={{
                    width: '60px',
                    height: '60px',
                    borderRadius: '50%',
                    backgroundColor: colour,
                    opacity: 0.5,
                    cursor: 'pointer',
                    transition: 'opacity 0.2s',
                  }}
                ></div>
              ))}
            </div>
          </div>
        );
      }}
    </GameWrapper>
  );
}