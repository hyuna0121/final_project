$(function() {
    let startParam = $('#searchStartDate').val(); 
    let endParam = $('#searchEndDate').val();

    let startMoment = moment();
    let endMoment = moment();
    let hasValidData = false; 

    if (startParam && endParam) {
        let s = moment(startParam, 'YYYY-MM-DD');
        let e = moment(endParam, 'YYYY-MM-DD');
        
        if (s.isValid() && e.isValid()) {
            startMoment = s;
            endMoment = e;
            hasValidData = true;
        }
    }

    $('#daterange').daterangepicker({
        startDate: startMoment,
        endDate: endMoment,
        autoUpdateInput: false, 
        locale: {
            format: "YYYY-MM-DD",
            separator: " ~ ",
            applyLabel: "확인",
            cancelLabel: "취소",
            fromLabel: "부터",
            toLabel: "까지",
            customRangeLabel: "직접 선택",
            daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
            monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
            firstDay: 0
        },
		ranges: {
	        '오늘': [moment(), moment()],
	        '어제': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
	        '최근 7일': [moment().subtract(6, 'days'), moment()],
	        '최근 30일': [moment().subtract(29, 'days'), moment()],
	        '이번 달': [moment().startOf('month'), moment().endOf('month')],
	        '지난 달': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
		}
    });

    if (hasValidData) {
        $('#daterange').val(startMoment.format('YYYY-MM-DD') + ' ~ ' + endMoment.format('YYYY-MM-DD'));
    } else {
        $('#daterange').val(''); 
    }

    $('#daterange').on('apply.daterangepicker', function(ev, picker) {
        const sDate = picker.startDate.format('YYYY-MM-DD');
        const eDate = picker.endDate.format('YYYY-MM-DD');

        $(this).val(sDate + ' ~ ' + eDate);
        
        $('#searchStartDate').val(sDate);
        $('#searchEndDate').val(eDate);
    });

    $('#daterange').on('cancel.daterangepicker', function(ev, picker) {
        $(this).val('');
        $('#searchStartDate').val('');
        $('#searchEndDate').val('');
    });
});

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

async function submitVocRegistration() {
    const storeId = document.getElementById('storeId').value;
    const vocType = document.getElementById('vocType').value;
    const vocContact = document.getElementById('vocContact').value;
	const vocTitle = document.getElementById('vocTitle').value;
	const vocContents = document.getElementById('vocContents').value;
	
	console.log(vocType);
    
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

        if (result.status === 'error') {
            alert(result.message);
            return;
        } else if (result.status === 'fail') {
            alert("VOC 등록 중 오류가 발생했습니다.");
            return;
        }

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

document.addEventListener('DOMContentLoaded', function() {
    const vocModalEl = document.getElementById('registerVocModal');

    if (vocModalEl) {
        vocModalEl.addEventListener('hidden.bs.modal', function () {
            document.getElementById('storeId').value = '';
            document.getElementById('storeNameInput').value = '';
            document.getElementById('vocType').selectedIndex = 0;
            document.getElementById('vocContact').value = '';
            document.getElementById('vocTitle').value = '';
            document.getElementById('vocContents').value = '';

            const resultList = document.getElementById('storeResultList');
            if (resultList) {
                resultList.style.display = 'none';
                resultList.innerHTML = '';
            }
        });
    }
});

function searchVoc() {
    document.getElementById("page").value = 1;
    document.getElementById("vocSearchForm").submit();
}

function resetSearchForm() {
	const inputs = document.querySelectorAll('#vocSearchForm input');
    inputs.forEach(input => input.value = '');
	
	const selects = document.querySelectorAll('#vocSearchForm select');
    selects.forEach(select => select.selectedIndex = 0);

    if(document.getElementById('page')) {
        document.getElementById('page').value = 1;
    }
}

function downloadExcel() {
    const form = document.getElementById('vocSearchForm');
    const params = new URLSearchParams(new FormData(form));

    const currentUrlParams = new URLSearchParams(window.location.search);

    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            params.append(key, value);
        }
    });

    const currentPath = window.location.pathname;
    let url = `/store/voc/downloadExcel`;

    if (currentPath.includes(`my-list`)) url = `/store/voc/my-downloadExcel`;

    location.href = url + '?' + params.toString();
}

function movePage(page) {
    if (page < 1) page = 1;

    document.getElementById('page').value = page;

    const form = document.getElementById('vocSearchForm');

    const currentUrlParams = new URLSearchParams(window.location.search);
    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            if (form.querySelector(`input[name="${key}"]`)) {
                form.querySelector(`input[name="${key}"]`).value = value;
            } else {
                const input = document.createElement("input");
                input.type = "hidden";
                input.value = value;
                form.appendChild(input);
            }
        }
    });

    form.submit();
}

function changePerPage(val) {
    document.querySelector('#hiddenPerPage').value = val;
    document.querySelector('#page').value = 1;
    const form = document.getElementById('vocSearchForm');

    const currentUrlParams = new URLSearchParams(window.location.search);
    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            if (form.querySelector(`input[name="${key}"]`)) {
                form.querySelector(`input[name="${key}"]`).value = value;
            } else {
                const input = document.createElement("input");
                input.type = "hidden";
                input.value = value;
                form.appendChild(input);
            }
        }
    });

    form.submit();
}