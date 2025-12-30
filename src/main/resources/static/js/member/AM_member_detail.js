
    function toggleDateInputs() {
        const type = document.getElementById("dateType").value;
        const areaMonth = document.getElementById("input-month");
        const areaYear = document.getElementById("input-year");
        const areaCustom = document.getElementById("input-custom");
        const dateInputArea = document.getElementById("dateInputArea");

        areaMonth.style.display = "none";
        areaYear.style.display = "none";
        areaCustom.style.display = "none";
        
        // 기본적으로 영역을 보이게 설정하고, 'all'일 때만 숨김
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

	
	/* 탭별 수정 모드 토글 함수 */
	function toggleEditMode(isEdit, tabName) {
	    const viewArea = document.getElementById('view-area-' + tabName);
	    const editArea = document.getElementById('edit-area-' + tabName);

	    if (!viewArea || !editArea) return;

	    if (isEdit) {
	        viewArea.style.display = 'none';
	        editArea.style.display = 'block';
	    } else {
	        viewArea.style.display = 'block';
	        editArea.style.display = 'none';
	    }
	}


	function saveData(tabName) {
	    if(!confirm('수정된 정보를 저장하시겠습니까?')) return;
	    
	    toggleEditMode(false, tabName); 
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
	      
	      $('#addMemberModal').on('hidden.bs.modal', function () {
			$(this).find('form')[0].reset();
		})
		
		const autoHyphen = (target) => {
		    target.value = target.value
		        .replace(/[^0-9]/g, '')
		        .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3")
		        .replace(/(\-{1,2})$/g, "");
		}
