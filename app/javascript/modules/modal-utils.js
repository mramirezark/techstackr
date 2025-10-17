// Modal Utilities Module
// Handles common modal functionality and utilities

export class ModalUtils {
  static showModal(modalElement) {
    if (!modalElement) return;
    
    modalElement.classList.remove('hidden');
    document.body.classList.add('modal-open');
  }

  static hideModal(modalElement) {
    if (!modalElement) return;
    
    modalElement.classList.add('hidden');
    document.body.classList.remove('modal-open');
  }

  static attachCloseListeners(modalElement) {
    if (!modalElement) return;

    // Close buttons
    const closeButtons = modalElement.querySelectorAll('.modal-close, [data-action*="close"]');
    closeButtons.forEach(closeBtn => {
      closeBtn.addEventListener('click', () => {
        this.hideModal(modalElement);
      });
    });
    
    // Backdrop click
    modalElement.addEventListener('click', (e) => {
      if (e.target === modalElement) {
        this.hideModal(modalElement);
      }
    });

    // ESC key
    const handleEsc = (e) => {
      if (e.key === 'Escape' && !modalElement.classList.contains('hidden')) {
        this.hideModal(modalElement);
        document.removeEventListener('keydown', handleEsc);
      }
    };
    document.addEventListener('keydown', handleEsc);
  }

  static showLoadingModal(modalContent, message = 'Loading...') {
    modalContent.innerHTML = `
      <div class="modal-overlay modal-fade-in">
        <div class="modal-container modal-scale-in">
          <div class="modal-body">
            <div class="flex items-center justify-center py-12">
              <div class="loading-spinner"></div>
              <span class="ml-3 text-gray-600">${message}</span>
            </div>
          </div>
        </div>
      </div>
    `;
    
    const modal = modalContent.querySelector('.modal-overlay');
    this.showModal(modal);
    return modal;
  }

  static showErrorModal(modalContent, title = 'Error', message = 'An error occurred. Please try again.') {
    modalContent.innerHTML = `
      <div class="modal-overlay modal-fade-in">
        <div class="modal-container modal-scale-in">
          <div class="modal-body">
            <div class="flex items-center justify-center py-12">
              <div class="text-center">
                <div class="text-6xl mb-4">⚠️</div>
                <h3 class="text-xl font-semibold text-gray-900 mb-2">${title}</h3>
                <p class="text-gray-600">${message}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
    
    const modal = modalContent.querySelector('.modal-overlay');
    this.showModal(modal);
    this.attachCloseListeners(modal);
    return modal;
  }

  static showSuccessModal(modalContent, title = 'Success!', message = 'Operation completed successfully.', redirectUrl = null, delay = 1500) {
    modalContent.innerHTML = `
      <div class="modal-overlay modal-fade-in">
        <div class="modal-container modal-scale-in">
          <div class="modal-body">
            <div class="flex items-center justify-center py-12">
              <div class="text-center">
                <div class="text-6xl mb-4">✅</div>
                <h3 class="text-xl font-semibold text-gray-900 mb-2">${title}</h3>
                <p class="text-gray-600">${message}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
    
    const modal = modalContent.querySelector('.modal-overlay');
    this.showModal(modal);
    
    if (redirectUrl) {
      setTimeout(() => {
        window.location.href = redirectUrl;
      }, delay);
    }
    
    return modal;
  }

  static async fetchModal(url, modalContent, loadingMessage = 'Loading...') {
    try {
      this.showLoadingModal(modalContent, loadingMessage);
      
      const response = await fetch(url, {
        method: 'GET',
        headers: {
          'Accept': 'text/html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      });
      
      if (response.ok) {
        const html = await response.text();
        modalContent.innerHTML = html;
        
        const modal = modalContent.querySelector('.modal-overlay');
        if (modal) {
          this.showModal(modal);
          this.attachCloseListeners(modal);
          return { success: true, modal };
        }
      }
      
      throw new Error('Failed to load modal content');
    } catch (error) {
      console.error('Error fetching modal:', error);
      this.showErrorModal(modalContent, 'Error Loading', 'Unable to load content. Please try again.');
      return { success: false, error };
    }
  }

  static async submitForm(form, url, modalContent, options = {}) {
    const {
      method = 'POST',
      loadingText = 'Processing...',
      successTitle = 'Success!',
      successMessage = 'Operation completed successfully.',
      redirectUrl = null
    } = options;

    try {
      const formData = new FormData(form);
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      
      // Show loading state
      const submitBtn = form.querySelector('button[type="submit"], input[type="submit"]');
      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = `<span>${loadingText}</span>`;
      }
      
      const response = await fetch(url, {
        method: method,
        headers: {
          'X-CSRF-Token': csrfToken,
          'X-Requested-With': 'XMLHttpRequest',
          'Accept': 'application/json'
        },
        body: formData
      });
      
      const data = await response.json();
      
      if (data.success) {
        this.hideModal(modalContent.querySelector('.modal-overlay'));
        
        if (redirectUrl === null) {
          // Special case: refresh the page instead of redirecting
          this.showSuccessModal(modalContent, successTitle, data.message || successMessage, null, 1000);
          setTimeout(() => {
            window.location.reload();
          }, 1000);
        } else if (redirectUrl || data.redirect_url) {
          this.showSuccessModal(modalContent, successTitle, data.message || successMessage, redirectUrl || data.redirect_url);
        }
        
        return { success: true, data };
      } else {
        // Show validation errors
        const errorContainer = form.querySelector('#form-errors');
        const errorList = form.querySelector('#error-list');
        
        if (errorContainer && errorList && data.errors) {
          errorList.innerHTML = '';
          data.errors.forEach(error => {
            const li = document.createElement('li');
            li.textContent = error;
            errorList.appendChild(li);
          });
          errorContainer.classList.remove('hidden');
        }
        
        return { success: false, errors: data.errors };
      }
    } catch (error) {
      console.error('Error submitting form:', error);
      return { success: false, error: error.message };
    } finally {
      // Re-enable submit button
      const submitBtn = form.querySelector('button[type="submit"], input[type="submit"]');
      if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.innerHTML = options.submitText || '<span>Submit</span>';
      }
    }
  }
}
