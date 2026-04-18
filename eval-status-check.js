/**
 * Evaluation Status Check - PWE Version
 * Stores evaluation status for Flutter to use
 * Flutter UI will display "Evaluations Closed" message if needed
 */

(function() {
  'use strict';

  async function checkEvaluationStatus() {
    try {
      // Use dynamic API base URL from api-config.js if available
      const baseUrl = window.__apiBaseUrl || 'http://localhost/teacher-eval';
      const url = baseUrl + '/api/evaluations/status';
      
      const response = await fetch(url, {
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
