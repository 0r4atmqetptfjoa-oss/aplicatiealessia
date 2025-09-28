import React, { useState, useEffect } from 'react';
import { useAppStore } from '../store/appStore.js';
import MagicButton from '../components/ui/MagicButton.jsx';
import stories from '../data/storiesData.js';
import { useAudioPlayer } from '../hooks/useAudioPlayer.js';

/**
 * StoriesPage allows children to choose from a list of Romanian fairy tales
 * and experience them with basic image/text sequencing.  Selecting a story
 * triggers a simple slideshow: the story description is broken into three
 * segments, and each segment is displayed at five second intervals using
 * the useAudioPlayer hook.  When the sequence finishes, the story ID is
 * added to completedActivities so that a gem appears in the crown.  A
 * placeholder coloured panel stands in for illustrations until real
 * artwork and audio narration can be integrated.
 */
export default function StoriesPage() {
  const addCompletedActivity = useAppStore((state) => state.addCompletedActivity);
  const setCurrentPage = useAppStore((state) => state.setCurrentPage);
  const [selected, setSelected] = useState(null); // selected story object
  const [slideIndex, setSlideIndex] = useState(0);

  // When a story finishes (after the last slide), mark it complete and
  // reset selection.
  const handleFinish = () => {
    if (selected) {
      addCompletedActivity(`story-${selected.id}`);
    }
    setSelected(null);
    setSlideIndex(0);
  };

  // Prepare events for the audio player: three slides at 0s, 5s, 10s.  When
  // the last event has fired the hook will invoke handleFinish.  If no
  // story is selected, events array remains empty.
  const events = selected
    ? [
        { time: 0, action: () => setSlideIndex(0) },
        { time: 5, action: () => setSlideIndex(1) },
        { time: 10, action: () => setSlideIndex(2) },
      ]
    : [];

  const { start, stop, isPlaying } = useAudioPlayer(events, handleFinish);

  // When a new story is selected, start the slideshow.  Clean up timers on
  // unmount or when selected changes.
  useEffect(() => {
    if (selected) {
      start();
    }
    return () => {
      stop();
    };
  }, [selected]);

  // Divide the story description into up to three roughly equal parts to
  // simulate slide content.  If description is short, use entire text.
  const getSlides = (story) => {
    if (!story) return [];
    const text = story.description || '';
    const len = Math.ceil(text.length / 3);
    const slides = [];
    for (let i = 0; i < 3; i++) {
      const part = text.slice(i * len, (i + 1) * len).trim();
      if (part) slides.push(part);
    }
    // Ensure there are always three slides by duplicating last if needed
    while (slides.length < 3) slides.push('');
    return slides;
  };

  const renderStoryList = () => (
    <div style={{ textAlign: 'center' }}>
      <h2>Alege o poveste</h2>
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', marginTop: '1rem' }}>
        {stories.map((story) => (
          <MagicButton key={story.id} onClick={() => setSelected(story)} style={{ margin: '4px 0' }}>
            {story.title}
          </MagicButton>
        ))}
      </div>
      <div style={{ marginTop: '2rem' }}>
        <MagicButton onClick={() => setCurrentPage('mainMenu')}>Înapoi la meniu</MagicButton>
      </div>
    </div>
  );

  const renderStoryPlayer = (story) => {
    const slides = getSlides(story);
    const colours = ['#f4a261', '#e76f51', '#2a9d8f'];
    return (
      <div style={{ textAlign: 'center' }}>
        <h2>{story.title}</h2>
        {/* Display a coloured panel representing the current slide */}
        <div
          style={{
            margin: '1rem auto',
            width: '80%',
            height: '250px',
            background: colours[slideIndex % colours.length],
            borderRadius: '12px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            padding: '1rem',
            color: '#fff',
            fontSize: '1rem',
            lineHeight: '1.4',
            textAlign: 'center',
          }}
        >
          {slides[slideIndex]}
        </div>
        <div style={{ marginTop: '1rem' }}>
          {isPlaying ? (
            <MagicButton onClick={stop}>Opreşte povestea</MagicButton>
          ) : (
            <MagicButton onClick={handleFinish}>Închide</MagicButton>
          )}
        </div>
      </div>
    );
  };

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', paddingTop: '6rem' }}>
      {selected ? renderStoryPlayer(selected) : renderStoryList()}
    </div>
  );
}