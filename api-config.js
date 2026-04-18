/**
 * API Configuration - Production Override
 * Fixes hardcoded dev URLs in compiled Flutter app
 * MUST run BEFORE Flutter app loads!
 */

(function() {
  'use strict';

  // Detect environment
  const host = window.location.hostname;
  const protocol = window.location.protocol;
  
  // Determine API base URL
  let apiBaseUrl = '';
  
  if (host === 'localhost' || host === '127.0.0.1' || host.includes('192.168')) {
    // Local development
    apiBaseUrl = 'http://192.168.8.33/teacher-eval';  // Your local dev machine
  } else {
    // Production - use HTTPS for Render
    apiBaseUrl = 'https://teacher-eval-4.onrender.com';
  }

  // Store globally
  window.__apiBaseUrl = apiBaseUrl;
  window.__apiEndpoint = apiBaseUrl;
  window.__apiBackendUrl = apiBaseUrl;
  
  console.log('[APIConfig] Current host:', host);
  console.log('[APIConfig] Using API base URL:', apiBaseUrl);

  // Monkey-patch XMLHttpRequest
  const OriginalXHR = window.XMLHttpRequest;
  window.XMLHttpRequest = class extends OriginalXHR {
    open(method, url, ...args) {
      if (typeof url === 'string') {
        url = fixUrl(url);
        console.log('[APIConfig] XMLHttpRequest URL fixed to:', url);
      }
      return super.open(method, url, ...args);
    }
  };

  // Monkey-patch fetch
  const originalFetch = window.fetch;
  window.fetch = function(input, init) {
    let url = typeof input === 'string' ? input : input.url;
    
    if (typeof url === 'string') {
      url = fixUrl(url);
      console.log('[APIConfig] Fetch URL fixed to:', url);
      
      if (typeof input === 'string') {
        input = url;
      } else {
        input.url = url;
      }
    }
    
    return originalFetch.call(this, input, init);
  };

  // Fix URL function
  function fixUrl(url) {
    // Replace hardcoded local IPs with production URL
    if (host !== 'localhost' && !host.includes('192.168') && host !== '127.0.0.1') {
      // We're in production - replace local IPs
      url = url.replace(/http:\/\/192\.168\.\d+\.\d+\/teacher-eval/g, apiBaseUrl);
      url = url.replace(/http:\/\/localhost\/teacher-eval/g, apiBaseUrl);
    }
    
    // Fix path structure
    url = url.replace(/\/teacher-eval\/api\//g, '/api/');
    url = url.replace(/\/teacher-eval\/index\.php/g, '');
    url = url.replace(/request=api\//g, 'api/');
    
    return url;
  }

})();
