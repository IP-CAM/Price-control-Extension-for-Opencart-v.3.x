var stock_statuses = Array();

function addProductContractor (data) {

	if (data.stock_status_id == 1) {
		stock_style = 'background-color: greenyellow;';
	} else if (data.stock_status_id == 99) {
		stock_style = 'background-color: #f96e6e70;';
	} else {
		stock_style = 'background-color: #fff7a4;';
	}

	href = '';

	if (data.score_url) {
		if (data.product_name) {
			href = 'href="' + data.score_url+encodeURI(data.product_name) + '"';
		} else {
			href = 'href="' + data.score_url + '"';
		}

			// ВРЕМЕННО!!!!!
		href = 'href="' + data.score_url + '"';
	}

	html  = '<div style="padding-top:7px;">';
	html += '<span style="float:left;overflow:hidden;text-overflow:ellipsis;max-width:60%;white-space:nowrap;" title="' + data.score_name + ' - ' + data.product_name + ' (' + data.model + ')"><a ' + href + ' rel="noreferrer noopener" target="_blank">' + data.score_name + '</a></span>';
	html += '<span style="float:right; padding:1px 3px;' + stock_style + '" title="' + stock_statuses[data.stock_status_id] + ' - ' + data.price_purchase + ' (' + data.score_price + ') ' + data.currency_code + '">' + data.price_uah + '</span>';
	html += '</div><br />';

	$('#product' + data.product_id + ' .product-contractor').append(html);
}

$( document ).ready(function() {

	$('thead tr td:nth-child(5)').after('<td class="text-left">Поставщики (UAH)</td>');

	$('tbody tr td:nth-child(5)').after('<td class="text-left product-contractor"></td>');

	product_id = [];

	$('input[name^=selected]').each(function (){
		product_id.push($(this).val());
	});

	$.ajax({
		url: 'index.php?route=extension/module/price_control/productListScore&user_token='+getURLVar('user_token'),
		type:'POST',
		data: {product_id:product_id},
		dataType: 'json',
		success: function(json) {
			stock_statuses = json.stock_statuses;
			if (json.product_scores) {
				$.each(json.product_scores, function (i, val){
					addProductContractor(val);
				});
			}
		}
	});
});