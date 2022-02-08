var priceScore_row = 0;
var scores = stock_statuses = Array();

function addControlPrice () {
	html  = '<div class="tab-pane" id="tab-controlPrice">';
	html += '	<table id="controlPrice" class="table table-hover">';

	html += '		<thead>';
	html += '			<tr>';
	html += '				<td class="text-center">Поставщик</td>';
	html += '				<td class="text-center">Идентиф./Артикул</td>';
	html += '				<td class="text-center">Название</td>';
	html += '				<td class="text-center">Цена</td>';
	html += '				<td class="text-center">Наличие</td>';
	html += '				<td class="text-center">Наценка</td>';
	html += '				<td></td>';
	html += '			</tr>';
	html += '		</thead>';

	html += '		<tbody></tbody>';

	html += '		<tfoot>';
	html += '			<tr>';
	html += '				<td colspan="5"></td>';
	html += '				<td class="left"><button type="button" onclick="addPriceScore();" class="btn btn-primary">Добавить</button></td>';
	html += '			</tr>';
	html += '		</tfoot>';

	html += '	</table>';
	html += '</div>';

	$('form > ul.nav-tabs').append('<li><a href="#tab-controlPrice" data-toggle="tab">Price Control</a></li>'); //Вкладку Price Control

	$('form > .tab-content').append(html);
}

function addPriceScore (data = 0) {
	product_name = model = '';
	price_control_id = pc_score_id = price = extra_charge = stock_status_id = label = 0;

	if (data) {
		price_control_id = data.price_control_id;
		pc_score_id = data.pc_score_id;
		price = data.price;
		stock_status_id = data.stock_status_id;
		product_name = data.name;
		model = data.model;
		extra_charge = data.extra_charge;
		label = data.label;
	}

	html  = '<tr id="priceScore' + priceScore_row + '">';

	html += '	<td class="text-center"><select name="price_conrol[' + priceScore_row + '][pc_score_id]" class="form-control">';
	$.each(scores, function (i, val){
		if (val.pc_score_id == pc_score_id) html += '	<option selected value="' + val.pc_score_id + '">' + val.name + '</option>';
		else html += '	<option value="' + val.pc_score_id + '">' + val.name + '</option>';
	});
	html += '	</select></td>';

	html += '	<td class="text-center">';
	html += '		<input type="text" class="form-control" name="price_conrol[' + priceScore_row + '][model]" value="' + model + '" placeholder="Идент./Артикул" />';
	html += '	</td>';
	html += '	<td class="text-center"><input type="text" class="form-control" name="price_conrol[' + priceScore_row + '][name]" value="' + product_name + '" placeholder="Название" /></td>';
	html += '	<td class="text-center"><input type="number" class="form-control text-center" step="0.0001" min="0" name="price_conrol[' + priceScore_row + '][price]" value="' + price + '" placeholder="Цена" /></td>';

	html += '	<td class="text-center"><select name="price_conrol[' + priceScore_row + '][stock_status_id]" class="form-control">';
	$.each(stock_statuses, function (i, val){
		if (val.stock_status_id == stock_status_id) html += '	<option selected value="' + val.stock_status_id + '">' + val.name + '</option>';
		else html += '	<option value="' + val.stock_status_id + '">' + val.name + '</option>';
	});
	html += '	</select></td>';

	html += '	<td class="text-center"><input type="number" class="form-control text-center" step="1" name="price_conrol[' + priceScore_row + '][extra_charge]" value="' + extra_charge + '" placeholder="Наценка" /></td>';

	html += '	<td class="left"><button type="button" onclick="$(\'#priceScore' + priceScore_row + '\').remove();" class="btn btn-danger"><i class="fa fa-minus-circle"></i></button>';
	html += '		<input hidden name="price_conrol[' + priceScore_row + '][price_control_id]" value="' + price_control_id + '" />';
	html += '		<input hidden name="price_conrol[' + priceScore_row + '][label]" value="' + label + '" />';
	html += '	</td>';


	html += '</tr>';

	$('table#controlPrice tbody').append(html);
	priceScore_row++;
}

$( document ).ready(function() {
	$.ajax({
		url: 'index.php?route=extension/module/price_control/productScore&user_token='+getURLVar('user_token')+'&product_id='+getURLVar('product_id'),
		dataType: 'json',
		success: function(json) {
			addControlPrice ();

			scores = json.scores;
			stock_statuses = json.stock_statuses;

			if (json.product_score) {
				$.each(json.product_score, function (i, val){
					addPriceScore(val);
				});
			}
		}
	});
});