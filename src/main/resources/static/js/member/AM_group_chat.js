let currentDeptFilter = 0; 
let currentDeptName = "전체 사원";

$(document).ready(function() {
    renderTable(0);

    $(".dept-item").click(function() {
        $(".dept-item").removeClass("active");
        $(this).addClass("active");

        currentDeptFilter = $(this).data("dept");
        
        let deptName = $(this).find("span").first().text().trim();
        if(deptName.startsWith("└")) deptName = deptName.substring(1).trim();
        currentDeptName = deptName;

        renderTable(currentDeptFilter, currentDeptName);
    });

    $("#searchMember").on("keyup", function() {
        renderTable(currentDeptFilter, currentDeptName);
    });
    $("#checkRetired").change(function() {
        renderTable(currentDeptFilter, currentDeptName);
    });
});

function renderTable(deptCode, deptName = currentDeptName) {
    let isRetiredIncluded = $("#checkRetired").is(":checked"); 
    let searchKeyword = $("#searchMember").val();

    if (deptCode == 0) {
        $("#selectedDeptTitle").text("전체 사원");
    } else {
        $("#selectedDeptTitle").text(deptName);
    }

    $.ajax({
        url: "/member/checkCount",
        type: "GET",
        data: { 
            deptCode: deptCode, 
            includeRetired: isRetiredIncluded,
            keyword: searchKeyword
        },
        success: function(data) {
            drawTable(data); 
        },
        error: function(xhr, status, error) {
            console.error("데이터 로드 실패:", error);
        }
    });
}

function drawTable(memberList) {
    const tbody = $("#memberTableBody");
    tbody.empty();

    $("#selectedDeptCount").text(`총 ${memberList.length}명`);

    if (memberList.length === 0) {
        $("#noDataMessage").show();
    } else {
        $("#noDataMessage").hide();
    }

    memberList.forEach(member => {
        let statusBadge = '';
		if(member.memIsActive == 'Y' || member.memIsActive == 1 || member.memIsActive == true) {
		        statusBadge = '<span class="badge bg-label-success">재직</span>';
		    } else {
		        statusBadge = '<span class="badge bg-label-danger">퇴사</span>';
		    }

        const row = `
            <tr>
                <td>
                    <div class="d-flex align-items-center">
                        <div class="avatar avatar-sm me-2">
                            <img src="/fileDownload/profile?fileSavedName=${member.memProfileSavedName}" ... >
                        </div>
                        <div>
                            <h6 class="mb-0 text-truncate">${member.memName}</h6>
                            <small class="text-muted">${member.memberId}</small>
                        </div>
                    </div>
                </td>
                <td>${member.memDeptName || '-'}</td>
                <td><span class="fw-semibold">${member.memPositionName || '-'}</span></td>
                <td>${statusBadge}</td>
                <td>${member.memPhone || ''}</td>
                <td class="text-center">
                    <button onclick="openMemberDetail('${member.memberId}')" class="btn btn-sm btn-icon btn-outline-secondary" title="상세 정보">
                        <i class="bx bx-show"></i>
                    </button>
                </td>
            </tr>
        `;
        tbody.append(row);
    });
}


function openMemberDetail(id) {
    console.log("상세보기 클릭:", id);
    const myModal = new bootstrap.Modal(document.getElementById('modalMemberDetail'));
    myModal.show();
}

function saveMemberDetails() {
    alert("저장 기능은 구현 필요");
}

function openDeptEdit(event, deptId, deptName) {
    event.stopPropagation();
    $("#editDeptId").val(deptId);
    $("#editDeptName").val(deptName);
    new bootstrap.Modal(document.getElementById('modalDeptEdit')).show();
}

function deleteDept(event, deptId) {
    event.stopPropagation();
    if(confirm("정말 이 부서를 삭제하시겠습니까?")) {
        alert("삭제 요청: " + deptId);
    }
}

function openAuthModal(event, deptId, deptName) {
    event.stopPropagation();
    $("#authTargetDept").text(deptName);
    $("#authTargetDeptId").val(deptId);
    new bootstrap.Modal(document.getElementById('modalAuth')).show();
}

function saveAuth() {
    alert("권한 설정이 저장되었습니다.");
    const modal = bootstrap.Modal.getInstance(document.getElementById('modalAuth'));
    modal.hide();
}