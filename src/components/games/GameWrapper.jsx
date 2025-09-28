import React, { useState } from 'react';
import { useAppStore } from '../../store/appStore.js';
import MagicButton from '../ui/MagicButton.jsx';

/**
 * GameWrapper is a generic container used by all educational mini games.
 * It manages common state such as whether the game is complete and
 * delegates the actual game logic to its children.  When the child
 * invokes the provided finishGame callback, the wrapper records the
 * completion in the global store and displays a congratulatory screen.
 *
 * Props:
 *   gameId (string) – unique identifier for this game used when marking
 *     completion in the global store.
 *   children (function) – a render prop that receives an object with
 *     finishGame() and (optionally) score/setScore for games that
 *     maintain a score.  The child is expected to call finishGame when
 *     the user has successfully finished the game.
 */
export default function GameWrapper({ gameId, children }) {
  const addCompletedActivity = useAppStore((state) => state.addCompletedActivity);
  const setCurrentPage = useAppStore((state) => state.setCurrentPage);
  const [isComplete, setIsComplete] = useState(false);
  const [score, setScore] = useState(0);

  const finishGame = () => {
    if (!isComplete) {
      setIsComplete(true);
      addCompletedActivity(gameId);
    }
  };

  if (isComplete) {
    return (
      <div style={{ textAlign: 'center', marginTop: '2rem' }}>
        <h2>Felicitări! Ai terminat jocul.</h2>
        <p>Scorul tău: {score}</p>
        <MagicButton onClick={() => setCurrentPage('mainMenu')}>
          Înapoi la meniu
        </MagicButton>
      </div>
    );
  }

  // Provide score and setScore to children so games can display and update
  // points.  The finishGame callback marks completion.
  return children({ finishGame, score, setScore });
}