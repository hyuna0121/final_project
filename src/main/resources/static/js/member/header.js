    function updateClock() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('ko-KR', { hour12: false , minute: '2-digit', hour: '2-digit'});
        const clock = document.getElementById('headerClock');
        if(clock) clock.innerText = timeString;
    }
    setInterval(updateClock, 1000);
    updateClock();

	function date(){
		const now = new Date();
		    const month = String(now.getMonth() + 1).padStart(2, '0');
		    const day = String(now.getDate()).padStart(2, '0');
		    const week = now.toLocaleDateString('ko-KR', { weekday: 'short' });

		    const dayString = `${month}월 ${day}일 (${week}) `;

		    const view = document.getElementById('date');
		    if (view) view.innerText = dayString;
	}
		date();
		
		

	$(document).ready(function(){
		$(document).on('click', '#inCommute', function(){
		        if(!confirm("현재 시간으로 출근하시겠습니까?")) return;
				
				fetch('/commute/checkIn', {
				                method: 'POST',
				                headers: { 'Content-Type': 'application/json' }
				            })
				            .then(response => response.text()) 
				            .then(data => {
				                if (data === 'success') {
				                    alert("출근 처리가 완료되었습니다. 오늘도 화이팅!");
				                    location.reload(); 
				                } else if (data === 'already') {
				                    alert("이미 출근 처리가 되어 있습니다.");
				                } else {
				                    alert("출근 처리에 실패했습니다. (관리자 문의)");
				                }
				            })
				            .catch(error => {
				                console.error('Error:', error);
				                alert("서버 통신 중 오류가 발생했습니다.");
				            });
				        });
				    })
					
					$(document).ready(function(){
							$(document).on('click', '#outCommute', function(){
								if(!confirm("현재 시간으로 퇴근 하시겠습니까?")) return;
								
								fetch('/commute/checkOut', {
									method: 'POST',
									headers: { 'Content-Type': 'application/json' }
						            })
						            .then(response => response.text()) 
						            .then(data => {
						                if (data === 'success') {
						                    alert("퇴근 처리가 완료되었습니다. 오늘도 수고하셨습니다!");
						                    location.reload(); 
						                } else if (data === 'already') {
						                    alert("이미 퇴근 처리가 되어 있습니다.");
						                } else {
						                    alert("퇴근 처리에 실패했습니다. (관리자 문의)");
						                }
						            })
						            .catch(error => {
						                console.error('Error:', error);
						                alert("서버 통신 중 오류가 발생했습니다.");
						            });
						        });
						    })			
					
