
function searchItems() {
  $.ajax({
    url: "/item/search",
    type: "GET",
    dataType: "json",
    data: {
      itemName: $("#searchItemName").val(),
      category: $("#searchCategory").val(),
      vendorCode: $("#searchVendorCode").val()
    },
    success: function(list) {
      let html = "";

      if (list.length === 0) {
        html = `
          <tr>
            <td colspan="7" class="text-center text-muted">
              검색 결과가 없습니다.
            </td>
          </tr>`;
      } else {
        $.each(list, function(i, item) {
          html += `
            <tr>
			  <td class="text" style="width: 5%;">
			      <button class="btn btn-sm btn-light"
				      onclick="toggleFavorite(this, 'am0012')"
				      title="즐겨찾기">
				      <i class="bx bx-star"></i>
				  </button>
			  </td>
			  <td style="width: 5%;">${item.itemCode}</td>
		      <td class="text" style="width: 5%;">${item.itemCategory}</td>
		      <td>${item.itemName}</td>
			  <td class="text" style="width: 5%;">
			    ${
			      item.itemEnable == 0
			        ? '<span class="badge bg-label-success" style="width: 46px;">사용</span>'
			        : '<span class="badge bg-label-danger" style="width: 46px;">미사용</span>'
			    }
			  </td>
		      <td class="text" style="width: 5%;">
				<button class="btn btn-sm btn-outline-warning btn-update-item"
				  data-bs-toggle="modal"
				  data-bs-target="#editModal"				  
				  data-id="${item.itemId}"
				  data-name="${item.itemName}"
				  data-itemuse="${item.itemEnable}"
				  data-autouse="${item.itemAutoOrder}">
				  수정
				</button>
			    <button class="btn btn-sm btn-outline-danger btn-update-price"
			      data-bs-toggle="modal"
			      data-bs-target="#editModal"
				  data-id="${item.itemId}"
			      data-name="${item.itemName}"
			      data-price="${item.itemSupplyPrice}"
			      data-priceuse="${item.itemPriceEnable}">
			      단가 등록
			    </button>
			  </td>
            </tr>`;
        });
      }

      $("#itemTableBody").html(html);
    },
	error: function (xhr, status, error) {
	  console.log("xhr.status =", xhr.status);
	  console.log("xhr.responseText =", xhr.responseText);
	  console.log("status =", status);
	  console.log("error =", error);
	  alert("검색 실패");
	}
  })
}

function searchPrices(){
	$.ajax({
		url: "/item/searchPrice",
		type: "GET",
		dataType: "json",
		data: {
		      itemName: $("#searchItemName").val(),
		      category: $("#searchCategory").val(),
		      itemPriceEnable: $("#searchPriceEnable").val(),
		      vendorCode: $("#searchVendorCode").val()
		    },
		success : function(list){
		  let html = "";

	      if (list.length === 0) {
	        html = `
	          <tr>
	            <td colspan="7" class="text-center text-muted">
	              검색 결과가 없습니다.
	            </td>
	          </tr>`;
	      } else {
			$.each(list, function(i, itemPrice){
			  /* 카테고리 뱃지 */
	          const categoryBadge =
	            itemPrice.itemCode.startsWith("FD")
	              ? `<span class="badge bg-label-warning">식품</span>`
	              : `<span class="badge bg-label-dark">비식품</span>`;

	          /* 사용 여부 뱃지 */
	          const priceEnableBadge =
	            itemPrice.itemPriceEnable
	              ? `<span class="badge bg-label-danger" style="width: 46px;">미사용</span>`
	              : `<span class="badge bg-label-success" style="width: 46px;">사용</span>`;

	          /* 숫자 포맷 */
	          const price =
	            Number(itemPrice.itemSupplyPrice).toLocaleString();
				
				html += `<tr>
			               <td style="width: 5%;">${itemPrice.itemCode}</td>
			               <td class="text" style="width: 5%;">${categoryBadge}</td>
			               <td>${itemPrice.itemName}</td>
			               <td style="width: 5%;">${itemPrice.vendorCode}</td>
			               <td>${itemPrice.vendorName}</td>
			               <td class="price" style="width: 13%; text-align: right;">${price}</td>
			               <td class="text" style="width: 8%;">
			                 <div class="d-flex align-items-center gap-3">
                                 ${priceEnableBadge}
                                 <form action="priceCheck" method="post">
                                  <input type="hidden" name="itemPriceId" value="${itemPrice.itemPriceId}">
                                  <input type="hidden" name="itemPriceEnable" value="${itemPrice.itemPriceEnable}">
                                    <button class="btn btn-sm btn-outline-warning btn-update-item" style="padding: 1px 10px;"
                                      data-bs-toggle="modal"
                                      data-bs-target="#editModal">
                                      변경
                                    </button>
                                 </form>
			                 </div>
			               </td>
			             </tr>`
				;
			});
		  }
		  
		  $("#priceTableBody").html(html);
		}, 
		error: function(xhr, status, error){
		  console.log("xhr.status =", xhr.status);
		  console.log("xhr.responseText =", xhr.responseText);
		  console.log("status =", status);
		  console.log("error =", error);
		  alert("검색 실패");
		}
	})
}