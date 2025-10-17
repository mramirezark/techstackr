// Project Modals Module
// Handles all project-related modal functionality

import { ModalUtils } from './modal-utils.js';

export class ProjectModals {
  constructor() {
    this.initializeProjectDetails();
    this.initializeNewProject();
    this.initializeEditProject();
    this.initializeDeleteProject();
  }

  initializeProjectDetails() {
    const projectButtons = document.querySelectorAll('[data-action*="showProjectDetails"]');
    
    projectButtons.forEach(button => {
      button.addEventListener('click', async (e) => {
        e.preventDefault();
        
        const projectId = button.dataset.projectId;
        const modalContent = document.getElementById('modal-content');
        
        if (!modalContent || !projectId) return;
        
        const result = await ModalUtils.fetchModal(
          `/projects/${projectId}/modal_details`,
          modalContent,
          'Loading project details...'
        );
        
        if (result.success) {
          this.attachGenerateRecommendationsListener();
        }
      });
    });
  }

  initializeNewProject() {
    const newProjectButtons = document.querySelectorAll('[data-action="showNewProjectModal"]');
    
    newProjectButtons.forEach(button => {
      button.addEventListener('click', async (e) => {
        e.preventDefault();
        
        const modalContent = document.getElementById('new-project-modal-content');
        
        if (!modalContent) return;
        
        const result = await ModalUtils.fetchModal(
          '/projects/modal_new',
          modalContent,
          'Loading form...'
        );
        
        if (result.success) {
          this.attachNewProjectFormHandler();
        }
      });
    });
  }

  initializeEditProject() {
    const editProjectButtons = document.querySelectorAll('[data-action="showEditProjectModal"]');
    
    editProjectButtons.forEach(button => {
      button.addEventListener('click', async (e) => {
        e.preventDefault();
        
        const projectId = button.dataset.projectId;
        const projectTitle = button.dataset.projectTitle;
        const modalContent = document.getElementById('modal-content');
        
        if (!modalContent || !projectId) return;
        
        const result = await ModalUtils.fetchModal(
          `/projects/${projectId}/modal_edit`,
          modalContent,
          'Loading project details...'
        );
        
        if (result.success) {
          this.attachEditProjectFormHandler();
        }
      });
    });
  }

  initializeDeleteProject() {
    const deleteProjectButtons = document.querySelectorAll('[data-action="showDeleteProjectModal"]');
    
    deleteProjectButtons.forEach(button => {
      button.addEventListener('click', async (e) => {
        e.preventDefault();
        
        const projectId = button.dataset.projectId;
        const projectTitle = button.dataset.projectTitle;
        const modalContent = document.getElementById('modal-content');
        
        if (!modalContent || !projectId) return;
        
        const result = await ModalUtils.fetchModal(
          `/projects/${projectId}/modal_delete`,
          modalContent,
          'Loading project details...'
        );
        
        if (result.success) {
          this.attachDeleteProjectHandler();
        }
      });
    });
  }

