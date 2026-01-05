function showFileName() {
    const fileInput = document.getElementById('replyFile');
    if (fileInput.files.length > 0) {
        document.getElementById('fileNameDisplay').innerText = fileInput.files[0].name;
        document.getElementById('filePreview').style.display = 'block';
    }
}
// 파일 선택 취소
function clearFile() {
    document.getElementById('replyFile').value = '';
    document.getElementById('filePreview').style.display = 'none';
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
