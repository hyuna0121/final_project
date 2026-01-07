function updateRowTotal(input) {
  const tr = input.closest("tr");
  const price = Number(tr.dataset.price);
  const qty = Number(input.value);

  const total = price * qty;
  tr.querySelector(".row-total").innerText = total.toLocaleString();

  updateGrandTotal();
}

function updateGrandTotal() {
  let sum = 0;

  document.querySelectorAll(".row-total").forEach(td => {
    sum += Number(td.innerText.replace(/,/g, ""));
  });

  document.getElementById("grandTotal").innerText = sum.toLocaleString();
}



