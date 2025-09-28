import { useEffect, useRef } from 'react';

/**
 * useAmbientAudio plays a looped audio file in the background.  It
 * handles autoplay restrictions by waiting for the first user
 * interaction before starting playback.  The audio pauses and
 * restarts automatically based on the enabled flag.
 *
 * @param {string} url The path to the audio file to play.
 * @param {boolean} enabled Whether the ambient sound should play.
 */
export default function useAmbientAudio(url, enabled = true) {
  const audioRef = useRef(null);
  // Track whether we've unlocked audio playback via a user gesture.
  const unlockedRef = useRef(false);

  useEffect(() => {
    // Create the audio element on mount.  We don't attach it to the DOM.
    const audio = new Audio(url);
    audio.loop = true;
    audioRef.current = audio;

    // Handler to unlock audio after the first user interaction.
    function unlock() {
      if (!unlockedRef.current) {
        audio.play().catch(() => {});
        unlockedRef.current = true;
        window.removeEventListener('pointerdown', unlock);
      }
    }
    window.addEventListener('pointerdown', unlock);

    return () => {
      window.removeEventListener('pointerdown', unlock);
      audio.pause();
    };
  }, [url]);

  useEffect(() => {
    const audio = audioRef.current;
    if (!audio) return;
    if (enabled && unlockedRef.current) {
      audio.play().catch(() => {});
    } else {
      audio.pause();
    }
  }, [enabled]);
}