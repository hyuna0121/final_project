//전역변수 선언
var currentContractData = null;
var deletedFileIds = [];
var isContractUpdated = false;

document.addEventListener("DOMContentLoaded", function() {
	const detailModal = document.getElementById('detailContractModal');
    if (detailModal) {
        detailModal.addEventListener('hidden.bs.modal', function () {
            cancelEditMode();

            if (isContractUpdated) {
                location.reload(); 
                isContractUpdated = false;
            }
        });
    }
});

// 금액 formatter
function formatCurrency(amount) {
    if (amount === undefined || amount === null) return "0 원";
    return new Intl.NumberFormat('ko-KR').format(amount) + " 원";
}

function getFileIconClass(fileName) {
    if (!fileName) return "bx bxs-file-blank text-secondary";
    if (fileName.includes('.pdf')) return "bx bxs-file-pdf text-danger";
    if (fileName.match(/\.(jpg|jpeg|png)$/i)) return "bx bxs-file-image text-primary";
    return "bx bxs-file-blank text-secondary";
}

function getContractStatusByDate(startDateStr) {
    if (!startDateStr) return 1; // 기본값에 대한 확인 필요
    
    const startDate = new Date(startDateStr);
    startDate.setHours(0, 0, 0, 0);
    
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    return startDate > today ? 0 : 1;
}

function appendFileField(containerId, inputName) {
    const container = document.getElementById(containerId);
    if (!container) return;

    const newDiv = document.createElement('div');
    newDiv.className = 'input-group mb-2';
    newDiv.innerHTML = `
        <input type="file" class="form-control" name="${inputName}">
        <button type="button" class="btn btn-outline-danger" onclick="this.parentElement.remove()">
            <i class="bx bx-minus"></i>
        </button>
    `;
    container.appendChild(newDiv);
}

async function fetchJson(url, options = {}) {
    const response = await fetch(url, options);
    if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
    return response.json();
}

async function searchStore() {
    const keyword = document.getElementById("storeNameInput").value.trim();
    const resultListElement = document.getElementById("storeResultList");

    if (!keyword) {
        alert("검색어를 입력해주세요.");
        return;
    }

    try {
        const params = new URLSearchParams({
            keyword: keyword,
            isManager: 0
        });
		const data = await 	fetchJson(`/store/search?${params.toString()}`, {
            method: "GET",
            headers: { "Content-Type": "application/json" }
        });
				
        let listHtml = "";

        if (data.length === 0) {
            listHtml = `<li class="list-group-item text-muted">검색 결과가 없습니다.</li>`;
        } else {
            data.forEach(store => {
                listHtml += `
                    <li class="list-group-item list-group-item-action d-flex align-items-center cursor-pointer" 
                        onclick="selectStore('${store.storeId}', '${store.storeName}', '${store.memName}')">
                        <div class="avatar avatar-sm me-2">
                            <span class="avatar-initial rounded-circle bg-label-primary">
                                ${store.storeName.charAt(0)}
                            </span>
                        </div>
                        <div class="d-flex flex-column">
                            <span class="fw-bold">${store.storeName}</span>
                            <small class="text-muted">${store.memName}</small>
                        </div>
                    </li>
                `;
            });
        }

        resultListElement.innerHTML = listHtml;
        resultListElement.style.display = 'block';

    } catch (error) {
        console.error("Fetch Error:", error);
        alert("가맹점 검색 중 오류가 발생했습니다.");
    }
}

function selectStore(id, name, member) {
    document.getElementById("storeId").value = id;
    document.getElementById("storeNameInput").value = `${name} (${member})`;
    document.getElementById("storeResultList").style.display = 'none';
}

document.addEventListener('click', function(e) {
    const target = e.target;
    const isInputGroup = target.closest('.input-group');
    const isResultList = target.closest('#storeResultList');

    if (!isInputGroup && !isResultList) {
        const listEl = document.getElementById('storeResultList');
        if (listEl) listEl.style.display = 'none';
    }
});

function addFileField() {
	appendFileField('fileContainer', 'contractFiles')
}

(function() {
    const registerModalEl = document.getElementById('registerContractModal');
    
    if (registerModalEl) {
        registerModalEl.addEventListener('hidden.bs.modal', function () {
            const form = document.getElementById('registerContractForm');
            if (form) form.reset();

            const storeIdEl = document.getElementById('storeId');
            if (storeIdEl) storeIdEl.value = '';
            
            const resultList = document.getElementById('storeResultList');
            if (resultList) {
                resultList.style.display = 'none';
                resultList.innerHTML = '';
            }

            const fileContainer = document.getElementById('fileContainer');
            if (fileContainer) {
                fileContainer.innerHTML = `
                    <div class="input-group mb-2">
                        <input type="file" class="form-control" name="contractFiles">
                        <button type="button" class="btn btn-outline-primary" onclick="addFileField()">
                            <i class="bx bx-plus"></i>
                        </button>
                    </div>
                `;
            }
        });
    }
})();

