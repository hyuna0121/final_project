
document.addEventListener('DOMContentLoaded' , () => {
	loadReceivables();
	bindEvents();
});

let remainAmount = 0;

/* input 태그 text 숫자 변환 처리 */

function parseNumber(value) {
	if(!value) return 0;
	return Number(value.replace(/,/g,'')) || 0;
	
}
function formatNumber(value) {
	return value.toLocaleString();
}

/* 가맹점 채권 목록 로딩 */
function loadReceivables() {
	const storeIdEl = document.getElementById('storeId')
	const baseMonthEl = document.getElementById('baseMonth');
	if(!storeIdEl) return;
	
	const storeId = storeIdEl.value;
	const baseMonth = baseMonthEl.value;
	fetch(`/receivable/avilable?storeId=${storeId}&baseMonth=${baseMonth}`)
		.then(res => res.json())
		.then(data => renderReceivableOptions(data))
		.catch(err => console.error('채권 조회 실패', err));
}
/* select 태그에 option tag 생성 */
function renderReceivableOptions(list) {
	const select = document.getElementById('receivableSelect');
	if(!select) return;
	
	select.innerHTML = `<option value="">채권 선택</option>`;
	list.forEach(r => {
		const option = document.createElement('option');
		
		option.value =  r.receivableId;
		option.textContent = 
			`${r.receivableId} (${r.sourceType === 'ORDER' ? '물품대금' : '가맹비'})`;
		option.dataset.remain = r.remainAmount;
		option.dataset.type = r.sourceType;
		
		select.appendChild(option);
	});
	if (list.length === 1) {
	  select.value = list[0].receivableId;
	  select.dispatchEvent(new Event('change'));
	}
	
}

/* 각종 이벤트 생성 */
function bindEvents() {
	const receivableSelect = document.getElementById('receivableSelect');
	const payInput = document.getElementById('payAmount');
	const payAllBtn = document.getElementById('payAllBtn');
	const modalEl = document.getElementById('paymentModal');
	const resetAmountBtn = document.getElementById('resetAmountBtn');
	const saveBtn = document.getElementById('paymentSaveBtn');
	
	
	if(receivableSelect) {
		receivableSelect.addEventListener('change',onReceivableChange);
	}
	
	if(payInput){
		payInput.addEventListener('input',onPayAmountInput);
	}
	
	document.querySelectorAll('.quick-pay').forEach(btn => {
		btn.addEventListener('click' , onQuickPayClick);
	});
	
	if(payAllBtn) {
		payAllBtn.addEventListener('click' , onPayAll);
	}
	
	if(modalEl){
		modalEl.addEventListener('hidden.bs.modal' , resetPaymentForm);
	}
	
	if (resetAmountBtn) {
	  resetAmountBtn.addEventListener('click', resetPayAmount);
	}
	if (saveBtn) {
	  saveBtn.addEventListener('click', onSavePayment);
	}
}


/* 채권 선택 시 이벤트 */
function onReceivableChange(e) {
	const option = e.target.selectedOptions[0];
	if(!option || !option.value) return;
	
	remainAmount = Number(option.dataset.remain);
	
	const remainInput = document.getElementById('remainAmount');
	const payInput = document.getElementById('payAmount');
	const sourceTypeText = document.getElementById('sourceTypeText');
	const sourceType = document.getElementById('sourceType');
	
	if(remainInput) {
		remainInput.value = formatNumber(remainAmount);
	}
	
	if(payInput) {
		payInput.value = formatNumber(0);
	}
	
	if(sourceType && sourceTypeText) {
		sourceType.value = option.dataset.type;
		sourceTypeText.value = 
			option.dataset.type === 'ORDER' ? '물품대금' : '가맹비';
	}
}

/* 지급 금액 직접 입력 */
function onPayAmountInput(e) {
	
	let value = parseNumber(e.target.value);
	
	if(value > remainAmount) value = remainAmount;
	if (value < 0 ) value = 0;
	
	e.target.value = formatNumber(value);
}
/* 빠른 금액 버튼 */
function onQuickPayClick(e) {
	const addAmount = Number(e.target.dataset.amount);
	const payInput = document.getElementById('payAmount');
	
	let current = parseNumber(payInput.value);
	let next = current + addAmount;
	
	if(next > remainAmount) next = remainAmount;
	
	payInput.value = formatNumber(next);
}
/* 완납 버튼 */
function onPayAll() {
	document.getElementById('payAmount').value = formatNumber(remainAmount);
}

function resetPaymentForm() {
	const form = document.getElementById('paymentForm');
	if(form) form.reset();
	
	document.getElementById('receivableSelect').value = '';
	document.getElementById('remainAmount').value = '';
	document.getElementById('payAmount').value = '';
	document.getElementById('sourceTypeText').value = '';
	document.getElementById('sourceType').value = '';
	
	remainAmount = 0;
}


function resetPayAmount() {
  const payInput = document.getElementById('payAmount');
  if (!payInput) return;
  console.log('click')
  payInput.value = formatNumber(0);
}


function onSavePayment() {
  const saveBtn = document.getElementById('paymentSaveBtn');
  const receivableId = document.getElementById('receivableSelect').value;
  const amount = parseNumber(document.getElementById('payAmount').value);
  const memo =
    document.querySelector('textarea[name="transactionMemo"]').value;

  if (!receivableId || amount <= 0) {
    alert('채권과 지급 금액을 확인해주세요.');
    return;
  }

  saveBtn.disabled = true;
  saveBtn.innerText = '처리 중...';

  fetch('/receivable/collection', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      receivableId: receivableId,
      amount: amount,
      memo: memo
    })
  })
    .then(res => {
      if (!res.ok) throw new Error('저장 실패');
      return res.text();
    })
    .then(msg => {
      alert(msg || '지급이 정상적으로 처리되었습니다.');

      // 모달 닫기
      const modalEl = document.getElementById('paymentModal');
      const modal = bootstrap.Modal.getInstance(modalEl);
      modal.hide();

      location.reload();
    })
    .catch(err => {
      console.error(err);
      alert('지급 처리 중 오류가 발생했습니다.');
      saveBtn.disabled = false;
      saveBtn.innerText = '지급';
    });
}
