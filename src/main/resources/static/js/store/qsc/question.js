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
    document.getElementById("page").value = page;
    document.getElementById("questionSearchForm").submit();
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
	var searchParams = $('#questionSearchForm').serialize();
	location.href='/store/qsc/question/downloadExcel?' + searchParams;
}

function openUpdateModal(button) {
    const listId = button.dataset.id;
    const category = button.dataset.category;
    const question = button.dataset.question;
    const score = button.dataset.score;
    const status = button.dataset.status;

    document.getElementById('updateListId').value = listId;
    document.getElementById('updateListCategory').value = category;
    document.getElementById('updateListQuestion').value = question;
    document.getElementById('updateListMaxScore').value = score;
    document.getElementById('listStatus').value = status;

    const modalElement = document.getElementById('updateQuestionModal');
    const modal = new bootstrap.Modal(modalElement);
    modal.show();
}

async function submitQuestionUpdate() {
    const listId = document.getElementById('updateListId').value;
    const listCategory = document.getElementById('updateListCategory').value;
    const listMaxScore = document.getElementById('updateListMaxScore').value;
    const listStatus = document.getElementById('listStatus').value;
    const listQuestion = document.getElementById('updateListQuestion').value;

    if (!listQuestion) {
        alert("질문을 입력해주세요.");
        document.getElementById('listQuestion').focus();
        return;
    }
    if (!listMaxScore) {
        alert("배점을 입력해주세요.");
        document.getElementById('updateListMaxScore').focus();
        return;
    }

    const formData = {
        listId: listId,
        listCategory: listCategory,
        listMaxScore: listMaxScore,
        listQuestion: listQuestion,
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