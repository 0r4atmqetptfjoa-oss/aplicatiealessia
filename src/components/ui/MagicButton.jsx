import React, { useRef, useEffect } from 'react';
import { gsap } from 'gsap';

/**
 * A reusable button with a "magical" animation.
 *
 * This component leverages GSAP to create a gentle pulsing effect on the button
 * itself, drawing the user's eye without being distracting.  It also reacts
 * to hover interactions by temporarily enlarging.  Consumers can pass any
 * children to be rendered inside the button (text or icons), along with
 * standard button props such as onClick.  Additional inline styles and
 * className can be supplied to further customize its appearance.  The
 * component encapsulates all animation logic so that parent components
 * remain declarative and simple.
 */
export default function MagicButton({ onClick, children, style = {}, className = '', ...rest }) {
  const buttonRef = useRef(null);

  useEffect(() => {
    const el = buttonRef.current;
    if (!el) return;
    // Looping timeline for a subtle pulsing effect.  The button scales up
    // slightly then returns to its original size.  The yoyo option makes
    // the animation reverse automatically.
    const tl = gsap.timeline({ repeat: -1, yoyo: true, defaults: { ease: 'sine.inOut' } });
    tl.to(el, { scale: 1.05, duration: 0.6 }).to(el, { scale: 1, duration: 0.6 });

    // Hover handlers: when the pointer enters, enlarge the button a bit more;
    // when leaving, return to the pulsing size.  Use GSAP to animate
    // smoothly.  Event listeners are attached directly because GSAP
    // timeline cannot capture pseudo-class interactions.
    const handleEnter = () => {
      gsap.to(el, { scale: 1.2, duration: 0.3, ease: 'power1.out' });
    };
    const handleLeave = () => {
      gsap.to(el, { scale: 1.05, duration: 0.3, ease: 'power1.out' });
    };
    el.addEventListener('pointerenter', handleEnter);
    el.addEventListener('pointerleave', handleLeave);

    // Clean up animation and listeners on unmount to avoid memory leaks.
    return () => {
      tl.kill();
      el.removeEventListener('pointerenter', handleEnter);
      el.removeEventListener('pointerleave', handleLeave);
    };
  }, []);

  return (
    <button
      ref={buttonRef}
      onClick={onClick}
      className={`magic-button ${className}`.trim()}
      style={{
        border: 'none',
        borderRadius: '12px',
        padding: '0.75rem 1.5rem',
        fontSize: '1rem',
        color: '#ffffff',
        background: 'linear-gradient(45deg, #ff6b6b, #f7d794)',
        boxShadow: '0 0 10px rgba(255, 255, 255, 0.5)',
        cursor: 'pointer',
        outline: 'none',
        ...style,
      }}
      {...rest}
    >
      {children}
    </button>
  );
}