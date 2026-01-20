document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".release-row").forEach(row => {
    row.addEventListener("click", () => {
      const inputId = row.dataset.inputId;
      document.getElementById("selectedInputId").innerText = inputId;

      fetch(`/stock/release?inputId=${inputId}`)
        .then(res => res.json())
        .then(data => {
          const tbody = document.getElementById("releaseDetailBody");
          tbody.innerHTML = "";

          if (data.length === 0) {
            tbody.innerHTML = `
              <tr>
                <td colspan="2" class="text-muted">상세 내역 없음</td>
              </tr>`;
            return;
          }
		  
          data.forEach(item => {
            const tr = document.createElement("tr");
            tr.innerHTML = `
              <td>${item.itemName}</td>
              <td>${item.quantity}</td>
            `;
            tbody.appendChild(tr);
          });
        });
    });
  });
});