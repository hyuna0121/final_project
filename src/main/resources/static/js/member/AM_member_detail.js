let originalImageSrc = ''; 

$(document).ready(function() {
    
    toggleDateInputs();

    originalImageSrc = $("#detailProfileImage").attr("src");

    $(".profile-image-container").click(function() {
        if ($(this).hasClass("editable")) {
            $("#profileFileUpload").click();
        }
    });

    $("#profileFileUpload").change(function(e) {
        const file = e.target.files[0];

        if (file && file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function(e) {
                $("#detailProfileImage").attr("src", e.target.result);
            }
            reader.readAsDataURL(file);
        } else {
            alert("이미지 파일만 선택할 수 있습니다.");
            $(this).val("");
        }
    });
    
    const urlParams = new URLSearchParams(window.location.search);
    if(urlParams.get('tab') === 'attendance') {
        const triggerEl = document.querySelector('button[data-bs-target="#navs-attendance"]');
        if(triggerEl){
            const tab = new bootstrap.Tab(triggerEl);
            tab.show();
        }
    }
});






function movePage(page) {
    if (page < 1) page = 1;

    const form = document.getElementById('attForm'); 
    document.getElementById("attPage").value = page;

    const formData = new FormData(form);
    const params = new URLSearchParams(formData);

    params.set('page', page);

    const currentUrlParams = new URLSearchParams(window.location.search);
    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            params.append(key, value);
        }
    });

    params.set("tab", "attendance");

    location.href = form.action + "?" + params.toString();
}


function moveVacationPage(page) {
    if (page < 1) page = 1; 
    
    document.getElementById("vacPage").value = page;
    
    document.getElementById("vacForm").submit();
}

document.addEventListener("DOMContentLoaded", function() {
    const urlParams = new URLSearchParams(window.location.search);
    if(urlParams.get('tab') === 'vacation') {
        const triggerEl = document.querySelector('button[data-bs-target="#navs-vacation"]');
        if(triggerEl){
            const tab = new bootstrap.Tab(triggerEl);
            tab.show();
        }
    }
});

		
		
		
		
		
		
		
function toggleDateInputs() {
    const type = $("#dateType").val();

    $("#dateInputArea").addClass("d-none");
    $(".date-input").addClass("d-none");

    if (type !== "all") {
        $("#dateInputArea").removeClass("d-none");
        $(`#input-${type}`).removeClass("d-none");
    }
}





function toggleEditMode(isEdit, type) {
    if (type === 'info') {
        if (isEdit) {
            $("#view-area-info").hide();
            $("#edit-area-info").show();
            
            $(".profile-image-container").addClass("editable");
            $(".profile-image-container").css("cursor", "pointer");
            $(".image-overlay").removeClass("opacity-0"); 
            
        } else {
            $("#view-area-info").show();
            $("#edit-area-info").hide();
            
            $(".profile-image-container").removeClass("editable");
            $(".profile-image-container").css("cursor", "default");
            $(".image-overlay").addClass("opacity-0"); 
            
            $("#profileImage").attr("src", originalImageSrc);
            $("#profileFileUpload").val(""); 
        }
    }
}

function saveData(tabName) {
    let formData = new FormData($("#updateForm")[0]);
    
    let fileInput = $("#profileFileUpload")[0];
    if (fileInput.files.length > 0) {
        formData.append("profileImage", fileInput.files[0]);
    }

    $.ajax({
        url: '/member/member_info_update',
        type: 'POST',
        data: formData,
        contentType: false, 
        processData: false, 
        success: function(response) {
            if(response === "success") {
                alert('저장되었습니다.');
                location.reload(); 
            } else {
                alert('저장 실패');
            }
        },
        error: function(e) {
            console.log(e);
            alert('서버 에러가 발생했습니다.');
        }
    });
}

function DaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById("memZipCode").value = data.zonecode;
            document.getElementById("memAddress").value = data.address;
            document.getElementById("memAddressDetail").focus(); 
        }
    }).open();
}

const autoHyphen = (target) => {
    target.value = target.value
        .replace(/[^0-9]/g, '')
        .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3")
        .replace(/(\-{1,2})$/g, "");
}

function resetPassword(memberId) {
    if (!confirm('정말로 비밀번호를 초기화 하시겠습니까?')) return;

    $.ajax({
        url: '/member/reset_password', 
        type: 'POST',
        data: { memberId: memberId },
        success: function(response) {
            if(response === "success") {
                alert('변경된 비밀번호가 메일로 발송되었습니다.');
            } else {
                alert('초기화 실패');
            }
        },
        error: function() {
            alert('서버 에러가 발생했습니다.');
        }
    });
}

