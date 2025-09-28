import React from 'react';
import { PerformanceMonitor } from '@react-three/drei';

/**
 * PerfGuard monitors the rendering performance of the Three.js
 * scene.  If frame rate drops below a threshold, it calls onDecline.
 * When performance improves, it calls onRecover.  Use this to
 * dynamically enable/disable expensive effects like rain particles.
 *
 * Props:
 *  children – render prop that receives a boolean `degraded`.
 *  onDecline – callback invoked when FPS drops.
 *  onRecover – callback invoked when FPS recovers.
 */
export default function PerfGuard({ children, onDecline, onRecover }) {
  const [degraded, setDegraded] = React.useState(false);
  return (
    <>
      <PerformanceMonitor
        onDecline={() => {
          setDegraded(true);
          onDecline?.();
        }}
        onIncline={() => {
          setDegraded(false);
          onRecover?.();
        }}
      />
      {children(degraded)}
    </>
  );
}