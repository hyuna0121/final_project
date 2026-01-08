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