async function submitContractRegistration() {
    const els = {
        storeId: document.getElementById('storeId'),
        royalti: document.getElementById('royalti'),
        deposit: document.getElementById('deposit'),
        startDate: document.getElementById('startDate'),
        endDate: document.getElementById('endDate'),
    };

    if (!els.storeId.value) { alert("가맹점명을 선택해주세요."); return; }
    if (!els.royalti.value) { alert("로얄티를 입력해주세요."); return; }
    if (!els.deposit.value) { alert("여신(보증금)을 입력해주세요."); return; }
    if (!els.startDate.value || !els.endDate.value) { alert("계약기간을 입력해주세요."); return; }

    const formData = new FormData();
    formData.append("storeId", els.storeId.value);
    formData.append("contractRoyalti", els.royalti.value);
    formData.append("contractDeposit", els.deposit.value);
    formData.append("contractStartDate", els.startDate.value);
    formData.append("contractEndDate", els.endDate.value);
	
	const status = getContractStatusByDate(els.startDate.value);
    formData.append("contractStatus", status);

    const fileInputs = document.getElementsByName("contractFiles");
    for (let input of fileInputs) {
        if (input.files.length > 0) {
            formData.append("files", input.files[0]); // fileInputs 태그에서 파일 객체 자체를 append 
        }
    }

    try {
        const response = await fetch('/store/contract/add', {
            method: 'POST',
            body: formData
        });

        if (!response.ok) throw new Error(`서버 오류: ${response.status}`);
        
        alert("계약이 성공적으로 등록되었습니다.");
        
        const modalEl = document.getElementById('registerContractModal');
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        if (modalInstance) modalInstance.hide();
        
        location.reload();
    } catch (error) {
        console.error('Error:', error);
        alert("등록 중 오류가 발생했습니다.");
    }
}

async function getContractDetail(contractId) {
    try {
		const data = await fetchJson(`/store/contract/detail?contractId=${contractId}`, { method: "GET" });
        
		// 전역 변수에 저장
        currentContractData = data; 

        document.getElementById('detailContractId').innerText = data.contractId;
        document.getElementById('detailStoreName').innerText = data.storeName;
		document.getElementById('detailMemName').innerText = data.memName;
		document.getElementById('detailStoreAddress').innerText = data.storeAddress;
        document.getElementById('detailStartDate').innerText = data.contractStartDate;
        document.getElementById('detailEndDate').innerText = data.contractEndDate;
        document.getElementById('detailRoyalty').innerText = formatCurrency(data.contractRoyalti);
        document.getElementById('detailDeposit').innerText = formatCurrency(data.contractDeposit);

        const statusArea = document.getElementById('detailStatusArea');
        let badgeHtml = '';
        switch (data.contractStatus) {
            case 0: badgeHtml = '<span class="badge bg-label-warning">PENDING</span>'; break;
            case 1: badgeHtml = '<span class="badge bg-label-info">ACTIVE</span>'; break;
            case 2: badgeHtml = '<span class="badge bg-label-danger">EXPIRED</span>'; break;
            default: badgeHtml = '<span class="badge bg-label-secondary">UNKNOWN</span>';
        }
        statusArea.innerHTML = badgeHtml;
		
		const viewContainer = document.getElementById('detailFileList_view');
	    viewContainer.innerHTML = ""; 

	    if (data.fileDTOs && data.fileDTOs.length > 0) {
	        data.fileDTOs.forEach(file => {
	            const li = document.createElement('li');
	            li.className = "list-group-item d-flex justify-content-between align-items-center"; 

	            const iconClass = getFileIconClass(file.fileOriginalName);

	            li.innerHTML = `
	                <div class="d-flex align-items-center overflow-hidden">
	                    <i class="${iconClass} fs-4 me-2"></i>
	                    <span class="text-truncate">${file.fileOriginalName}</span>
	                </div>
	                <button class="btn btn-sm btn-outline-primary ms-2" onclick="downloadAttachment('${file.fileSavedName}', '${file.fileOriginalName}')">
	                    <i class="bx bx-download"></i> 다운로드
	                </button>
	            `;
	            viewContainer.appendChild(li);
	        });
	    } else {
	        viewContainer.innerHTML = `<li class="list-group-item text-muted small text-center bg-light">첨부된 파일이 없습니다.</li>`;
	    }

        const modalEl = document.getElementById('detailContractModal');
		let modal = bootstrap.Modal.getInstance(modalEl);
		if (!modal) {
	        modal = new bootstrap.Modal(modalEl);
		}
			
        modal.show();
    } catch (error) {
        console.error("계약 상세 조회 오류 : ", error);
        alert("계약 상세 정보를 불러오는데 실패했습니다.");
    }
}

