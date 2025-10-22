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
      
      // Update project status to processing in the table
      this.updateProjectStatusInTable(projectId, 'processing');
      
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
            <div class="modal-overlay modal-fade-in">
              <div class="modal-container modal-scale-in">
                <div class="modal-header">
                  <h3 class="text-xl font-semibold text-gray-900 flex items-center gap-3">
                    <div class="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center">
                      <span class="text-green-600 text-lg">✅</span>
                    </div>
                    Recommendations Generated!
                  </h3>
                  <button class="modal-close text-gray-400 hover:text-gray-600 transition-colors">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                  </button>
                </div>
                
                <div class="modal-body">
                  <div class="text-center">
                    <div class="text-6xl mb-6">✅</div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-4">Recommendations Generated!</h3>
                    <p class="text-gray-600 mb-8">AI has successfully analyzed your project and created personalized recommendations.</p>
                  </div>
                </div>
                
                <div class="modal-footer">
                  <button class="btn btn-ghost" data-action="click->modal#close">Close</button>
                </div>
              </div>
            </div>
          `;
          
          // Update the projects table
          this.updateProjectStatusInTable(projectId, 'completed');
          
          // Wait a moment then reload page to show updated data (team size, timeline, etc.)
          setTimeout(() => {
            // Reload the page to show the updated recommendation data
            window.location.reload();
          }, 2000);
          
        } else {
          // Update project status to failed in the table
          this.updateProjectStatusInTable(projectId, 'failed');
          this.showErrorState(modalContent);
        }
      } catch (error) {
        console.error('Error generating recommendations:', error);
        // Update project status to failed in the table
        this.updateProjectStatusInTable(projectId, 'failed');
        this.showErrorState(modalContent);
      }
    });
  }

  getProgressHTML() {
    return `
      <div class="modal-overlay modal-fade-in">
        <div class="modal-container modal-scale-in">
          <div class="modal-header">
            <h3 class="text-xl font-semibold text-gray-900 flex items-center gap-3">
              <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                <span class="text-blue-600 text-lg">🤖</span>
              </div>
              Generating AI Recommendations
            </h3>
            <button class="modal-close text-gray-400 hover:text-gray-600 transition-colors">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
              </svg>
            </button>
          </div>
          
          <div class="modal-body">
            <div class="text-center mb-8">
              <div class="text-6xl mb-4 animate-pulse">🤖</div>
              <p class="text-gray-600 text-lg">Our AI is analyzing your project and creating personalized technology recommendations...</p>
            </div>
            
            <!-- Progress Animation -->
            <div class="relative w-full max-w-md mx-auto mb-8">
              <div class="w-full bg-gray-200 rounded-full h-3">
                <div class="bg-gradient-to-r from-blue-500 to-purple-500 h-3 rounded-full progress-bar transition-all duration-500 ease-out" style="width: 0%"></div>
              </div>
              <div class="flex justify-between text-sm text-gray-500 mt-3">
                <span class="progress-label">Analyzing...</span>
                <span class="progress-text font-semibold">0%</span>
              </div>
            </div>
            
            <!-- Progress Steps -->
            <div class="space-y-4 max-w-lg mx-auto">
              <div class="flex items-center progress-step" data-step="1">
                <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center mr-4 step-icon transition-all duration-300">
                  <span class="text-sm font-semibold text-gray-600">1</span>
                </div>
                <span class="text-gray-600 font-medium">Analyzing project requirements...</span>
              </div>
              <div class="flex items-center progress-step" data-step="2">
                <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center mr-4 step-icon transition-all duration-300">
                  <span class="text-sm font-semibold text-gray-600">2</span>
                </div>
                <span class="text-gray-500 font-medium">Selecting technology stack...</span>
              </div>
              <div class="flex items-center progress-step" data-step="3">
                <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center mr-4 step-icon transition-all duration-300">
                  <span class="text-sm font-semibold text-gray-600">3</span>
                </div>
                <span class="text-gray-500 font-medium">Determining team composition...</span>
              </div>
              <div class="flex items-center progress-step" data-step="4">
                <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center mr-4 step-icon transition-all duration-300">
                  <span class="text-sm font-semibold text-gray-600">4</span>
                </div>
                <span class="text-gray-500 font-medium">Generating recommendations...</span>
              </div>
            </div>
          </div>
          
          <div class="modal-footer">
            <button class="btn btn-ghost" data-action="click->modal#close">Close</button>
          </div>
        </div>
      </div>
    `;
  }

  animateProgress(modalContent) {
    const progressBar = modalContent.querySelector('.progress-bar');
    const progressText = modalContent.querySelector('.progress-text');
    const progressLabel = modalContent.querySelector('.progress-label');
    const progressSteps = modalContent.querySelectorAll('.progress-step');
    
    let progress = 0;
    const progressInterval = setInterval(() => {
      progress += Math.random() * 15 + 5; // Random progress between 5-20%
      if (progress > 90) progress = 90; // Stop at 90% until real response
      
      if (progressBar) progressBar.style.width = progress + '%';
      if (progressText) progressText.textContent = Math.round(progress) + '%';
      
      // Update progress label
      if (progressLabel) {
        if (progress < 25) progressLabel.textContent = 'Analyzing...';
        else if (progress < 50) progressLabel.textContent = 'Selecting...';
        else if (progress < 75) progressLabel.textContent = 'Determining...';
        else progressLabel.textContent = 'Generating...';
      }
      
      // Update step indicators
      const currentStep = Math.floor((progress / 100) * 4);
      progressSteps.forEach((step, index) => {
        const stepText = step.querySelector('span:last-child');
        const icon = step.querySelector('.step-icon');
        
        if (index < currentStep) {
          // Completed step
          stepText.classList.remove('text-gray-500');
          stepText.classList.add('text-green-600', 'font-semibold');
          icon.classList.remove('bg-gray-200');
          icon.classList.add('bg-green-500');
          icon.innerHTML = '<svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path></svg>';
        } else if (index === currentStep) {
          // Current step
          stepText.classList.remove('text-gray-500');
          stepText.classList.add('text-blue-600', 'font-semibold');
          icon.classList.remove('bg-gray-200');
          icon.classList.add('bg-blue-500');
          icon.innerHTML = '<div class="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>';
        } else {
          // Pending step
          stepText.classList.remove('text-green-600', 'text-blue-600', 'font-semibold');
          stepText.classList.add('text-gray-500');
          icon.classList.remove('bg-green-500', 'bg-blue-500');
          icon.classList.add('bg-gray-200');
          icon.innerHTML = `<span class="text-sm font-semibold text-gray-600">${index + 1}</span>`;
        }
      });
    }, 800);
    
    // Store interval ID for cleanup
    modalContent._progressInterval = progressInterval;
  }

  showErrorState(modalContent) {
    modalContent.innerHTML = `
      <div class="modal-overlay modal-fade-in">
        <div class="modal-container modal-scale-in">
          <div class="modal-header">
            <h3 class="text-xl font-semibold text-gray-900 flex items-center gap-3">
              <div class="w-8 h-8 bg-red-100 rounded-full flex items-center justify-center">
                <span class="text-red-600 text-lg">❌</span>
              </div>
              Generation Failed
            </h3>
            <button class="modal-close text-gray-400 hover:text-gray-600 transition-colors">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
              </svg>
            </button>
          </div>
          
          <div class="modal-body">
            <div class="text-center">
              <div class="text-6xl mb-6">❌</div>
              <h3 class="text-2xl font-bold text-gray-900 mb-4">Generation Failed</h3>
              <p class="text-gray-600 mb-8">There was an error generating recommendations. Please try again.</p>
              <button onclick="location.reload()" class="btn btn-primary">Try Again</button>
            </div>
          </div>
          
          <div class="modal-footer">
            <button class="btn btn-ghost" data-action="click->modal#close">Close</button>
          </div>
        </div>
      </div>
    `;
  }

  updateProjectStatusInTable(projectId, status) {
    // Find the project row in the table
    const projectRow = document.querySelector(`[data-project-id="${projectId}"]`)?.closest('tr');
    if (!projectRow) return;

    // Find the status cell (5th column, index 4)
    const statusCell = projectRow.children[4];
    if (!statusCell) return;

    // Update the status badge
    let statusBadge = '';
    switch (status) {
      case 'pending':
        statusBadge = '<span class="badge badge-warning badge-sm">⏳ Pending</span>';
        break;
      case 'processing':
        statusBadge = '<span class="badge badge-info badge-sm">⚙️ Processing</span>';
        break;
      case 'completed':
        statusBadge = '<span class="badge badge-success badge-sm">✓ Completed</span>';
        break;
      case 'failed':
        statusBadge = '<span class="badge badge-danger badge-sm">✗ Failed</span>';
        break;
    }

    if (statusBadge) {
      statusCell.innerHTML = statusBadge;
      
      // Add a subtle animation to highlight the change
      statusCell.classList.add('animate-pulse');
      setTimeout(() => {
        statusCell.classList.remove('animate-pulse');
      }, 2000);
    }
  }

  showSuccessNotification(message) {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = 'fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 transform translate-x-full transition-transform duration-300';
    notification.innerHTML = `
      <div class="flex items-center gap-3">
        <div class="w-6 h-6 bg-green-400 rounded-full flex items-center justify-center">
          <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
          </svg>
        </div>
        <span class="font-semibold">${message}</span>
      </div>
    `;

    // Add to page
    document.body.appendChild(notification);

    // Animate in
    setTimeout(() => {
      notification.classList.remove('translate-x-full');
    }, 100);

    // Auto remove after 4 seconds
    setTimeout(() => {
      notification.classList.add('translate-x-full');
      setTimeout(() => {
        if (notification.parentNode) {
          notification.parentNode.removeChild(notification);
        }
      }, 300);
    }, 4000);
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
