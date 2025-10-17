// Main Application Module
// Initializes all modules and handles application startup

import { ModalUtils } from './modal-utils.js';
import { ProjectModals } from './project-modals.js';
import { UserModals } from './user-modals.js';

export class App {
  constructor() {
    this.projectModals = null;
    this.userModals = null;
  }

  init() {
    console.log('🚀 TechStackr JavaScript Loaded - Version 3.0');
    
    // Wait for DOM to be ready
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', () => this.initializeModules());
    } else {
      this.initializeModules();
    }
  }

  initializeModules() {
    console.log('✅ DOMContentLoaded event fired');
    
    // Initialize modal utilities
    this.initializeModalSystem();
    
    // Initialize project modals
    this.projectModals = new ProjectModals();
    
    // Initialize user modals (only if on admin pages)
    if (document.querySelector('[data-action*="User"]')) {
      this.userModals = new UserModals();
    }
    
    console.log('✅ All modules initialized');
  }

  initializeModalSystem() {
    // Initialize existing modal functionality
    const modalOverlays = document.querySelectorAll('.modal-overlay');
    
    modalOverlays.forEach(overlay => {
      ModalUtils.attachCloseListeners(overlay);
    });
  }
}

// Initialize the application
const app = new App();
app.init();