function downloadAttachment(fileSavedName, fileOriginalName) {
    if (!fileSavedName || !fileOriginalName) {
        alert("파일 정보가 올바르지 않습니다.");
        return;
    }
    const url = `/fileDownload/contract?fileSavedName=${encodeURIComponent(fileSavedName)}&fileOriginalName=${encodeURIComponent(fileOriginalName)}`;
    location.href = url;
}

function downloadContractPdf() {
    if (!currentContractData) {
        alert("계약 상세 정보를 찾을 수 없습니다.");
        return;
    }

    const data = currentContractData; // 전역 변수 참조

    document.getElementById('pdfContractId').innerText = data.contractId;
    document.getElementById('pdfStoreName').innerText = data.storeName;
    document.getElementById('pdfStoreNameTable').innerText = data.storeName;
    
	if(document.getElementById('pdfStoreAddress')) {
        document.getElementById('pdfStoreAddress').innerText = data.storeAddress;
	}
    
    document.getElementById('pdfStartDate').innerText = data.contractStartDate;
    document.getElementById('pdfEndDate').innerText = data.contractEndDate;
    document.getElementById('pdfRoyalty').innerText = formatCurrency(data.contractRoyalti);
    document.getElementById('pdfDeposit').innerText = formatCurrency(data.contractDeposit);

    document.getElementById('pdfSignStoreName').innerText = data.storeName;
    document.getElementById('pdfSignOwner').innerText = data.memName;
    document.getElementById('pdfSignAddress').innerText = data.storeAddress;

	const [year, month, day] = data.contractStartDate.split('-');
    document.getElementById('pdfCreatedAt').innerText = `${year}년 ${month}월 ${day}일`;

    // html2pdf 변환 및 다운로드
    const element = document.getElementById('contractPdfTemplate');
    const opt = {
        margin:       0,
        filename:     `가맹계약서_${data.contractId}_${data.storeName}.pdf`,
        image:        { type: 'jpeg', quality: 1 },
        html2canvas:  { scale: 2, scrollY: 0 },
        jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };

    html2pdf().set(opt).from(element).save();
}

function enableEditMode() {
    if (!currentContractData) return;
	
	const pdfBtn = document.getElementById('btnPdfDownload');
	
	pdfBtn.style.transition = 'none';
	pdfBtn.classList.add('invisible');

    document.querySelectorAll('.mode-view').forEach(el => el.classList.add('d-none'));
    document.querySelectorAll('.mode-edit').forEach(el => el.classList.remove('d-none'));

    document.getElementById('btnEditMode').classList.add('d-none');
    document.getElementById('btnCloseModal').classList.add('d-none');
    
    document.getElementById('btnSaveContract').classList.remove('d-none');
    document.getElementById('btnCancelEdit').classList.remove('d-none');
	
	document.getElementById('titleArea').innerText='가맹 계약 정보 수정';
	
	deletedFileIds = [];
	
    const existingContainer = document.getElementById('existingFileContainer');
    existingContainer.innerHTML = "";

    if (currentContractData.fileDTOs && currentContractData.fileDTOs.length > 0) {
        currentContractData.fileDTOs.forEach(file => {
            const li = document.createElement('li');
            li.className = "list-group-item d-flex justify-content-between align-items-center";
            li.id = `file-item-${file.fileId}`;
			
			const iconClass = getFileIconClass(file.fileOriginalName);

            li.innerHTML = `
                <div class="d-flex align-items-center overflow-hidden">
                    <i class="${iconClass} fs-4 me-2"></i> <span class="text-truncate text-muted">${file.fileOriginalName}</span>
                </div>
                <button class="btn btn-sm btn-outline-danger ms-2" type="button" onclick="markFileAsDeleted(${file.fileId})">
                    <i class="bx bx-trash"></i> 삭제
                </button>
            `;
            existingContainer.appendChild(li);
        });
    }
	
    const newContainer = document.getElementById('newFileContainer');
    newContainer.innerHTML = "";
	addEditFileField();

    document.getElementById('editStartDate').value = currentContractData.contractStartDate;
    document.getElementById('editEndDate').value = currentContractData.contractEndDate;
    document.getElementById('editRoyalty').value = currentContractData.contractRoyalti;
    document.getElementById('editDeposit').value = currentContractData.contractDeposit;
}

