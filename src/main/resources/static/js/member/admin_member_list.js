function previewEmpId() {
            const deptSelect = document.getElementById("deptCode");
            const previewInput = document.getElementById("previewIdInput");
            const hiddenPrefix = document.getElementById("idPrefix");
            
            // 1. 선택된 옵션 가져오기
            const selectedOption = deptSelect.options[deptSelect.selectedIndex];
            
            // 2. data-prefix 값 확인 (1 또는 2)
            const prefix = selectedOption.getAttribute("data-prefix");
            
            if (prefix) {
            	hiddenPrefix.value = prefix;
                // 3. 현재 연도 2자리 구하기 (2025 -> 25)
                const year = new Date().getFullYear().toString().substr(-2);
                
                // 4. 프리뷰 문자열 생성 (예: 125xxx)
                previewInput.value = prefix + year + "xxx (생성 예정)";
            } else {
                previewInput.value = "";
            }
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
		
		
		
		function movePage(page) {
		    if (page < 1) page = 1;

		    const form = document.getElementById('searchForm');
			document.getElementById("pageInput").value = page;
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