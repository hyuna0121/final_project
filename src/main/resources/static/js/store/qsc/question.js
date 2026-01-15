document.addEventListener('DOMContentLoaded', function() {
    const registerModal = document.getElementById('registerQuestionModal');
    registerModal.addEventListener('hidden.bs.modal', function () {
        document.getElementById('registerStoreForm').reset();
    });
});

function handleMaxScore(el) {
    el.value = el.value.replace(/[^0-9]/g, '');

    if (el.value !== '') {
        const num = parseInt(el.value);

        if (num > 10) {
            el.value = '10';
        }
        else if (num === 0) {
             el.value = '';
        }
    }
}

async function submitQuestionRegistration() {
    const listCategory = document.getElementById('listCategory').value;
    const listMaxScore = document.getElementById('listMaxScore').value;
    const listQuestion = document.getElementById('listQuestion').value;

    if (!listQuestion) {
        alert("질문을 입력해주세요.");
        document.getElementById('listQuestion').focus();
        return;
    }
    if (!listMaxScore) {
        alert("배점을 입력해주세요.");
        document.getElementById('listMaxScore').focus();
        return;
    }

    const formData = {
        listCategory: listCategory,
        listMaxScore: listMaxScore,
        listQuestion: listQuestion
    };

    try {
        const response = await fetch('/store/qsc/admin/question/add', {
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
            alert("QSC 질문 등록 중 오류가 발생했습니다.");
            return;
        }

        alert("QSC 질문이 성공적으로 등록되었습니다.");
        
        const modalEl = document.getElementById('registerQuestionModal');
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

function movePage(page) {
    if (page < 1) page = 1;

    const form = document.getElementById('questionSearchForm');
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

function searchQuestion() {
    document.getElementById("page").value = 1;
    document.getElementById("questionSearchForm").submit();
}

function resetSearchForm() {
	const form = document.getElementById('questionSearchForm');
	
	const inputs = form.querySelectorAll('input[type="text"], input[type="time"]');
    inputs.forEach(input => {
        input.value = '';
    });

    const selects = form.querySelectorAll('select');
    selects.forEach(select => {
        select.value = ''; 
    });

    if(document.getElementById('page')) {
        document.getElementById('page').value = 1;
    }
}

function downloadExcel() {
    const form = document.getElementById('questionSearchForm');
    const params = new URLSearchParams(new FormData(form));

    const currentUrlParams = new URLSearchParams(window.location.search);

    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            params.append(key, value);
        }
    });

    location.href = '/store/qsc/question/downloadExcel?' + params.toString();
}

function changePerPage(val) {
    document.querySelector('#hiddenPerPage').value = val;
    document.querySelector('#page').value = 1;
    const form = document.getElementById('questionSearchForm');
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

function openUpdateModal(button) {
    const listId = button.dataset.id;
    const category = button.dataset.category;
    const question = button.dataset.question;
    const score = button.dataset.score;
    const status = button.dataset.status;

    document.getElementById('updateListId').value = listId;
    document.getElementById('updateListCategory').innerHTML = category;
    document.getElementById('updateListQuestion').innerHTML = question;
    document.getElementById('updateListMaxScore').innerHTML = score;
    document.getElementById('listStatus').value = status;

    if (category == 'Quality') document.getElementById('updateListCategory').classList.add('bg-label-primary');
    else if (category == 'Service') document.getElementById('updateListCategory').classList.add('bg-label-warning');
    else if (category == 'Cleanliness') document.getElementById('updateListCategory').classList.add('bg-label-info');

    const modalElement = document.getElementById('updateQuestionModal');
    const modal = new bootstrap.Modal(modalElement);
    modal.show();
}

async function submitQuestionUpdate() {
    const listId = document.getElementById('updateListId').value;
    const listStatus = document.getElementById('listStatus').value;

    const formData = {
        listId: listId,
        listIsUse: listStatus
    };

    try {
        const response = await fetch('/store/qsc/admin/question/update', {
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
            alert("질문 수정 중 오류가 발생했습니다.");
            return;
        }

        alert("질문이 성공적으로 수정되었습니다.");

        const modalEl = document.getElementById('updateQuestionModal');
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        if (modalInstance) {
            modalInstance.hide();
        }

        location.reload();

    } catch (error) {
        console.error('Error:', error);
        alert("수정 중 오류가 발생했습니다.");
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const questionModalEl = document.getElementById('registerQuestionModal');

    if (questionModalEl) {
        questionModalEl.addEventListener('hidden.bs.modal', function () {
            document.getElementById('listCategory').selectedIndex = 0;
            document.getElementById('listMaxScore').value = '';
            document.getElementById('listQuestion').value = '';
        });
    }
});