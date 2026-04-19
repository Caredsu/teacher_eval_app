/**
 * Keep Render backend warm
 * Prevents cold starts by pinging the backend every 5 minutes
 */

(function() {
  'use strict';
  
  const host = window.location.hostname;
  
  // Only ping on production
  if (host === 'localhost' || host.includes('192.168')) return;
  
  const apiBaseUrl = 'https://teacher-eval-4.onrender.com';
  
  // Ping every 5 minutes
  setInterval(function() {
    fetch(apiBaseUrl + '/api/evaluations/status', {
      method: 'GET',
      headers: { 'Content-Type': 'application/json' },
      cache: 'no-store'
    }).catch(err => console.log('[KeepAlive] Ping sent'));
  }, 5 * 60 * 1000);
  
  // Initial ping on load
  setTimeout(function() {
    fetch(apiBaseUrl + '/api/evaluations/status', {
      method: 'GET',
      headers: { 'Content-Type': 'application/json' },
      cache: 'no-store'
    }).then(() => console.log('[KeepAlive] Initial ping successful'));
  }, 2000);
})();
