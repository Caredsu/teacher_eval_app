/**
 * Evaluation Status Check - PWA Version
 * Stores evaluation status for Flutter to use
 * Flutter UI will display "Evaluations Closed" message if needed
 */

(function() {
  'use strict';

  async function checkEvaluationStatus() {
    try {
      // Detect environment
      const host = window.location.hostname;
      let apiUrl = '';
      
      if (host === 'localhost' || host === '127.0.0.1' || host.includes('192.168')) {
        // Local development
        apiUrl = 'http://192.168.8.33/teacher-eval/api/evaluations/status';
      } else {
        // Production
        apiUrl = 'https://teacher-eval-4.onrender.com/api/evaluations/status';
      }
      
      const response = await fetch(apiUrl, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
        cache: 'no-store'
      });

      if (response.ok) {
        const data = await response.json();
        if (data.success && data.data) {
          return { is_open: data.data.is_open ?? false, status: data.data.status ?? 'off' };
        }
      }
    } catch (error) {
      console.error('[EvalCheck] Error checking status:', error.message);
    }
    
    // Default to OFF (safer)
    return { is_open: false, status: 'off' };
  }

  async function init() {
    const status = await checkEvaluationStatus();
    window.__evaluationsOpen = status.is_open;
    window.__evaluationStatus = status.status;
    console.log('[EvalCheck] Evaluation status:', status);
  }

  init();
})();