function changePassword(memberId){
	$('#changePasswordModal').modal('show');
}	

function submitPasswordChange(){
	let nowPassword = $('#nowPassword').val();
	let changePassword = $('#newPassword').val();
	let confirmPassword = $('#confirmPassword').val();
	let $pwErrorMsg = $('#pwErrorMsg');
	
	if(!nowPassword){
		$pwErrorMsg.text("현재 비밀번호를 입력해 주세요").show();
		$('#nowPassword').focus();
		return;
	}
	
	if(!changePassword){
		$pwErrorMsg.text("새 비밀번호를 입력해 주세요").show();
		$('#newPassword').focus();
		return;
	}
	
	if(confirmPassword != changePassword){
		$pwErrorMsg.text("비밀번호가 일치하지 않습니다.").show();
		$('#confirmPassword').focus();
		return;
	}
	
	$.ajax({
        url: '/member/changePassword', 
        type: 'POST',
        data: { 
            nowPassword: nowPassword,
            changePassword: changePassword
        },
        success: function(response) {
            if(response === "success") {
                alert('비밀번호가 변경되었습니다.');
                location.reload();
            } else {
                $pwErrorMsg.text(response).show();
            }
        },
        error: function() {
            $pwErrorMsg.text('서버 통신 중 오류가 발생했습니다.').show();
        }
    });
}

function InActive(memberId){
    if(!confirm('정말 퇴직 처리하시겠습니까?')) return;
    
    $.ajax({
        url: '/member/InActive', 
        type: 'POST',
        data: { memberId: memberId },
        success: function(response) {
            if(response === "success") {
                alert('퇴직상태로 변경되었습니다.');
                location.reload();
            } else {
                alert('처리 실패');
            }
        },
        error: function() {
            alert('서버 에러가 발생했습니다.');
        }
    });
}


function openEditModal(btn) {
    const id = btn.dataset.commuteId; 
    
    const workDate = btn.dataset.date;
    const inTime = btn.dataset.inTime;
    const outTime = btn.dataset.outTime;
    const state = btn.dataset.state;
    const note = btn.dataset.note;

    document.getElementById('editCommuteId').value = id;
    document.getElementById('editDate').value = workDate;
    
    document.getElementById('editInTime').value = inTime ? inTime : "";
    document.getElementById('editOutTime').value = outTime ? outTime : "";
    
    document.getElementById('editStatus').value = state;
    document.getElementById('editNote').value = note;

    const editModal = new bootstrap.Modal(document.getElementById('modalAttendanceEdit'));
    editModal.show();
}

function formatDateTime(dateStr, timeStr) {
    if (!timeStr) return null; 
    
    let cleanTime = timeStr.replace("T", " ");
    
    if (!cleanTime.startsWith(dateStr)) {
        cleanTime = dateStr + " " + cleanTime;
    }
    if (cleanTime.length === 16) {
        cleanTime += ":00";
    }
    
    if (cleanTime.length > 19) {
        cleanTime = cleanTime.substring(0, 19);
    }

    return cleanTime;
}

function saveAttendanceChanges() {
	const idVal = document.getElementById('editCommuteId').value;
	    const workDate = document.getElementById('editDate').value;
	    const inTimeVal = document.getElementById('editInTime').value;
	    const outTimeVal = document.getElementById('editOutTime').value;

	    const fullInTime = formatDateTime(workDate, inTimeVal);
	    const fullOutTime = formatDateTime(workDate, outTimeVal);

	    const updateData = {
	        memberCommuteId: idVal,
	        memCommuteState: document.getElementById('editStatus').value,
	        memCommuteNote: document.getElementById('editNote').value,
	        memCommuteInTime: fullInTime,
	        memCommuteOutTime: fullOutTime
	    };


    fetch('/member/updateCommute', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(updateData)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('서버 응답 에러: ' + response.status);
        }
        return response.json();
    })
    .then(data => {
        if(data.success || data.result > 0) {
            alert("수정되었습니다.");
			const currentUrl = new URL(window.location.href);
	        currentUrl.searchParams.set("tab", "attendance");
			
			window.location.href = currentUrl.toString();
        } else {
            alert("수정 실패");
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert("저장 중 오류가 발생했습니다. (콘솔 확인)");
    });
}