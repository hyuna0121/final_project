let accumulatedFiles = [];

function showFileName() {
    const fileInput = document.getElementById('replyFile');
    const newFiles = Array.from(fileInput.files);
    
    accumulatedFiles = accumulatedFiles.concat(newFiles);

    fileInput.value = '';
    renderFilePreview();
}

function renderFilePreview() {
    const filePreview = document.getElementById('filePreview');
    filePreview.innerHTML = '';

    if (accumulatedFiles.length > 0) {
        filePreview.style.display = 'flex';

        accumulatedFiles.forEach((file, index) => {
            const fileTag = document.createElement('div');
            fileTag.className = 'border rounded px-2 py-1 bg-light d-flex align-items-center small shadow-sm';
            fileTag.style.fontSize = '0.85rem';

            fileTag.innerHTML = `
                <i class="bx bx-file me-2 text-secondary"></i>
                <span class="me-2">${file.name}</span>
                <button type="button" class="btn-close btn-close-sm" aria-label="Close" onclick="removeFile(${index})"></button>
            `;
            filePreview.appendChild(fileTag);
        });
    } else {
        filePreview.style.display = 'none';
    }
}

function removeFile(targetIndex) {
    accumulatedFiles.splice(targetIndex, 1);
    renderFilePreview();
}


async function fetchJson(url, options = {}) {
    const response = await fetch(url, options);
    if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
    return response.json();
}

async function submitVocRegistration() {
    const storeId = document.getElementById('storeId').value;
    const vocType = document.getElementById('vocType').value;
    const vocContact = document.getElementById('vocContact').value;
	const vocTitle = document.getElementById('vocTitle').value;
	const vocContents = document.getElementById('vocContents').value;
    
    if (!storeId) {
        alert("가맹점명을 선택해주세요.");
        return;
    }
    if (!vocType) {
        alert("불만유형을 선택해주세요.");
        return;
    }
    if (!vocContact) {
        alert("고객연락처를 입력해주세요.");
        return;
    }
    if (!vocTitle) {
        alert("제목을 입력해주세요.");
        return;
    }
    if (!vocContents) {
        alert("내용을 입력해주세요.");
        return;
    }

    const formData = {
        storeId: storeId,
        vocType: vocType, 
        vocContact: vocContact,
        vocTitle: vocTitle,
        vocContents: vocContents
    };

    try {
        const response = await fetch('/store/voc/add', { 
            method: 'POST',
            headers: {
                'Content-Type': 'application/json', 
				},
            body: JSON.stringify(formData)
        });

        if (!response.ok) {
            throw new Error(`서버 오류: ${response.status}`);
        }

        const result = await response.json();

        alert("VOC가 성공적으로 등록되었습니다.");
        
        const modalEl = document.getElementById('registerVocModal');
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        if (modalInstance) {
            modalInstance.hide();
        }
        
        location.reload();

    } catch (error) {
        console.error('Error:', error);
        alert("등록 중 오류가 발생했습니다.");
    }
}

async function submitVocProcess() {
    const vocId = document.getElementById('vocId').value;
    const processContents = document.getElementById('processContents').value;
    const isFirst = document.getElementById('isFirst').value;
    
    if (!processContents) {
        alert("내용을 입력해주세요.");
        return;
    }
	
	const formData = new FormData();
	formData.append("vocId", vocId);
	formData.append("processContents", processContents);
    formData.append("isFirst", isFirst);
	
	if (typeof accumulatedFiles !== 'undefined' && accumulatedFiles.length > 0) {
        accumulatedFiles.forEach(file => {
            formData.append("files", file); 
        });
    }

    try {
        const response = await fetch('/store/voc/addProcess', { 
            method: 'POST',
            body: formData
        });

        if (!response.ok) {
            throw new Error(`서버 오류: ${response.status}`);
        }

        location.reload();

    } catch (error) {
        console.error('Error:', error);
        alert("등록 중 오류가 발생했습니다.");
    }
}

function previewFile(fileName, savedName) {
    const ext = fileName.split('.').pop().toLowerCase();
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];

    const previewModal = new bootstrap.Modal(document.getElementById('imagePreviewModal'));
    const imgEl = document.getElementById('previewImage');
    const msgEl = document.getElementById('noPreviewMsg');
	
	const downloadBtn = document.getElementById('modalDownloadBtn');

    downloadBtn.href = `/fileDownload/vocImageDownload?fileSavedName=${encodeURIComponent(savedName)}&fileOriginalName=${encodeURIComponent(fileName)}`;

    if (imageExtensions.includes(ext)) {
        imgEl.src = '/fileDownload/vocImage?fileSavedName=' + savedName;
        
        imgEl.classList.remove('d-none');
        msgEl.classList.add('d-none');
    } else {
        imgEl.classList.add('d-none');
        msgEl.classList.remove('d-none');
    }

    previewModal.show();
}
