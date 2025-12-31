var currentContractData = null;

// 금액 formatter
function formatCurrency(amount) {
    if (amount === undefined || amount === null) return "0 원";
    return new Intl.NumberFormat('ko-KR').format(amount) + " 원";
}

async function searchStore() {
    const keyword = document.getElementById("storeNameInput").value.trim();
    const resultListElement = document.getElementById("storeResultList");

    if (!keyword) {
        alert("검색어를 입력해주세요.");
        return;
    }

    try {
        const params = new URLSearchParams({ keyword: keyword });
        const response = await fetch(`/store/tab/store/search/store?${params.toString()}`, {
            method: "GET",
            headers: { "Content-Type": "application/json" }
        });

        if (!response.ok) throw new Error(`서버 오류: ${response.status}`);

        const data = await response.json();
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
    const container = document.getElementById('fileContainer');
    const newDiv = document.createElement('div');
    newDiv.className = 'input-group mb-2';
    newDiv.innerHTML = `
        <input type="file" class="form-control" name="contractFiles">
        <button type="button" class="btn btn-outline-danger" onclick="removeFileField(this)">
            <i class="bx bx-minus"></i>
        </button>
    `;
    container.appendChild(newDiv);
}

function removeFileField(button) {
    button.parentElement.remove();
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
        status: document.getElementById('contractStatus')
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
    formData.append("contractStatus", els.status.value);

    const fileInputs = document.getElementsByName("contractFiles");
    for (let input of fileInputs) {
        if (input.files.length > 0) {
            formData.append("files", input.files[0]); // fileInputs 태그에서 파일 객체 자체를 append 
        }
    }

    try {
        const response = await fetch('/store/tab/contract/add', {
            method: 'POST',
            body: formData
        });

        if (!response.ok) throw new Error(`서버 오류: ${response.status}`);
        
        alert("계약이 성공적으로 등록되었습니다.");
        
        const modalEl = document.getElementById('registerContractModal');
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        if (modalInstance) modalInstance.hide();
        
        loadTab('contract');
    } catch (error) {
        console.error('Error:', error);
        alert("등록 중 오류가 발생했습니다.");
    }
}

async function getContractDetail(contractId) {
    try {
        const url = `/store/tab/contract/detail?contractId=${contractId}`;
        const response = await fetch(url, { method: "GET" });

        if (!response.ok) throw new Error(`Error : ${response.status}`);

        const data = await response.json();
        
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

        const fileListEl = document.getElementById('detailFileList');
        fileListEl.innerHTML = "";

        if (data.fileDTOs && data.fileDTOs.length > 0) {
            data.fileDTOs.forEach(file => {
                const li = document.createElement('li');
                li.className = "list-group-item d-flex justify-content-between align-items-center";

                let iconClass = "bx bxs-file-blank text-secondary";
                if (file.fileOriginalName.includes('.pdf')) iconClass = "bx bxs-file-pdf text-danger";
                else if (file.fileOriginalName.match(/\.(jpg|jpeg|png)$/i)) iconClass = "bx bxs-file-image text-primary";

                li.innerHTML = `
                    <div class="d-flex align-items-center">
                        <i class="${iconClass} me-2 fs-4"></i>
                        <span>${file.fileOriginalName}</span>
                    </div>
                    <button class="btn btn-sm btn-outline-primary file-download" onclick="downloadAttachment('${file.fileSavedName}', '${file.fileOriginalName}')">
                        <i class="bx bx-download"></i> 다운로드
                    </button>
                `;
                fileListEl.appendChild(li);
            });
        } else {
            fileListEl.innerHTML = `<li class="list-group-item text-center text-muted">첨부된 파일이 없습니다.</li>`;
        }

        const modalEl = document.getElementById('detailContractModal');
        const modal = new bootstrap.Modal(modalEl);
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
    
    const storeAddr = data.storeAddress;
    const pdfStatusEl = document.getElementById('pdfStoreAddress');
    if(pdfStatusEl) pdfStatusEl.innerText = storeAddr;
    
    document.getElementById('pdfStartDate').innerText = data.contractStartDate;
    document.getElementById('pdfEndDate').innerText = data.contractEndDate;
    document.getElementById('pdfRoyalty').innerText = formatCurrency(data.contractRoyalti);
    document.getElementById('pdfDeposit').innerText = formatCurrency(data.contractDeposit);

    document.getElementById('pdfSignStoreName').innerText = data.storeName;
    document.getElementById('pdfSignOwner').innerText = data.memName;
    document.getElementById('pdfSignAddress').innerText = storeAddr;

    const datePart = data.contractCreatedAt.split('T')[0];
	const [year, month, day] = datePart.split('-');
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

// ==========================================
// 8. 수정 모드 관련 로직
// ==========================================

// 수정 모드 진입
function enableEditMode() {
    if (!currentContractData) return;

    document.getElementById('editStartDate').value = currentContractData.contractStartDate;
    document.getElementById('editEndDate').value = currentContractData.contractEndDate;
    document.getElementById('editRoyalty').value = currentContractData.contractRoyalti;
    document.getElementById('editDeposit').value = currentContractData.contractDeposit;

    document.querySelectorAll('.mode-view').forEach(el => el.classList.add('d-none'));
    document.querySelectorAll('.mode-edit').forEach(el => el.classList.remove('d-none'));

    document.getElementById('btnEditMode').classList.add('d-none');
    document.getElementById('btnCloseModal').classList.add('d-none');
	document.getElementById('btnPdfDownload').classList.add('invisible');
    
    document.getElementById('btnSaveContract').classList.remove('d-none');
    document.getElementById('btnCancelEdit').classList.remove('d-none');
}

function cancelEditMode() {
    document.querySelectorAll('.mode-view').forEach(el => el.classList.remove('d-none'));
    document.querySelectorAll('.mode-edit').forEach(el => el.classList.add('d-none'));

    document.getElementById('btnEditMode').classList.remove('d-none');
    document.getElementById('btnCloseModal').classList.remove('d-none');
	document.getElementById('btnPdfDownload').classList.remove('invisible');
    
    document.getElementById('btnSaveContract').classList.add('d-none');
    document.getElementById('btnCancelEdit').classList.add('d-none');
}

// 수정 사항 저장 (서버 전송)
async function updateContract() {
    // 입력값 가져오기
    const contractId = currentContractData.contractId; // ID는 불변
    const startDate = document.getElementById('editStartDate').value;
    const endDate = document.getElementById('editEndDate').value;
    const royalty = document.getElementById('editRoyalty').value;
    const deposit = document.getElementById('editDeposit').value;

    // 유효성 검사
    if(!startDate || !endDate || !royalty || !deposit) {
        alert("모든 필드를 입력해주세요.");
        return;
    }

    // 전송할 데이터 구성
    const updateData = {
        contractId: contractId,
        contractStartDate: startDate,
        contractEndDate: endDate,
        contractRoyalti: parseInt(royalty),
        contractDeposit: parseInt(deposit)
        // 필요한 경우 storeId 등 다른 필드도 포함
    };

    try {
        const response = await fetch('/store/tab/contract/update', { // ★ 서버 수정 URL 확인 필요
            method: 'POST', // or 'PUT'
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updateData),
        });

        if (!response.ok) throw new Error(`서버 오류: ${response.status}`);

        alert("계약 정보가 수정되었습니다.");

        // 1. 성공 시 데이터 갱신을 위해 상세 조회 다시 실행
        // (화면 갱신 및 전역 변수 업데이트 효과)
        await getContractDetail(contractId);
        
        // 2. 보기 모드로 복귀 (getContractDetail 안에서 모달을 띄우므로, 
        //    그냥 두면 되지만 버튼 상태 초기화를 위해 호출)
        cancelEditMode(); 
        
        // 3. 리스트 목록도 갱신 (선택 사항)
        if (typeof loadTab === 'function') loadTab('contract');

    } catch (error) {
        console.error("수정 실패:", error);
        alert("정보 수정 중 오류가 발생했습니다.");
    }
}