var mapContainer, map, geocoder, marker;

(function() {
    // 이미 카카오 스크립트가 로드되어 있는지 확인
    if (window.kakao && window.kakao.maps) {
        // v3 스크립트가 로드된 후 실행 (비동기 로드 대응)
        kakao.maps.load(function() {
            initMap(); 
            setupModalEvents(); // 모달 이벤트 연결 함수 분리
        });
    } else {
        console.error("카카오 지도 스크립트가 로드되지 않았습니다. API 키를 확인하세요.");
    }
})();

function setupModalEvents() {
    var registerModal = document.getElementById('registerStoreModal');

    if (registerModal) {
        // 기존 리스너가 중복 등록되는 것을 방지하기 위해 확인 필요 (선택사항)
        registerModal.addEventListener('shown.bs.modal', function () {
            if (map) {
                map.relayout(); // 필수: 모달이 뜬 직후 크기 재계산
                
                var center = new kakao.maps.LatLng(37.5078249059846, 127.056933897557); 
                map.setCenter(center); 
            }
        });
    
        registerModal.addEventListener('hidden.bs.modal', function () {
            // 폼 초기화 시 input 값들만 리셋
            document.getElementById('registerStoreForm').reset();
            
            // 지도 마커 원위치
            if (map && marker) {
                var defaultPosition = new kakao.maps.LatLng(37.5078249059846, 127.056933897557); 
                map.setCenter(defaultPosition);
                marker.setPosition(defaultPosition);
            }
            
            // 검색 결과 리스트 숨김 처리 추가
            var resultList = document.getElementById("ownerResultList");
            if(resultList) resultList.style.display = 'none';
        });
    }
}

function initMap() {
    mapContainer = document.getElementById('map');
    
    if (!mapContainer) return; 

    var mapOption = {
        center: new kakao.maps.LatLng(37.5078249059846, 127.056933897557),
        level: 3
    };

    map = new kakao.maps.Map(mapContainer, mapOption);
    geocoder = new kakao.maps.services.Geocoder();
    marker = new kakao.maps.Marker({
        position: new kakao.maps.LatLng(37.5078249059846, 127.056933897557),
        map: map
    });
}

function searchAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById("storeAddress").value = data.address;
            document.getElementById('storeZonecode').value = data.zonecode;

            if (!geocoder) return;

            geocoder.addressSearch(data.address, function(results, status) {
                if (status === kakao.maps.services.Status.OK) {
                    var result = results[0];
                    var coords = new kakao.maps.LatLng(result.y, result.x);
                    
                    document.getElementById("storeLatitude").value = result.y;
                    document.getElementById('storeLongitude').value = result.x;
                    
                    map.relayout();
                    map.setCenter(coords);
                    marker.setPosition(coords);
                }
            });
        }
    }).open();
}

async function searchOwner() {
    const keyword = document.getElementById("ownerNameInput").value;

    if (!keyword || keyword.trim() === "") {
        alert("검색어를 입력해주세요.");
        return;
    }

    try {
        const params = new URLSearchParams({ keyword: keyword });
        const url = `/member/search/owner?${params.toString()}`;

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
        let resultListElement = document.getElementById("ownerResultList");

        if (data.length === 0) {
            listHtml = `<li class="list-group-item text-muted">검색 결과가 없습니다.</li>`;
        } else {
            data.forEach(member => {
                listHtml += `
                    <li class="list-group-item list-group-item-action d-flex align-items-center cursor-pointer" 
                        onclick="selectOwner('${member.memberId}', '${member.memName}')">
                        <div class="avatar avatar-sm me-2">
                            <span class="avatar-initial rounded-circle bg-label-primary">
                                ${member.memName.charAt(0)}
                            </span>
                        </div>
                        <div class="d-flex flex-column">
                            <span class="fw-bold">${member.memName}</span>
                            <small class="text-muted">${member.memberId}</small>
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

function selectOwner(id, name) {
    document.getElementById("memberId").value = id;
    document.getElementById("ownerNameInput").value = `${name} (${id})`;
    
    document.getElementById("ownerResultList").style.display = 'none';
}

document.addEventListener('click', function(e) {
    const target = e.target;
    const isInputGroup = target.closest('.input-group');
    const isResultList = target.closest('#ownerResultList');

    if (!isInputGroup && !isResultList) {
        const listEl = document.getElementById('ownerResultList');
        if (listEl) {
            listEl.style.display = 'none';
        }
    }
});

function searchStores() {
	
}

async function submitStoreRegistration() {
    const storeName = document.getElementById('storeName').value;
    const memberId = document.getElementById('memberId').value;
    const address = document.getElementById('storeAddress').value;
	const detailAddress = document.getElementById('storeDetailAddress').value;
	const storeLatitude = document.getElementById('storeLatitude').value;
	const storeLongitude = document.getElementById('storeLongitude').value;
	const storeZonecode = document.getElementById('storeZonecode').value;
    
    if (!storeName) {
        alert("가맹점명을 입력해주세요.");
        return;
    }
    if (!memberId) {
        alert("점주를 선택해주세요.");
        return;
    }
    if (!address) {
        alert("주소를 검색해주세요.");
        return;
    }

    const formData = {
        storeName: storeName,
        memberId: memberId, 
        storeAddress: address + " " + detailAddress,
        storeZonecode: storeZonecode,
        storeLatitude: storeLatitude,
        storeLongitude: storeLongitude,
    };

    try {
        const response = await fetch('/store/tab/store/add', { 
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

        alert("가맹점이 성공적으로 등록되었습니다.");
        
        const modalEl = document.getElementById('registerStoreModal');
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        if (modalInstance) {
            modalInstance.hide();
        }
        
        loadTab('store');

    } catch (error) {
        console.error('Error:', error);
        alert("등록 중 오류가 발생했습니다.");
    }
}