function cancelEditMode() {
    document.querySelectorAll('.mode-view').forEach(el => el.classList.remove('d-none'));
    document.querySelectorAll('.mode-edit').forEach(el => el.classList.add('d-none'));

    document.getElementById('btnEditMode').classList.remove('d-none');
    document.getElementById('btnCloseModal').classList.remove('d-none');
	document.getElementById('btnPdfDownload').classList.remove('invisible');
    
    document.getElementById('btnSaveContract').classList.add('d-none');
    document.getElementById('btnCancelEdit').classList.add('d-none');
	
	document.getElementById('titleArea').innerText='가맹 계약 정보';
}

function addEditFileField() {
	appendFileField('newFileContainer', 'editContractFiles');
}

function markFileAsDeleted(fileId) {
    if(confirm("이 파일을 삭제하시겠습니까? (저장 버튼을 눌러야 최종 반영됩니다)")) {
        deletedFileIds.push(fileId);
        
        const fileItem = document.getElementById(`file-item-${fileId}`);
        if(fileItem) fileItem.classList.add('d-none');
    }
}

async function updateContract() {
    const contractId = currentContractData.contractId;
    const startDate = document.getElementById('editStartDate').value;
    const endDate = document.getElementById('editEndDate').value;
    const royalty = document.getElementById('editRoyalty').value;
    const deposit = document.getElementById('editDeposit').value;

	if (!royalty) { alert("로얄티를 입력해주세요."); return; }
	if (!deposit) { alert("여신(보증금)을 입력해주세요."); return; }
	if (!startDate || !endDate) { alert("계약기간을 입력해주세요."); return; }
	
	const status = getContractStatusByDate(startDate);
	
	const formData = new FormData();
	
	formData.append("contractId", contractId);
	formData.append("contractStartDate", startDate);
	formData.append("contractEndDate", endDate);
	formData.append("contractRoyalti", parseInt(royalty));
	formData.append("contractDeposit", parseInt(deposit));
	formData.append("contractStatus", status);
	
	if (deletedFileIds.length > 0) {
		deletedFileIds.forEach(id => {
			formData.append("deleteFileIds", id);
		});
	}
	
	const fileInputs = document.getElementsByName("editContractFiles");
	for (let input of fileInputs) {
		if (input.files.length > 0) {
			formData.append("newFiles", input.files[0]);
		}
	}

    try {
        const response = await fetch('/store/contract/update', { 
            method: 'POST',
            body: formData
        });

        if (!response.ok) throw new Error(`서버 오류: ${response.status}`);

        alert("계약 정보가 수정되었습니다.");

		isContractUpdated = true;
        await getContractDetail(contractId);
        cancelEditMode(); 
        
    } catch (error) {
        console.error("수정 실패:", error);
        alert("정보 수정 중 오류가 발생했습니다.");
    }
}

function searchVoc() {
    document.getElementById("page").value = 1;
    document.getElementById("contractSearchForm").submit();
}

function resetSearchForm() {
	const inputs = document.querySelectorAll('#contractSearchForm input');
    inputs.forEach(input => input.value = '');
	
	const selects = document.querySelectorAll('#contractSearchForm select');
    selects.forEach(select => select.selectedIndex = 0);

    if(document.getElementById('page')) {
        document.getElementById('page').value = 1;
    }
}

function movePage(page) {
    if (page < 1) page = 1;

    const form = document.getElementById('contractSearchForm');
    const formData = new FormData(form);
    const params = new URLSearchParams(formData);

    params.set('page', page);

    const currentUrlParams = new URLSearchParams(window.location.search);
    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            params.append(key, value);
        }
    });

    location.href = form.action + '?' + params.toString();
}

function downloadExcel() {
    const form = document.getElementById('contractSearchForm');
    const params = new URLSearchParams(new FormData(form));

    const currentUrlParams = new URLSearchParams(window.location.search);

    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            params.append(key, value);
        }
    });

    location.href = '/store/contract/downloadExcel?' + params.toString();
}

function changePerPage(val) {
    document.querySelector('#hiddenPerPage').value = val;
    document.querySelector('#page').value = 1;
    const form = document.getElementById('contractSearchForm');
    const formData = new FormData(form);
    const params = new URLSearchParams(formData);

    const currentUrlParams = new URLSearchParams(window.location.search);
    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            params.append(key, value);
        }
    });

    location.href = form.action + '?' + params.toString();
}