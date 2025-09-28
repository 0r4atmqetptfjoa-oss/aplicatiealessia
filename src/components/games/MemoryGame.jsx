import React, { useState, useEffect } from 'react';
import GameWrapper from './GameWrapper.jsx';
import MagicButton from '../ui/MagicButton.jsx';

/**
 * MemoryGame – a simple concentration game where players flip over pairs
 * of coloured cards.  When all pairs are matched the game reports
 * completion via GameWrapper.  The game uses eight colours, each
 * duplicated once and shuffled.  Users can flip at most two cards at
 * once; if the colours match they remain revealed, otherwise they
 * automatically flip back after a short delay.
 */
export default function MemoryGame() {
  // Define the colours used in the game.  We pick eight pastel colours.
  const baseColours = [
    '#f8b195', '#f67280', '#c06c84', '#6c5b7b',
    '#355c7d', '#99b898', '#feceab', '#ff847c'
  ];
  // Duplicate and shuffle the colours to form the deck.
  const [deck, setDeck] = useState(() => {
    const cards = baseColours.concat(baseColours).map((colour, idx) => ({
      id: idx,
      colour,
      isFlipped: false,
      isMatched: false
    }));
    // Fisher–Yates shuffle
    for (let i = cards.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [cards[i], cards[j]] = [cards[j], cards[i]];
    }
    return cards;
  });
  const [selected, setSelected] = useState([]);

  return (
    <GameWrapper gameId="game-memory">
      {({ finishGame, score, setScore }) => {
        // When a card is clicked, flip it and add to selected array.
        const handleFlip = (index) => {
          const newDeck = deck.map((card, i) =>
            i === index ? { ...card, isFlipped: true } : card
          );
          setDeck(newDeck);
          setSelected((prev) => [...prev, index]);
        };
        // Check for match when two cards are selected.
        useEffect(() => {
          if (selected.length === 2) {
            const [i, j] = selected;
            if (deck[i].colour === deck[j].colour) {
              // Matched
              const newDeck = deck.map((card, idx) =>
                idx === i || idx === j
                  ? { ...card, isMatched: true }
                  : card
              );
              setDeck(newDeck);
              setScore(score + 1);
              setSelected([]);
              // Check if all matched
              if (newDeck.every((card) => card.isMatched)) {
                finishGame();
              }
            } else {
              // No match: flip back after delay
              setTimeout(() => {
                setDeck((current) =>
                  current.map((card, idx) =>
                    idx === i || idx === j
                      ? { ...card, isFlipped: false }
                      : card
                  )
                );
                setSelected([]);
              }, 800);
            }
          }
        }, [selected, deck, finishGame, setScore, score]);
        return (
          <div style={{ textAlign: 'center', marginTop: '1rem' }}>
            <h2>Memorie</h2>
            <p>Potrivește toate perechile de culori.</p>
            <p>Scor: {score}</p>
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(4, 60px)',
                gridGap: '10px',
                justifyContent: 'center',
              }}
            >
              {deck.map((card, idx) => (
                <div
                  key={card.id}
                  onClick={() => {
                    if (!card.isFlipped && !card.isMatched && selected.length < 2) {
                      handleFlip(idx);
                    }
                  }}
                  style={{
                    width: '60px',
                    height: '60px',
                    borderRadius: '8px',
                    backgroundColor: card.isFlipped || card.isMatched ? card.colour : '#333',
                    cursor: card.isMatched ? 'default' : 'pointer',
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