  attachNewProjectFormHandler() {
    const form = document.getElementById('new-project-form');
    if (!form) return;
    
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      
      const modalContent = document.getElementById('new-project-modal-content');
      
      // Hide previous errors
      const errorContainer = form.querySelector('#form-errors');
      if (errorContainer) {
        errorContainer.classList.add('hidden');
      }
      
      const result = await ModalUtils.submitForm(form, '/projects', modalContent, {
        loadingText: 'Creating...',
        successTitle: 'Project Created!',
        successMessage: 'Project has been added to your list.',
        submitText: '<span>Create Project</span>',
        redirectUrl: null // Don't redirect, just refresh the page
      });
      
      if (!result.success && result.errors) {
        // Show validation errors
        const errorContainer = form.querySelector('#form-errors');
        const errorList = form.querySelector('#error-list');
        
        if (errorContainer && errorList) {
          errorList.innerHTML = '';
          result.errors.forEach(error => {
            const li = document.createElement('li');
            li.textContent = error;
            errorList.appendChild(li);
          });
          errorContainer.classList.remove('hidden');
        }
      }
    });
  }

  attachEditProjectFormHandler() {
    const form = document.getElementById('edit-project-form');
    if (!form) return;
    
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      
      const modalContent = document.getElementById('modal-content');
      
      // Hide previous errors
      const errorContainer = form.querySelector('#form-errors');
      if (errorContainer) {
        errorContainer.classList.add('hidden');
      }
      
      const result = await ModalUtils.submitForm(form, form.action, modalContent, {
        method: 'PATCH',
        loadingText: 'Updating...',
        successTitle: 'Project Updated!',
        successMessage: 'Project has been successfully updated.',
        submitText: '<span>Update Project</span>'
      });
      
      if (!result.success && result.errors) {
        // Show validation errors
        const errorContainer = form.querySelector('#form-errors');
        const errorList = form.querySelector('#error-list');
        
        if (errorContainer && errorList) {
          errorList.innerHTML = '';
          result.errors.forEach(error => {
            const li = document.createElement('li');
            li.textContent = error;
            errorList.appendChild(li);
          });
          errorContainer.classList.remove('hidden');
        }
      }
    });
  }

  attachDeleteProjectHandler() {
    const confirmInput = document.getElementById('confirm-delete-input');
    const confirmBtn = document.getElementById('confirm-delete-btn');
    
    if (!confirmInput || !confirmBtn) return;
    
    const expectedTitle = confirmBtn.dataset.projectTitle;
    
    // Enable/disable delete button based on input
    confirmInput.addEventListener('input', (e) => {
      if (e.target.value === expectedTitle) {
        confirmBtn.disabled = false;
        confirmBtn.classList.remove('opacity-50', 'cursor-not-allowed');
      } else {
        confirmBtn.disabled = true;
        confirmBtn.classList.add('opacity-50', 'cursor-not-allowed');
      }
    });
    
    // Handle delete confirmation
    confirmBtn.addEventListener('click', async (e) => {
      e.preventDefault();
      
      if (confirmInput.value !== expectedTitle) return;
      
      const projectId = confirmBtn.dataset.projectId;
      const modalContent = document.getElementById('modal-content');
      
      // Disable button and show loading
      confirmBtn.disabled = true;
      confirmBtn.innerHTML = '<span>Deleting...</span>';
      
      try {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        
        const response = await fetch(`/projects/${projectId}`, {
          method: 'DELETE',
          headers: {
            'X-CSRF-Token': csrfToken,
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
          }
        });
        
        const data = await response.json();
        
        if (data.success) {
          // Success! Close modal and redirect
          ModalUtils.hideModal(modalContent.querySelector('.modal-overlay'));
          
          ModalUtils.showSuccessModal(
            modalContent,
            'Project Deleted!',
            data.message,
            data.redirect_url
          );
          
        } else {
          // Show error message
          ModalUtils.hideModal(modalContent.querySelector('.modal-overlay'));
          
          // Show error alert
          alert(data.message || 'Failed to delete project. Please try again.');
          
          // Reset button
          confirmBtn.disabled = false;
          confirmBtn.innerHTML = '<span>Delete Project</span>';
        }
      } catch (error) {
        console.error('Error deleting project:', error);
        
        // Show error message
        alert('An error occurred while deleting the project. Please try again.');
        
        // Reset button
        confirmBtn.disabled = false;
        confirmBtn.innerHTML = '<span>Delete Project</span>';
      }
    });
  }

  attachGenerateRecommendationsListener() {
    const button = document.querySelector('[data-action="generateRecommendations"]');
    
    if (!button) return;
    
    button.addEventListener('click', async (e) => {
      e.preventDefault();
      e.stopPropagation();
      
      const projectId = button.dataset.projectId;
      const modalContent = document.querySelector('.modal-body');
      
      if (!modalContent || !projectId) return;
      
      // Show loading state with progress
      modalContent.innerHTML = this.getProgressHTML();
      
      // Simulate progress animation
      this.animateProgress(modalContent);
      
      try {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        
        const response = await fetch(`/projects/${projectId}/recommendation`, {
          method: 'POST',
          headers: {
            'Accept': 'text/html',
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRF-Token': csrfToken
          }
        });
        
        if (response.ok) {
          // Complete progress bar
          const progressBar = modalContent.querySelector('.progress-bar');
          const progressText = modalContent.querySelector('.progress-text');
          
          if (progressBar) progressBar.style.width = '100%';
          if (progressText) progressText.textContent = '100%';
          
          // Show success state briefly
          modalContent.innerHTML = `
            <div class="bg-slate-700/50 rounded-lg p-8 text-center">
              <div class="text-6xl mb-6">✅</div>
              <h3 class="text-2xl font-bold text-white mb-4">Recommendations Generated!</h3>
              <p class="text-gray-300 mb-6">AI has successfully analyzed your project and created personalized recommendations.</p>
            </div>
          `;
          
          // Wait a moment then reload the modal with new data
          setTimeout(async () => {
            try {
              const modalResponse = await fetch(`/projects/${projectId}/modal_details`, {
                method: 'GET',
                headers: {
                  'Accept': 'text/html',
                  'X-Requested-With': 'XMLHttpRequest'
                }
              });
              
              if (modalResponse.ok) {
                const html = await modalResponse.text();
                const modalContainer = document.getElementById('modal-content');
                if (modalContainer) {
                  modalContainer.innerHTML = html;
                  // Re-attach event listeners
                  this.attachModalListeners();
                }
              }
            } catch (error) {
              console.error('Error reloading modal:', error);
            }
          }, 1500);
          
        } else {
          this.showErrorState(modalContent);
        }
      } catch (error) {
        console.error('Error generating recommendations:', error);
        this.showErrorState(modalContent);
      }
    });
  }

  getProgressHTML() {
    return `
      <div class="bg-slate-700/50 rounded-lg p-8 text-center">
        <div class="text-6xl mb-6 animate-pulse">🤖</div>
        <h3 class="text-2xl font-bold text-white mb-4">Generating AI Recommendations</h3>
        <p class="text-gray-300 mb-6">Our AI is analyzing your project and creating personalized technology recommendations...</p>
        
        <!-- Progress Animation -->
        <div class="relative w-full max-w-md mx-auto mb-6">
          <div class="w-full bg-slate-600 rounded-full h-3">
            <div class="bg-gradient-to-r from-blue-500 to-purple-500 h-3 rounded-full progress-bar" style="width: 0%"></div>
          </div>
          <div class="flex justify-between text-xs text-gray-400 mt-2">
            <span>Analyzing...</span>
            <span class="progress-text">0%</span>
          </div>
        </div>
        
        <!-- Progress Steps -->
        <div class="space-y-3 text-left max-w-md mx-auto">
          <div class="flex items-center text-gray-300 progress-step" data-step="1">
            <div class="w-6 h-6 rounded-full bg-slate-600 flex items-center justify-center mr-3 step-icon">1</div>
            <span>Analyzing project requirements...</span>
          </div>
          <div class="flex items-center text-gray-500 progress-step" data-step="2">
            <div class="w-6 h-6 rounded-full bg-slate-600 flex items-center justify-center mr-3 step-icon">2</div>
            <span>Selecting technology stack...</span>
          </div>
          <div class="flex items-center text-gray-500 progress-step" data-step="3">
            <div class="w-6 h-6 rounded-full bg-slate-600 flex items-center justify-center mr-3 step-icon">3</div>
            <span>Determining team composition...</span>
          </div>
          <div class="flex items-center text-gray-500 progress-step" data-step="4">
            <div class="w-6 h-6 rounded-full bg-slate-600 flex items-center justify-center mr-3 step-icon">4</div>
            <span>Generating recommendations...</span>
          </div>
        </div>
      </div>
    `;
  }

  animateProgress(modalContent) {
    const progressBar = modalContent.querySelector('.progress-bar');
    const progressText = modalContent.querySelector('.progress-text');
    const progressSteps = modalContent.querySelectorAll('.progress-step');
    
    let progress = 0;
    const progressInterval = setInterval(() => {
      progress += Math.random() * 15 + 5; // Random progress between 5-20%
      if (progress > 90) progress = 90; // Stop at 90% until real response
      
      if (progressBar) progressBar.style.width = progress + '%';
      if (progressText) progressText.textContent = Math.round(progress) + '%';
      
      // Update step indicators
      const currentStep = Math.floor((progress / 100) * 4);
      progressSteps.forEach((step, index) => {
        if (index <= currentStep) {
          step.classList.remove('text-gray-500');
          step.classList.add('text-blue-400');
          const icon = step.querySelector('.step-icon');
          icon.classList.remove('bg-slate-600');
          icon.classList.add('bg-blue-500');
          if (index === currentStep) {
            icon.innerHTML = '⏳';
          } else {
            icon.innerHTML = '✓';
          }
        }
      });
    }, 800);
    
    // Store interval ID for cleanup
    modalContent._progressInterval = progressInterval;
  }

  showErrorState(modalContent) {
    modalContent.innerHTML = `
      <div class="bg-slate-700/50 rounded-lg p-8 text-center">
        <div class="text-6xl mb-6">❌</div>
        <h3 class="text-2xl font-bold text-white mb-4">Generation Failed</h3>
        <p class="text-gray-300 mb-6">There was an error generating recommendations. Please try again.</p>
        <button onclick="location.reload()" class="btn btn-primary">Try Again</button>
      </div>
    `;
  }

  attachModalListeners() {
    const modal = document.querySelector('.modal-overlay');
    if (modal) {
      ModalUtils.attachCloseListeners(modal);
    }
    
    // Also attach generate recommendations listener
    this.attachGenerateRecommendationsListener();
  }
}
