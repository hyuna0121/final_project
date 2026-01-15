async function fetchJson(url, options = {}) {
    const response = await fetch(url, options);
    if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
    return response.json();
}

async function searchStore() {
    const keyword = document.getElementById("storeNameInput").value.trim();
    const isManager = 1;
    const resultListElement = document.getElementById("storeResultList");

    try {
        const params = new URLSearchParams({
            keyword: keyword,
            isManager: isManager
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

function handleMaxScore(el) {
    const maxScore = parseInt(el.getAttribute('data-max-score'));

    el.value = el.value.replace(/[^0-9]/g, '');

    if (el.value !== '') {
        const num = parseInt(el.value);
        if (num > maxScore) el.value = maxScore;
    }
}

function calculateTotal() {
    let currentTotal = 0;
    const inputs = document.querySelectorAll('.score-input');

    inputs.forEach(input => {
        const val = input.value ? parseInt(input.value) : 0;
        currentTotal += val;
    });

    document.getElementById('displayTotalScore').innerText = currentTotal;

    const totalMax = parseInt(document.getElementById('hiddenTotalMax').value) || 0;

    if (totalMax === 0) return;

    const percent = (currentTotal / totalMax) * 100;
    document.getElementById('displayTotalScoreTo').innerText = percent.toFixed(1);

    let grade = 'D';
    let badgeClass = 'bg-label-danger';

    if (percent >= 90) {
        grade = 'A';
        badgeClass = 'bg-label-primary';
    } else if (percent >= 80) {
        grade = 'B';
        badgeClass = 'bg-label-success';
    } else if (percent >= 70) {
        grade = 'C';
        badgeClass = 'bg-label-warning';
    }

    const gradeEl = document.getElementById('displayGrade');
    gradeEl.innerText = grade;

    gradeEl.className = `badge ${badgeClass}`;
}

function validateScores() {
    const inputs = document.querySelectorAll('.score-input');

    for (let i = 0; i < inputs.length; i++) {
        const input = inputs[i];
        if (input.value.trim() === '') {
            alert((i + 1) + "번 항목의 점수가 입력되지 않았습니다.");
            input.focus();

            return false;
        }
    }

    return true;
}

async function submitQscForm() {
    const qscTitle = document.getElementById("qscTitle");
    const storeId = document.getElementById("storeId");
    const qscOpinion = document.getElementById("qscOpinion");

    if (!qscTitle.value) {
        alert("제목을 입력해주세요.");
        qscTitle.focus();
        return;
    }
    if (!storeId.value) {
        alert("대상 가맹점을 선택해주세요.");
        document.getElementById("storeNameInput").focus();
        return;
    }
    if (!validateScores()) {
        return;
    }
    const displayStoreName = document.getElementById('storeNameInput').value;
    const displayGrade = document.getElementById('displayGrade').innerText;
    const confirmMessage =  `[${qscTitle.value}]\n` +
                            `- 대상 가맹점: ${displayStoreName}\n` +
                            `- 예상 등급: ${displayGrade}\n\n` +
                            `이대로 저장하시겠습니까?`;

    if(!confirm(confirmMessage)) {
        return;
    }

    const scoreList = [];
    document.querySelectorAll('.score-input').forEach(input => {
        scoreList.push({
            listId: input.getAttribute('data-list-id'),
            detailScore: parseInt(input.value) || 0
        });
    });

    const formData = {
        qscTitle: qscTitle.value,
        storeId: storeId.value,
        qscOpinion: qscOpinion.value,
        qscDetailDTOS: scoreList
    };

    try {
        const response = await fetch('/store/qsc/add', {
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
            alert("QSC점검 등록 중 오류가 발생했습니다.");
            return;
        }

        alert("QSC점검이 등록되었습니다.");
        location.href = "/store/qsc/list";
    } catch (error) {
        console.error('Error:', error);
        alert("등록 중 오류가 발생했습니다.");
    }
}

async function submitQscUpdateForm() {
    const qscId = document.getElementById("qscId");
    const qscTitle = document.getElementById("qscTitle");
    const qscOpinion = document.getElementById("qscOpinion");

    if (!qscTitle.value) {
        alert("제목을 입력해주세요.");
        qscTitle.focus();
        return;
    }
    if (!validateScores()) {
        return;
    }
    const displayStoreName = document.getElementById('storeNameInput').innerText;
    const displayGrade = document.getElementById('displayGrade').innerText;
    const confirmMessage =  `[${qscTitle.value}]\n` +
                            `- 대상 가맹점: ${displayStoreName}\n` +
                            `- 예상 등급: ${displayGrade}\n\n` +
                            `이대로 저장하시겠습니까?`;

    if(!confirm(confirmMessage)) {
        return;
    }

    const scoreList = [];
    document.querySelectorAll('.score-input').forEach(input => {
        scoreList.push({
            detailId: input.getAttribute('data-detail-id'),
            detailScore: parseInt(input.value) || 0
        });
    });

    const formData = {
        qscId: qscId.value,
        qscTitle: qscTitle.value,
        qscOpinion: qscOpinion.value,
        qscDetailDTOS: scoreList
    };

    try {
        const response = await fetch('/store/qsc/update', {
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
            alert("QSC점검 수정 중 오류가 발생했습니다.");
            return;
        }

        alert("QSC 점검이 수정되었습니다.");
        location.href = `/store/qsc/detail?qscId=${qscId.value}`;
    } catch (error) {
        console.error('Error:', error);
        alert("등록 중 오류가 발생했습니다.");
    }
}