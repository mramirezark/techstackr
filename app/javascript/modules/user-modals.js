// User Management Modals Module
// Handles all user management modal functionality

import { ModalUtils } from './modal-utils.js';

export class UserModals {
  constructor() {
    this.initializeNewUser();
    this.initializeEditUser();
    this.initializeDeleteUser();
  }

  initializeNewUser() {
    const newUserButtons = document.querySelectorAll('[data-action="showNewUserModal"]');
    
    newUserButtons.forEach(button => {
      button.addEventListener('click', async (e) => {
        e.preventDefault();
        
        const modalContent = document.getElementById('modal-content');
        
        if (!modalContent) return;
        
        const result = await ModalUtils.fetchModal(
          '/admin/users/modal_new',
          modalContent,
          'Loading form...'
        );
        
        if (result.success) {
          this.attachNewUserFormHandler();
        }
      });
    });
  }

  initializeEditUser() {
    const editUserButtons = document.querySelectorAll('[data-action="showEditUserModal"]');
    
    editUserButtons.forEach(button => {
      button.addEventListener('click', async (e) => {
        e.preventDefault();
        
        const userId = button.dataset.userId;
        const username = button.dataset.username;
        const modalContent = document.getElementById('modal-content');
        
        if (!modalContent || !userId) return;
        
        const result = await ModalUtils.fetchModal(
          `/admin/users/${userId}/modal_edit`,
          modalContent,
          'Loading user details...'
        );
        
        if (result.success) {
          this.attachEditUserFormHandler();
        }
      });
    });
  }

  initializeDeleteUser() {
    const deleteUserButtons = document.querySelectorAll('[data-action="showDeleteUserModal"]');
    
    deleteUserButtons.forEach(button => {
      button.addEventListener('click', async (e) => {
        e.preventDefault();
        
        const userId = button.dataset.userId;
        const username = button.dataset.username;
        const modalContent = document.getElementById('modal-content');
        
        if (!modalContent || !userId) return;
        
        const result = await ModalUtils.fetchModal(
          `/admin/users/${userId}/modal_delete`,
          modalContent,
          'Loading user details...'
        );
        
        if (result.success) {
          this.attachDeleteUserHandler();
        }
      });
    });
  }

  attachEditUserFormHandler() {
    const form = document.getElementById('edit-user-form');
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
        successTitle: 'User Updated!',
        successMessage: 'User has been successfully updated.',
        submitText: '<span>Update User</span>'
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

  attachNewUserFormHandler() {
    const form = document.getElementById('new-user-form');
    if (!form) return;
    
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      
      const modalContent = document.getElementById('modal-content');
      
      // Hide previous errors
      const errorContainer = form.querySelector('#form-errors');
      if (errorContainer) {
        errorContainer.classList.add('hidden');
      }
      
      const result = await ModalUtils.submitForm(form, '/admin/users', modalContent, {
        loadingText: 'Creating...',
        successTitle: 'User Created!',
        successMessage: 'User has been successfully created.',
        submitText: '<span>Create User</span>'
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

  attachDeleteUserHandler() {
    const confirmInput = document.getElementById('confirm-delete-input');
    const confirmBtn = document.getElementById('confirm-delete-btn');
    
    if (!confirmInput || !confirmBtn) return;
    
    const expectedUsername = confirmBtn.dataset.username;
    
    // Enable/disable delete button based on input
    confirmInput.addEventListener('input', (e) => {
      if (e.target.value === expectedUsername) {
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
      
      if (confirmInput.value !== expectedUsername) return;
      
      const userId = confirmBtn.dataset.userId;
      const modalContent = document.getElementById('modal-content');
      
      // Disable button and show loading
      confirmBtn.disabled = true;
      confirmBtn.innerHTML = '<span>Deleting...</span>';
      
      try {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        
        const response = await fetch(`/admin/users/${userId}`, {
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
            'User Deleted!',
            data.message,
            data.redirect_url
          );
          
        } else {
          // Show error message
          ModalUtils.hideModal(modalContent.querySelector('.modal-overlay'));
          
          // Show error alert
          alert(data.message || 'Failed to delete user. Please try again.');
          
          // Reset button
          confirmBtn.disabled = false;
          confirmBtn.innerHTML = '<span>Delete User</span>';
        }
      } catch (error) {
        console.error('Error deleting user:', error);
        
        // Show error message
        alert('An error occurred while deleting the user. Please try again.');
        
        // Reset button
        confirmBtn.disabled = false;
        confirmBtn.innerHTML = '<span>Delete User</span>';
      }
    });
  }
}
