var storeLatitude = document.getElementById('storeLatitude').value;
var storeLongitude = document.getElementById('storeLongitude').value;

var mapContainer = document.getElementById('map'), 
    mapOption = { 
        center: new kakao.maps.LatLng(storeLatitude, storeLongitude),
        level: 3 
    };

var map = new kakao.maps.Map(mapContainer, mapOption)

var markerPosition  = new kakao.maps.LatLng(storeLatitude, storeLongitude); 
var marker = new kakao.maps.Marker({
    position: markerPosition
});

marker.setMap(map);

async function searchManager() {
    const keyword = document.getElementById("managerNameInput").value;

    try {
        const params = new URLSearchParams({ keyword: keyword });
        const url = `/member/search/manager?${params.toString()}`;

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
        let resultListElement = document.getElementById("managerResultList");

        if (data.length === 0) {
            listHtml = `<li class="list-group-item text-muted">검색 결과가 없습니다.</li>`;
        } else {
            data.forEach((member, index) => {
                listHtml += `
                    <li class="list-group-item list-group-item-action d-flex align-items-center cursor-pointer" 
                        data-member='${JSON.stringify(member)}' onclick="selectManagerFromData(this)">
                        <div class="avatar avatar-sm me-2">
                            <span class="avatar-initial rounded-circle bg-label-primary">
                                ${member.memName.charAt(0)}
                            </span>
                        </div>
                        <div class="d-flex flex-column">
                            <span class="fw-bold">${member.memName}</span>
                            <small class="text-muted">${member.memberId} · 담당 ${member.deptCode}개</small>
                        </div>
                    </li>
                `;
            });
        }

        resultListElement.innerHTML = listHtml;
        resultListElement.style.display = 'block';

    } catch (error) {
        console.error("Fetch Error:", error);
        alert("점주 검색 중 오류가 발생했습니다.");
    }
}

function selectManagerFromData(element) {
    const member = JSON.parse(element.dataset.member);
    selectManager(member);
}

function selectManager(member) {
	document.getElementById("memberId").value = member.memberId;
	document.getElementById("managerNameInput").value = member.memName;
	document.getElementById("managerResultList").style.display = 'none';
	
	document.getElementById('emptyState').style.display = 'none';
    document.getElementById('managerInfo').style.display = 'flex';

	document.getElementById('selectedAvatar').textContent = member.memName.charAt(0);
	document.getElementById('selectedName').textContent = member.memName;
	document.getElementById('selectedId').textContent = member.memberId;
	document.getElementById('selectedEmail').textContent = member.memEmail || '-';
	document.getElementById('selectedPhone').textContent = member.memPhone || '-';
	document.getElementById('selectedStoreCount').textContent = member.deptCode;
}

document.addEventListener('click', function(e) {
    const target = e.target;
    const isInputGroup = target.closest('.input-group');
    const isResultList = target.closest('#managerResultList');

    if (!isInputGroup && !isResultList) {
        const listEl = document.getElementById('managerResultList');
        if (listEl) {
            listEl.style.display = 'none';
        }
    }
});

async function submitManagerUpdate() {
    const memberId = document.getElementById('memberId').value;
    const manageStartDate = document.getElementById('manageStartDate').value;
	const storeId = document.getElementById('storeId').value;
    
    if (!memberId) {
        alert("담당자를 선택해주세요.");
        return;
    }
    if (!manageStartDate) {
        alert("담당 시작일을 선택해주세요.");
        return;
    }

    const formData = {
        memberId: memberId,
        manageStartDate: manageStartDate,
		storeId: storeId
    };

    try {
        const response = await fetch('/store/manage/update', { 
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

        alert("담당자가 배정되었습니다.");
        
        const modalEl = document.getElementById('updateManagerModal');
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
    // DOM 요소 가져오기
    const btnEditInfo = document.getElementById('btnEditInfo');
    const viewTime = document.getElementById('viewTime');
    const editTime = document.getElementById('editTime');
    const btnText = document.getElementById('btnText');
    const btnIcon = document.getElementById('btnIcon');
    const inputStartTime = document.getElementById('inputStartTime');
    const inputCloseTime = document.getElementById('inputCloseTime');

    // 버튼 클릭 이벤트 리스너 등록
    btnEditInfo.addEventListener('click', function() {
        // 1. 현재 상태 확인 (editTime이 숨겨져 있으면 '보기 모드'임)
        const isViewMode = editTime.classList.contains('d-none');

        if (isViewMode) {
            // [수정 모드로 전환]
            viewTime.classList.add('d-none');       // 텍스트 숨김
            editTime.classList.remove('d-none');    // 입력창 보이기

            // 버튼 스타일 및 텍스트 변경 (노란색 outline -> 파란색 fill)
            btnEditInfo.classList.remove('btn-outline-warning');
            btnEditInfo.classList.add('btn-primary');
            
            btnText.textContent = '저장 완료';
            
            // 아이콘 변경 (연필 -> 체크)
            btnIcon.classList.remove('bx-edit-alt');
            btnIcon.classList.add('bx-check');

        } else {
            // [저장 후 보기 모드로 전환]
            
            // TODO: 이곳에 DB 업데이트를 위한 fetch() 또는 axios 호출 코드가 들어갑니다.
            // 예: updateStoreTime(storeId, inputStartTime.value, inputCloseTime.value);

            const newStart = inputStartTime.value;
            const newClose = inputCloseTime.value;

            // 화면 텍스트 갱신
            // viewTime 내부의 시간 텍스트가 있는 span을 찾아서 업데이트 (구조에 따라 선택자 조정 필요)
            // 여기서는 viewTime 바로 아래의 텍스트나 내부 span을 업데이트한다고 가정
            const timeSpan = viewTime.querySelector('span.fw-bold') || viewTime.querySelector('span');
            if(timeSpan) {
                timeSpan.textContent = newStart + ' ~ ' + newClose;
            }

            // UI 복구
            editTime.classList.add('d-none');       // 입력창 숨김
            viewTime.classList.remove('d-none');    // 텍스트 보이기

            // 버튼 스타일 복구
            btnEditInfo.classList.remove('btn-primary');
            btnEditInfo.classList.add('btn-outline-warning');

            btnText.textContent = '정보 수정';

            // 아이콘 복구
            btnIcon.classList.remove('bx-check');
            btnIcon.classList.add('bx-edit-alt');
        }
    });
});