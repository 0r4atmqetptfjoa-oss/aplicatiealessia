import { useRef, useState, useEffect } from 'react';

/**
 * Custom hook for scheduling timed events and handling end‑of‑story logic.
 *
 * This hook accepts an array of event objects, each with a `time` (in seconds)
 * and an `action` callback.  When `start` is invoked, each event will be
 * executed at its specified time relative to the start.  After the final
 * event, an optional `onFinish` callback is fired.  All timers are
 * cleared when the component unmounts or when `stop` is called.
 *
 * @param {Array<{time: number, action: Function}>} events A list of timed events
 * @param {Function} onFinish Callback invoked after the last event
 * @returns {Object} { start, stop, isPlaying }
 */
export function useAudioPlayer(events = [], onFinish) {
  const [isPlaying, setIsPlaying] = useState(false);
  const timersRef = useRef([]);

  const stop = () => {
    timersRef.current.forEach(clearTimeout);
    timersRef.current = [];
    setIsPlaying(false);
  };

  const start = () => {
    if (isPlaying) return;
    setIsPlaying(true);
    // Schedule each event relative to the start time
    events.forEach(({ time, action }) => {
      const id = setTimeout(() => {
        if (typeof action === 'function') action();
      }, time * 1000);
      timersRef.current.push(id);
    });
    // Determine total duration by the maximum event time
    const totalTime = events.reduce((max, ev) => Math.max(max, ev.time), 0);
    const finishId = setTimeout(() => {
      setIsPlaying(false);
      if (typeof onFinish === 'function') onFinish();
    }, (totalTime + 0.1) * 1000);
    timersRef.current.push(finishId);
  };

  useEffect(() => {
    // Cleanup on unmount
    return () => {
      stop();
    };
  }, []);

  return { start, stop, isPlaying };
}