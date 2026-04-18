/**
 * API Configuration - Production Override
 * Fixes hardcoded dev URLs in compiled Flutter app
 */

(function() {
  'use strict';

  // Detect environment
  const host = window.location.hostname;
  const protocol = window.location.protocol;
  
  // Determine API base URL
  let apiBaseUrl = '';
  
  if (host === 'localhost' || host === '127.0.0.1' || host.includes('192.168')) {
    // Local development - adjust to your local machine IP/port
    apiBaseUrl = 'http://192.168.8.33/teacher-eval';  // Replace with your local dev machine
  } else {
    // Production - use the Render backend
    apiBaseUrl = 'https://teacher-eval-4.onrender.com';
  }

  // Store globally for Flutter app to access if needed
  window.__apiBaseUrl = apiBaseUrl;
  window.__apiEndpoint = apiBaseUrl;
  
  console.log('[APIConfig] Environment:', host);
  console.log('[APIConfig] Using API URL:', apiBaseUrl);

  // Monkey-patch fetch to intercept and replace URLs
  const originalFetch = window.fetch;
  
  window.fetch = function(...args) {
    let url = args[0];
    
    if (typeof url === 'string') {
      // Replace hardcoded local IPs 
      url = url.replace(/http:\/\/192\.168\.\d+\.\d+\/teacher-eval/g, apiBaseUrl);
      url = url.replace(/http:\/\/localhost\/teacher-eval/g, apiBaseUrl);
      
      // Fix path: /teacher-eval/api/ -> /api/
      url = url.replace(/\/teacher-eval\/api\//g, '/api/');
      url = url.replace(/\/teacher-eval\/index\.php/g, '');
      
      args[0] = url;
      console.log('[APIConfig] Fetch URL adjusted to:', url);
    }
    
    return originalFetch.apply(this, args);
  };

})();
