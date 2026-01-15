let currentDeptFilter = 0; 
let currentDeptName = "전체 사원";
let searchTimer = null; // 검색어 딜레이

$(document).ready(function() {
    renderTable(0);

    $(".dept-item").click(function() {
        $(".dept-item").removeClass("active");
        $(this).addClass("active");

        currentDeptFilter = $(this).data("dept");
        
        let deptName = $(this).find("span").first().text().trim();
        if(deptName.startsWith("└")) deptName = deptName.substring(1).trim();
        currentDeptName = deptName;

        $("#searchMember").val(''); 

        renderTable(currentDeptFilter, currentDeptName);
    });

    $("#searchMember").on("keyup", function() {
        clearTimeout(searchTimer);
        searchTimer = setTimeout(function() {
            renderTable(currentDeptFilter, currentDeptName);
        }, 300);
    });

    $("#checkRetired").change(function() {
        renderTable(currentDeptFilter, currentDeptName);
    });
});

function renderTable(deptCode, deptName = currentDeptName) {
    let searchKeyword = $("#searchMember").val();
    let isRetiredIncluded = $("#checkRetired").is(":checked"); 

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
			if(data.memberList){
				drawTable(data.memberList)
			}else{
	            drawTable(data); 
			}
			
			if(data.deptCounts){
				updateSidebarCounts(data.deptCounts);
			}
        },
        error: function(xhr, status, error) {
            console.error("데이터 로드 실패:", error);
        }
    });
}

function drawTable(memberList) {
    const tbody = $("#memberTableBody");
    tbody.empty();

    $("#selectedDeptCount").text(`(총 ${memberList.length}명)`);
    
    if (memberList.length === 0) {
        $("#noDataMessage").show();
    } else {
        $("#noDataMessage").hide();
    }

    memberList.forEach(member => {
        let profileImg = member.memProfileSavedName 
            ? `/fileDownload/profile?fileSavedName=${member.memProfileSavedName}` 
            : '/fileDownload/profile?fileSavedName=default_img.jpg'; 

        let statusBadge = '';
        if(member.memIsActive == 'Y' || member.memIsActive == 1 || member.memIsActive === true) {
            statusBadge = '<span class="badge bg-label-success">재직중</span>';
        } else {
            statusBadge = '<span class="badge bg-label-dark">퇴직</span>';
        }

        let posCode = member.positionCode; 
        let posName = member.memPositionName || '-';
        let posClass = 'bg-label-secondary'; 
		
		if (posName === 'ADMIN' || posName === 'admin') {
		            posName = '관리자';
        }

        if ([99].includes(posCode) || posName === '관리자') {
            posClass = 'bg-label-info';
        } else if ([1, 2, 3].includes(posCode) || ['팀장', '차장', '과장'].includes(posName)) {
            posClass = 'bg-label-primary';
        } else if ([10, 11, 12].includes(posCode) || ['이사', '상무', '전무'].includes(posName)) {
            posClass = 'bg-label-danger';
        } else if ([17].includes(posCode) || ['가맹점주', '가맹점'].includes(posName)) {
            posClass = 'bg-label-warning';
        }
		
		let email = member.memEmail || '-';

        const row = `
            <tr>
                <td>
                    <div class="user-wrapper">
                        <img src="${profileImg}" alt="Avatar" class="user-avatar">
                        <div class="user-info">
                            <span class="text-dark fw-bold">${member.memName}</span>
                            <small class="text-muted">${member.memberId}</small>
                        </div>
                    </div>
                </td>
                <td><span class="text-body fw-medium">${member.memDeptName || '-'}</span></td>
                <td class="text-center"><span class="badge ${posClass}">${posName}</span></td>
                <td class="text-center">${statusBadge}</td>
                <td class="text-center"><span class="text-muted">${member.memPhone || ''}</span></td>
                <td class="text-center"><span class="text-muted">${email}</span></td>
            </tr>
        `;
        tbody.append(row);
    });
}



function updateSidebarCounts(deptCounts) {

    let totalCount = 0;

    $(".dept-item .badge").text("0");

    deptCounts.forEach(dept => {
        let code = dept.deptCode || dept.dept_code || dept.DEPT_CODE;
        let count = dept.count || dept.COUNT || 0;

        let $badge = $(`.dept-item[data-dept='${code}'] .badge`);
        
        if ($badge.length > 0) {
            $badge.text(count);
        }

        totalCount += count;
    });

    $(`.dept-item[data-dept='0'] .badge`).text(totalCount);
}



function openMemberDetail(id) {
    const myModal = new bootstrap.Modal(document.getElementById('modalMemberDetail'));
    $("#modalId").val(id);
    myModal.show();
}


function openDeptEdit(event, deptId, deptName) {
    event.stopPropagation();
    $("#editDeptId").val(deptId);
    $("#editDeptName").val(deptName);
    new bootstrap.Modal(document.getElementById('modalDeptEdit')).show();
}

