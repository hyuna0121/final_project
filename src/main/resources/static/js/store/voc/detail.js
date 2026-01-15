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

        const result = await response.json();

        if (result.status === 'error') {
            alert(result.message);
            return;
        } else if (result.status === 'fail') {
            alert("오류가 발생했습니다.");
            return;
        }

        alert("등록되었습니다.");
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

function deleteProcess(processId) {
    if (!confirm("정말 이 댓글을 삭제하시겠습니까?")) return;

    fetch('/store/voc/deleteProcess', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'processId=' + processId
        })
        .then(response => {
            if (response.ok) {
                const result = response.json();

                if (result.status === 'error') {
                    alert(result.message);
                    return;
                }

                alert("삭제되었습니다.");
                location.reload();
            } else {
                alert("삭제에 실패했습니다.");
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert("서버 통신 중 오류가 발생했습니다.");
        });
}
