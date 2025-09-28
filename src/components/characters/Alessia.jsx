import { useRef, useEffect } from 'react';
import { useGLTF, useAnimations } from '@react-three/drei';

export default function Alessia({
  url = '/assets/models/alessia.mobile.glb',
  action = 'idle',
  toon = true,
  ...props
}) {
  const group = useRef();
  const { scene, animations } = useGLTF(url);
  const { actions, names } = useAnimations(animations, group);

  useEffect(() => {
    const clip = names?.includes(action) ? action : names?.[0];
    if (clip && actions?.[clip]) {
      actions[clip].reset().fadeIn(0.25).play();
      return () => actions[clip]?.fadeOut(0.2);
    }
  }, [action, actions, names]);

  useEffect(() => {
    if (!toon) return;
    scene?.traverse((obj) => {
      if (obj.isMesh && obj.material) {
        obj.material.roughness = 1.0;
        obj.material.metalness = 0.0;
        obj.material.envMapIntensity = 0.2;
      }
    });
  }, [scene, toon]);

  return <primitive ref={group} object={scene} {...props} dispose={null} />;
}

useGLTF.preload('/assets/models/alessia.mobile.glb');
