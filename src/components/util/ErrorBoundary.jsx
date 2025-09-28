import React from 'react';

/**
 * ErrorBoundary catches uncaught errors during render and displays
 * a fallback UI.  It logs the error to the console and prevents
 * the entire app from unmounting.  Wrap pages and components in
 * this boundary to improve resilience.
 */
export default class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error, info) {
    console.error('ErrorBoundary caught an error', error, info);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div style={{ padding: '2rem', textAlign: 'center', color: 'white' }}>
          <h2>Ups! A apărut o eroare.</h2>
          <p>Te rugăm să reîncarci pagina.</p>
        </div>
      );
    }
    return this.props.children;
  }
}