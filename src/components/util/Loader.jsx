// src/components/util/Loader.jsx
import { Html, useProgress } from '@react-three/drei';

export default function Loader() {
  const { progress } = useProgress();
  return (
    <Html center>
      <div style={{ 
        background: 'rgba(0,0,0,0.5)',
        color: 'white', padding: '10px 14px', borderRadius: 8, 
        fontFamily: 'system-ui, sans-serif', fontWeight: 600 
      }}>
        {Math.round(progress)}%
      </div>
    </Html>
  );
}
