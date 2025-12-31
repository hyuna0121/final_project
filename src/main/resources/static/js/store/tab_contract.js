async function searcStore() {
    const keyword = document.getElementById("storeNameInput").value;

    if (!keyword || keyword.trim() === "") {
        alert("검색어를 입력해주세요.");
        return;
    }

    try {
        const params = new URLSearchParams({ keyword: keyword });
        const url = `/store/tab/store/search/store?${params.toString()}`;

        const response = await fetch(url, {
            method: "GET",
            headers: {
                "Content-Type": "application/json"
            }
        });

        if (!response.ok) {
            throw new Error(`서버 오류 발생: ${response.status}`);
        }

        const data = await response.json();

        let listHtml = "";
        let resultListElement = document.getElementById("storeResultList");

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
        if (listEl) {
            listEl.style.display = 'none';
        }
    }
});

var registerContractModal = document.getElementById('registerContractModal');

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

$(document).ready(function() {
    $('#registerContractModal').off('hidden.bs.modal').on('hidden.bs.modal', function () {
        const form = document.getElementById('registerContractForm');
        if(form) form.reset();

        const storeIdEl = document.getElementById('storeId');
        if(storeIdEl) storeIdEl.value = '';

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
});

async function submitContractRegistration() {
    const storeId = document.getElementById('storeId').value;
    const contractRoyalti = document.getElementById('royalti').value;
    const contractDeposit = document.getElementById('deposit').value;
	const contractStartDate = document.getElementById('startDate').value;
	const contractEndDate = document.getElementById('endDate').value;
	const contractStatus = document.getElementById('contractStatus').value;
    
    if (!storeId) { alert("가맹점명을 선택해주세요."); return; }
    if (!contractRoyalti) { alert("로얄티를 입력해주세요."); return; }
    if (!contractDeposit) { alert("여신(보증금)을 입력해주세요."); return; }
	if (!contractStartDate || !contractEndDate) { alert("계약기간을 입력해주세요."); return; }

    const formData = new FormData();
	
	formData.append("storeId", storeId);
    formData.append("contractRoyalti", contractRoyalti);
    formData.append("contractDeposit", contractDeposit);
    formData.append("contractStartDate", contractStartDate);
    formData.append("contractEndDate", contractEndDate);
    formData.append("contractStatus", contractStatus);
	
	const fileInputs = document.getElementsByName("contractFiles");
	
	for (let i = 0; i < fileInputs.length; i++) {
        if (fileInputs[i].files.length > 0) {
            formData.append("files", fileInputs[i].files[0]); // fileInputs 태그에서 파일 객체 자체를 append 
        }
    }
	
	try {
	    const response = await fetch('/store/tab/contract/add', {
	        method: 'POST',
	        body: formData 
	    });

	    if (!response.ok) {
	        throw new Error(`서버 오류: ${response.status}`);
	    }

	    const result = await response.json(); 

	    alert("계약이 성공적으로 등록되었습니다.");
	    
	    const modalEl = document.getElementById('registerContractModal');
	    const modalInstance = bootstrap.Modal.getInstance(modalEl);
	    if (modalInstance) {
	        modalInstance.hide();
	    }
	    
	    loadTab('contract'); 

	} catch (error) {
	    console.error('Error:', error);
	    alert("등록 중 오류가 발생했습니다.");
	}	
	
}

async function getContractDetail(contractId) {
	try {
		const url = `/store/tab/contract/detail?contractId=${contractId}`;
		const response = await fetch (url, { method : "GET"});
		
		if (!response.ok) {
			throw new Error(`Error : ${response.status}`);
		}
		
		const data = await response.json();
		
		document.getElementById('detailContractId').value = data.contractId;
        document.getElementById('detailStoreName').value = data.storeName;
        document.getElementById('detailStartDate').value = data.contractStartDate;
        document.getElementById('detailEndDate').value = data.contractEndDate;

        document.getElementById('detailRoyalty').value = new Intl.NumberFormat('ko-KR').format(data.contractRoyalti) + " 원";
        document.getElementById('detailDeposit').value = new Intl.NumberFormat('ko-KR').format(data.contractDeposit) + " 원";

		const statusArea = document.getElementById('detailStatusArea');
		let badgeHtml = '';
		
		switch (data.contractStatus) {
			case 0:
				badgeHtml = '<span class="badge bg-label-warning">PENDING</span>';
				break;
			case 1:
				badgeHtml = '<span class="badge bg-label-info">ACTIVE</span>';
				break;
			case 2:
				badgeHtml = '<span class="badge bg-label-danger">EXPIRED</span>'; 
				break;
			default:
				badgeHtml = '<span class="badge bg-label-secondary">UNKNOWN</span>';
		}
		
		statusArea.innerHTML = badgeHtml;
        
		
		// file
		const fileListEl = document.getElementById('detailFileList');
		fileListEl.innerHTML = "";
		
		if (data.fileDTOs && data.fileDTOs.length > 0) {
			data.fileDTOs.forEach(file => {
				const li = document.createElement('li');
				li.className = "list-group-item d-flex justify-content-between align-items-center";
				
				let iconClass = "bx bxs-file-blank text-secondary";
                if(file.fileOriginalName.includes('.pdf')) iconClass = "bx bxs-file-pdf text-danger";
                else if(file.fileOriginalName.includes('.jpg') || file.fileOriginalName.includes('.png')) iconClass = "bx bxs-file-image text-primary";

                li.innerHTML = `
                    <div class="d-flex align-items-center">
                        <i class="${iconClass} me-2 fs-4"></i>
                        <span>${file.fileOriginalName}</span>
                    </div>
                    <button class="btn btn-sm btn-outline-primary" onclick="downloadAttachment('${file.fileSavedName}', '${file.fileOriginalName}')">
                        <i class="bx bx-download"></i> 다운로드
                    </button>
                `;
                fileListEl.appendChild(li);
			});
		} else {
			fileListEl.innerHTML = `<li class="list-group-item text-center text-muted">첨부된 파일이 없습니다.</li>`;
		}
		
		var modalEl = document.getElementById('detailContractModal');
		var modal = new bootstrap.Modal(modalEl);
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
    // 1. 모달에 떠있는 데이터 가져오기
    const contractId = document.getElementById('detailContractId').value;
    const storeName = document.getElementById('detailStoreName').value;
    
    // 콤마가 포함된 문자열 그대로 가져옴 (예: "350,000 원")
    const royalty = document.getElementById('detailRoyalty').value; 
    const deposit = document.getElementById('detailDeposit').value; 
    
    const startDate = document.getElementById('detailStartDate').value;
    const endDate = document.getElementById('detailEndDate').value;

    // ★ [수정된 부분] detailStatus(없음) -> detailStatusArea(존재함)
    // 텍스트(innerText)를 가져오면 "PENDING (대기)" 같은 글자를 가져옵니다.
    const statusArea = document.getElementById('detailStatusArea');
    const status = statusArea ? statusArea.innerText : ""; 

    // 2. 숨겨진 PDF 양식(Template)에 데이터 매핑
    document.getElementById('pdfContractId').innerText = contractId;
    document.getElementById('pdfStoreName').innerText = storeName;
    document.getElementById('pdfStoreNameTable').innerText = storeName;
    
    // 상태값 넣기
    document.getElementById('pdfStatus').innerText = status;

    // 기간
    document.getElementById('pdfStartDate').innerText = startDate;
    document.getElementById('pdfEndDate').innerText = endDate;

    // 금액
    document.getElementById('pdfRoyalty').innerText = royalty;
    document.getElementById('pdfDeposit').innerText = deposit;

    // 서명란
    document.getElementById('pdfSignStoreName').innerText = storeName;
    document.getElementById('pdfSignOwner').innerText = ""; // 점주명 (필요시 추가)
    
    // 주소 (모달에 주소 input이 없다면 공란 처리 혹은 하드코딩)
    // 만약 모달에 주소를 표시하는 id="detailAddress"가 있다면 .value로 가져오면 됨
    document.getElementById('pdfSignAddress').innerText = " "; 

    // 오늘 날짜
    const today = new Date();
    const dateString = `${today.getFullYear()}년 ${today.getMonth() + 1}월 ${today.getDate()}일`;
    document.getElementById('pdfToday').innerText = dateString;

    // 3. PDF 변환 및 다운로드
    const element = document.getElementById('contractPdfTemplate');
    
    // PDF 옵션 설정
    const opt = {
        margin:       0,
        filename:     `가맹계약서_${storeName}_${contractId}.pdf`,
        image:        { type: 'jpeg', quality: 1 },
        html2canvas:  { scale: 2, scrollY: 0 },
        jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };

    html2pdf().set(opt).from(element).save();
}