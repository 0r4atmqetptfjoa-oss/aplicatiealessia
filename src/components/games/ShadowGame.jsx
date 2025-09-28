import React, { useState } from 'react';
import GameWrapper from './GameWrapper.jsx';
import MagicButton from '../ui/MagicButton.jsx';

/**
 * ShadowGame – players must match a coloured shape to its black silhouette.
 * The game randomly chooses a target shape (circle, square, triangle);
 * the player selects from three coloured options.  After five correct
 * matches the game finishes.  This activity helps with shape
 * recognition and association.
 */
export default function ShadowGame() {
  const shapes = ['cerc', 'pătrat', 'triunghi'];
  const colours = ['#f67280', '#99b898', '#f8b195'];

  return (
    <GameWrapper gameId="game-shadows">
      {({ finishGame, score, setScore }) => {
        const [target, setTarget] = useState(() => shapes[Math.floor(Math.random() * shapes.length)]);
        const [correctCount, setCorrectCount] = useState(0);

        const drawSilhouette = (shape) => {
          const size = 60;
          const style = { width: size, height: size, backgroundColor: '#222', display: 'inline-block' };
          switch (shape) {
            case 'cerc':
              return <div style={{ ...style, borderRadius: '50%' }} />;
            case 'pătrat':
              return <div style={style} />;
            case 'triunghi':
              return <div style={{ width: 0, height: 0, borderLeft: `${size / 2}px solid transparent`, borderRight: `${size / 2}px solid transparent`, borderBottom: `${size}px solid #222` }} />;
            default:
              return null;
          }
        };

        const drawColourShape = (shape, colour) => {
          const size = 60;
          const style = { width: size, height: size, backgroundColor: colour, display: 'inline-block', margin: '0 10px' };
          switch (shape) {
            case 'cerc':
              return <div style={{ ...style, borderRadius: '50%' }} />;
            case 'pătrat':
              return <div style={style} />;
            case 'triunghi':
              return <div style={{ width: 0, height: 0, borderLeft: `${size / 2}px solid transparent`, borderRight: `${size / 2}px solid transparent`, borderBottom: `${size}px solid ${colour}` }} />;
            default:
              return null;
          }
        };

        const handleChoice = (choice) => {
          if (choice === target) {
            setCorrectCount((c) => c + 1);
            setScore((s) => s + 1);
            if (correctCount + 1 >= 5) {
              finishGame();
            } else {
              setTarget(shapes[Math.floor(Math.random() * shapes.length)]);
            }
          } else {
            // Wrong choice: just pick a new target
            setTarget(shapes[Math.floor(Math.random() * shapes.length)]);
          }
        };
        return (
          <div style={{ textAlign: 'center', marginTop: '1rem' }}>
            <h2>Umbre</h2>
            <p>Alege forma care se potriveşte umbrei.</p>
            <p>Progrese: {correctCount}/5</p>
            <div style={{ margin: '20px' }}>{drawSilhouette(target)}</div>
            <div style={{ display: 'flex', justifyContent: 'center', marginTop: '10px' }}>
              {shapes.map((shape, idx) => (
                <div key={shape} onClick={() => handleChoice(shape)} style={{ cursor: 'pointer' }}>
                  {drawColourShape(shape, colours[idx])}
                </div>
              ))}
            </div>
          </div>
        );
      }}
    </GameWrapper>
  );
}