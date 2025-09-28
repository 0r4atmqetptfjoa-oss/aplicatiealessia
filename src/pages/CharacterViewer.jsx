import { Canvas } from '@react-three/fiber';
import { OrbitControls, Environment } from '@react-three/drei';
import Alessia from '../components/characters/Alessia.jsx';

export default function CharacterViewer() {
  return (
    <div style={{ position:'absolute', inset:0 }}>
      <Canvas shadows camera={{ position: [2, 1.6, 3], fov: 45 }}>
        <hemisphereLight intensity={0.6} />
        <directionalLight position={[4,6,3]} intensity={1.2} castShadow />
        <Alessia action="dance" toon scale={1.2} position={[0,-1,0]} />
        <Environment preset="sunset" />
        <OrbitControls enablePan={false} />
      </Canvas>
    </div>
  );
}