// Simple modal functionality without external dependencies
document.addEventListener('DOMContentLoaded', function() {
  // Modal functionality
  const modalOverlays = document.querySelectorAll('.modal-overlay');
  
  modalOverlays.forEach(overlay => {
    const closeButtons = overlay.querySelectorAll('.modal-close, [data-action*="close"]');
    closeButtons.forEach(button => {
      button.addEventListener('click', () => {
        overlay.classList.add('hidden');
        document.body.classList.remove('modal-open');
      });
    });
    
    // Close on backdrop click
    overlay.addEventListener('click', (e) => {
      if (e.target === overlay) {
        overlay.classList.add('hidden');
        document.body.classList.remove('modal-open');
      }
    });
    
    // Close on escape key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && !overlay.classList.contains('hidden')) {
        overlay.classList.add('hidden');
        document.body.classList.remove('modal-open');
      }
    });
  });
  
  // Project details modal functionality
  const projectButtons = document.querySelectorAll('[data-action*="showProjectDetails"]');
  
  projectButtons.forEach(button => {
    button.addEventListener('click', async (e) => {
      e.preventDefault();
      
      const projectId = button.dataset.projectId;
      const modalContent = document.getElementById('modal-content');
      
      if (!modalContent) return;
      
      // Show loading state
      modalContent.innerHTML = `
        <div class="modal-overlay modal-fade-in">
          <div class="modal-container modal-scale-in">
            <div class="modal-body">
              <div class="flex items-center justify-center py-12">
                <div class="loading-spinner"></div>
                <span class="ml-3 text-gray-300">Loading project details...</span>
              </div>
            </div>
          </div>
        </div>
      `;
      
      // Show modal
      const modal = modalContent.querySelector('.modal-overlay');
      modal.classList.remove('hidden');
      document.body.classList.add('modal-open');
      
      try {
        const response = await fetch(`/projects/${projectId}/modal_details`, {
          method: 'GET',
          headers: {
            'Accept': 'text/html',
            'X-Requested-With': 'XMLHttpRequest'
          }
        });
        
        if (response.ok) {
          const html = await response.text();
          modalContent.innerHTML = html;
          
          // Re-attach event listeners to the new modal
          const newModal = modalContent.querySelector('.modal-overlay');
          if (newModal) {
            newModal.classList.remove('hidden');
            
            // Add close functionality to new modal
            const closeButtons = newModal.querySelectorAll('.modal-close, [data-action*="close"]');
            closeButtons.forEach(closeBtn => {
              closeBtn.addEventListener('click', () => {
                newModal.classList.add('hidden');
                document.body.classList.remove('modal-open');
              });
            });
            
            // Close on backdrop click
            newModal.addEventListener('click', (e) => {
              if (e.target === newModal) {
                newModal.classList.add('hidden');
                document.body.classList.remove('modal-open');
              }
            });
          }
        } else {
          // Show error state
          modalContent.innerHTML = `
            <div class="modal-overlay modal-fade-in">
              <div class="modal-container modal-scale-in">
                <div class="modal-body">
                  <div class="flex items-center justify-center py-12">
                    <div class="text-center">
                      <div class="text-6xl mb-4">⚠️</div>
                      <h3 class="text-xl font-semibold text-white mb-2">Error Loading Project</h3>
                      <p class="text-gray-300">Unable to load project details. Please try again.</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          `;
        }
      } catch (error) {
        console.error('Error fetching project details:', error);
        // Show error state
        modalContent.innerHTML = `
          <div class="modal-overlay modal-fade-in">
            <div class="modal-container modal-scale-in">
              <div class="modal-body">
                <div class="flex items-center justify-center py-12">
                  <div class="text-center">
                    <div class="text-6xl mb-4">⚠️</div>
                    <h3 class="text-xl font-semibold text-white mb-2">Error Loading Project</h3>
                    <p class="text-gray-300">Unable to load project details. Please try again.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        `;
      }
    });
  });
});
