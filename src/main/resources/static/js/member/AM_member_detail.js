let originalImageSrc = ''; 

$(document).ready(function() {
    
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
});

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


function toggleDateInputs() {
    const type = document.getElementById("dateType").value;
    const areaMonth = document.getElementById("input-month");
    const areaYear = document.getElementById("input-year");
    const areaCustom = document.getElementById("input-custom");
    const dateInputArea = document.getElementById("dateInputArea");

    areaMonth.style.display = "none";
    areaYear.style.display = "none";
    areaCustom.style.display = "none";
    
    if (type === "all") {
        dateInputArea.style.display = "none";
    } else {
        dateInputArea.style.display = "block";
        if (type === "month") areaMonth.style.display = "block";
        else if (type === "year") areaYear.style.display = "block";
        else if (type === "custom") areaCustom.style.display = "block";
    }
}

function applyFilters() {
    const type = document.getElementById("dateType").value;
    const statusFilter = document.getElementById("attendanceStatusFilter").value;
    const table = document.getElementById("attendanceTable");
    const rows = table.getElementsByTagName("tr");
    let visibleCount = 0;

    const valMonth = document.getElementById("filterMonth").value;
    const valYear = document.getElementById("filterYear").value;
    const valStart = document.getElementById("filterStartDate").value;
    const valEnd = document.getElementById("filterEndDate").value;

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const rowDate = row.getAttribute("data-date");
        const rowStatus = row.getAttribute("data-status");
        let dateMatch = false;
        let statusMatch = false;

        if (type === "all") dateMatch = true;
        else if (type === "month" && rowDate.startsWith(valMonth)) dateMatch = true;
        else if (type === "year" && rowDate.startsWith(valYear)) dateMatch = true;
        else if (type === "custom" && rowDate >= valStart && rowDate <= valEnd) dateMatch = true;

        if (statusFilter === "all" || rowStatus === statusFilter) statusMatch = true;

        if (dateMatch && statusMatch) {
            row.style.display = "";
            visibleCount++;
        } else {
            row.style.display = "none";
        }
    }

    const noDataMsg = document.getElementById("noDataMessage");
    if (visibleCount === 0) {
        noDataMsg.style.display = "block";
        table.style.display = "none";
    } else {
        noDataMsg.style.display = "none";
        table.style.display = "";
    }
}

function openEditModal(btn) {
    const tr = btn.closest('tr');
    
    const date = tr.getAttribute('data-date');
    const inTime = tr.getAttribute('data-in');
    const outTime = tr.getAttribute('data-out');
    const status = tr.getAttribute('data-status');
    const note = tr.getAttribute('data-note');
    
    document.getElementById('editDate').value = date;
    document.getElementById('editInTime').value = inTime; 
    document.getElementById('editOutTime').value = outTime;
    document.getElementById('editStatus').value = status;
    document.getElementById('editNote').value = note ? note : "";

    document.getElementById('currentRowIndex').value = tr.rowIndex;

    const myModal = new bootstrap.Modal(document.getElementById('modalAttendanceEdit'));
    myModal.show();
}

function saveAttendanceChanges() {
    const rowIndex = document.getElementById('currentRowIndex').value;
    const newInTime = document.getElementById('editInTime').value;
    const newOutTime = document.getElementById('editOutTime').value;
    const newStatus = document.getElementById('editStatus').value;
    const newNote = document.getElementById('editNote').value;
    
    alert("수정되었습니다. (DB 반영 로직 필요)");

    const table = document.getElementById('attendanceTable');
    const tr = table.rows[rowIndex]; 

    tr.querySelector('.in-time').innerText = newInTime ? newInTime : "-";
    tr.querySelector('.out-time').innerText = newOutTime ? newOutTime : "-";
    tr.querySelector('.note-text').innerText = newNote;

    const badge = tr.querySelector('.status-badge');
    let badgeClass = "bg-label-primary";
    let badgeText = "기타";

    if(newStatus === 'normal') { badgeClass="bg-label-success"; badgeText="정상"; }
    else if(newStatus === 'late') { badgeClass="bg-label-warning"; badgeText="지각"; }
    else if(newStatus === 'early') { badgeClass="bg-label-info"; badgeText="조퇴"; }
    else if(newStatus === 'absent') { badgeClass="bg-label-danger"; badgeText="결근"; }
    else if(newStatus === 'vacation') { badgeClass="bg-label-primary"; badgeText="연차/휴가"; }
    else if(newStatus === 'half') { badgeClass="bg-label-info"; badgeText="반차"; }

    badge.className = `badge ${badgeClass} status-badge`;
    badge.innerText = badgeText;

    tr.setAttribute('data-in', newInTime);
    tr.setAttribute('data-out', newOutTime);
    tr.setAttribute('data-status', newStatus);
    tr.setAttribute('data-note', newNote);

    const modalEl = document.getElementById('modalAttendanceEdit');
    const modalInstance = bootstrap.Modal.getInstance(modalEl);
    modalInstance.hide();
}