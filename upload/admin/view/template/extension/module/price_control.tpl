<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
	<span id="popup_content"></span>

	<div class="page-header">
		<div class="container-fluid">
		  <div class="pull-right">
			<button type="button" data-toggle="tooltip" title="<?php echo $button_save_stay; ?>" class="btn btn-success" onclick="$('#savestay').click();"><i class="fa fa-check"></i></button>
			<button type="submit" form="form-priceControl" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary"><i class="fa fa-save"></i></button>
			<input type="submit" hidden form="form-priceControl" id="savestay" name="type_save" value="1" />
			<a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a>
		  </div>
		  <h1><?php echo $heading_title; ?></h1>
		  <ul class="breadcrumb">
			<?php foreach ($breadcrumbs as $breadcrumb) { ?>
				<li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
			<?php } ?>
		  </ul>
		</div>
	</div>

  	<div class="container-fluid">
		<?php if ($error_warning) { ?>
			<div class="alert alert-danger alert-dismissible"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
			  <button type="button" class="close" data-dismiss="alert">&times;</button>
			</div>
		<?php } ?>
		<div class="panel panel-default">
			<div class="panel-heading"><h3 class="panel-title"><i class="fa fa-pencil"></i> <?php echo $text_edit; ?></h3></div>

			<div class="panel-body pulemet">
				<form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-priceControl" class="form-horizontal">

					<div class="form-group">
						<label class="col-sm-2 control-label" for="input-status"><?php echo $entry_status; ?></label>
						<div class="col-sm-10">
							<select name="module_price_control_status" id="input-status" class="form-control">
								<?php if (!empty($module_price_control_status)) { ?>
									<option value="1" selected="selected"><?php echo $text_enabled; ?></option>
									<option value="0"><?php echo $text_disabled; ?></option>
								<?php } else { ?>
									<option value="1"><?php echo $text_enabled; ?></option>
									<option value="0" selected="selected"><?php echo $text_disabled; ?></option>
								<?php } ?>
							</select>
						</div>
					</div>

					<div class="row panel-heading">
						<ul class="nav nav-pills">
							<li><a href="#tab-general" data-toggle="tab"><?php echo $tab_general; ?></a></li>
							<li><a href="#tab-scores" data-toggle="tab"><?php echo $tab_score; ?></a></li>
							<li class="active"><a href="#tab-uload" data-toggle="tab"><?php echo $tab_uload; ?></a></li>
							<li><a href="#tab-contractor" data-toggle="tab">Товары</a></li>

							<div><button type="button" id="update_currency_id" class="btn btn-primary" onclick="update_currency('product');" class="button" style="float:right;">Обновить цены товаров</button></div>
						</ul>

						<?php $score_row = $stock_status_row = 0; ?>

						<div class="tab-content">

							<?php
								# Настройки
								$forValueSettings = [
									['type' => 'number', 'name' => 'model', 'entry' => $entry_settings_model],
									['type' => 'number', 'name' => 'name', 'entry' => $entry_settings_name],
									['type' => 'number', 'name' => 'price', 'entry' => $entry_settings_price],
									['type' => 'text', 'name' => 'quantity', 'entry' => $entry_settings_quantity]
								];
							?>

							<div class="tab-pane" id="tab-general">
								<div class="panel panel-default">
									<div class="panel-body">
										<div class="form-group">
											<label class="col-sm-2 text-right" for="checkbox-list"><?php echo $entry_list; ?></label>
											<div class="col-sm-10">
												<input type="checkbox" id="checkbox-list" name="module_price_control[list]" <?php echo isset($module_price_control['list']) ? 'checked' : ''; ?> value="1" />
											</div>
										</div>
										<div class="form-group">
											<label class="col-sm-2 text-right" for="checkbox-product"><?php echo $entry_product; ?></label>
											<div class="col-sm-10">
												<input type="checkbox" id="checkbox-product" name="module_price_control[product]" <?php echo isset($module_price_control['product']) ? 'checked' : ''; ?> value="1" />
											</div>
										</div>
									</div>
								</div>
							</div>

							<div class="tab-pane " id="tab-scores">
								<div class="panel panel-default">
									<div class="panel-body">
										<table class="table table-striped table-bordered table-hover">
											<thead>
												<tr>
													<td class="text-center">pc_score_id</td>
													<td class="text-center"><?php echo $text_name,' ',$entry_scores; ?></td>
													<td class="text-center"><?php echo $text_url,' ',$entry_scores; ?></td>
													<td class="text-center" width="40px"><button type="button" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary savescore"><i class="fa fa-save"></i></button></td>
												</tr>
											</thead>

											<tbody>
												<?php if ($scores) { ?>
													<?php foreach ($scores as $score) { ?>
														<tr id="score<?php echo $score_row; ?>">
															<td class="text-center"><?php echo $score['pc_score_id']; ?></td>
															<td class="text-center">
																<div class="input-group">
																	<input type="text" name="scores[<?php echo $score_row; ?>][name]" value="<?php echo isset($score['name']) ? $score['name'] : ''; ?>" placeholder="<?php echo $text_name,' ', $entry_scores; ?>" class="form-control" />
																</div>
															</td>
															<td class="text-center">
																<div class="input-group">
																	<input type="text" name="scores[<?php echo $score_row; ?>][url]" value="<?php echo isset($score['url']) ? $score['url'] : ''; ?>" placeholder="<?php echo $text_url; ?>" class="form-control" />
																	<input type="text" hidden name="scores[<?php echo $score_row; ?>][pc_score_id]" value="<?php echo $score['pc_score_id']; ?>"  />
																	<span class="input-group-btn">
																		<button type="button" class="btn btn-info settings-button" data-toggle="tooltip" title="<?php echo $button_settings_display; ?>" onclick="$(this).tooltip('hide');settings_display(<?php echo $score_row; ?>)">
																			<i class="fa fa-plus fa-lg"></i>
																			<i class="fa fa-minus fa-lg"></i>
																		</button>
																	</span>
																</div>
															</td>
															<td class="text-center">
																<button type="button" onclick="$(this).tooltip('destroy');score_remove(<?php echo $score_row; ?>);" data-toggle="tooltip" title="<?php echo $button_remove,' ',$entry_scores; ?>" class="btn btn-danger btn-sm"><i class="fa fa-minus-circle"></i></button>
															</td>
														</tr>

														<tr id="score_settings<?php echo $score_row; ?>" class="settings">
															<td></td>
															<td width="50%">
																<?php foreach ($forValueSettings as $val) {  ?>
																	<div class="input-group">
																		<span class="input-group-addon">[XLS] <?php echo $val['entry']; ?></span>
																		<input type="<?php echo $val['type']; ?>" name="scores[<?php echo $score_row; ?>][pc_column][<?php echo $val['name']; ?>]" value="<?php echo isset($score['pc_column'][$val['name']]) ? $score['pc_column'][$val['name']] : ''; ?>" placeholder="<?php echo $val['entry']; ?>" class="form-control" />
																	</div><br />
																<?php } ?>
																<div class="form-group">
																	<label class="col-sm-3 control-label">Главн. Идент.</label>
																	<div class="col-sm-6">
																		<select name="scores[<?php echo $score_row; ?>][pc_column][basic_col]" class="form-control">
																			<?php foreach ($forValueSettings as $val) { ?>
																				<option <?php echo $val['name'] == $score['pc_column']['basic_col'] ? 'selected' : ''; ?> value="<?php echo $val['name']; ?>" >[XLS] <?php echo $val['entry']; ?></option>
																			<?php } ?>
																		</select>
																	</div>
																</div>
															</td>
															<td width="50%">

																<div class="form-group">
																	<label class="col-sm-4 control-label">Базовая валюта</label>
																	<div class="col-sm-6">
																		<select name="scores[<?php echo $score_row; ?>][currency_id]" class="form-control">
																			<?php foreach ($currencys as $currency) { ?>
																				<option <?php echo $currency['currency_id'] == $score['currency_id'] ? 'selected' : ''; ?> value="<?php echo $currency['currency_id']; ?>" ><?php echo $currency['title'].' ['.$currency['code'].']'; ?></option>
																			<?php } ?>
																		</select>
																	</div>
																</div>


																<div class="input-group">
																	<span class="input-group-addon">Наценка (зак.) %</span>
																	<input type="text" name="scores[<?php echo $score_row; ?>][markup][extra_charge]" value="<?php echo isset($score['markup']['extra_charge']) ? $score['markup']['extra_charge'] : ''; ?>" placeholder="Наценка (зак.) %" class="form-control" />
																</div>
																<br />
																<div class="input-group">
																	<span class="input-group-addon">Наценка (розн.) %</span>
																	<input type="text" name="scores[<?php echo $score_row; ?>][markup][extra_charge_rozn]" value="<?php echo isset($score['markup']['extra_charge_rozn']) ? $score['markup']['extra_charge_rozn'] : ''; ?>" placeholder="Наценка (розн.) %" class="form-control" />
																</div>
																<br />
																<div class="input-group">
																	<span class="input-group-addon">Скидка от розницы %</span>
																	<input type="number" name="scores[<?php echo $score_row; ?>][markup][skidka]" value="<?php echo isset($score['markup']['skidka']) ? $score['markup']['skidka'] : ''; ?>" placeholder="Скидка от розницы %" class="form-control" />
																</div>

																<div class="panel-body stock">
																	<H4 class="col-sm-12 text-center">Статус на складе (<?php echo $entry_settings_quantity; ?>)</H4>

																	<?php if (!empty($score['stock_status'])) { ?>
																		<?php foreach ($score['stock_status'] as $stocks) { ?>
																			<div class="input-group select-group" id="stock<?php echo $stock_status_row; ?>">

																				<span class="input-group-addon"><select name="scores[<?php echo $score_row; ?>][stock_status][<?php echo $stock_status_row; ?>][stock_status_id]" class="form-control">
																					<?php foreach ($stock_statuses as $stock_status) { ?>
																						<option <?php echo $stock_status['stock_status_id'] == $stocks['stock_status_id'] ? 'selected' : ''; ?> value="<?php echo $stock_status['stock_status_id']; ?>" ><?php echo $stock_status['name']; ?></option>
																					<?php } ?>
																				</select></span>

																				<div class="input-group">
																					<input type="text" name="scores[<?php echo $score_row; ?>][stock_status][<?php echo $stock_status_row; ?>][quantity]" value="<?php echo $stocks['quantity']; ?>" class="form-control">
																					<span class="input-group-btn">
																						<button type="button" class="btn btn-danger" data-toggle="tooltip" title="Удалить статус" onclick="$(this).tooltip('hide');$('#stock<?php echo $stock_status_row; ?>').remove()"><i class="fa fa-minus fa-lg"></i></button>
																					</span>
																				</div>

																			</div>
																			<?php $stock_status_row++; ?>
																		<?php } ?>
																	<?php } ?>
																	<div style="margin-left:30%;"><br>
																		{number} - Любое положительное число <br>
																		{all} - Для всех позиций
																	</div>
																	<div class="pull-right">
																		<button type="button" onclick="$(this).tooltip('destroy');add_stockStatus(<?php echo $score_row; ?>);" data-toggle="tooltip" title="Добавить статус на складе" class="btn btn-primary btn-sm"><i class="fa fa-plus-circle"></i></button>
																	</div>
																</div>

															</td>
														</tr>

														<?php $score_row++; ?>
													<?php } ?>
												<?php } ?>
											</tbody>

											<tfoot>
												<td colspan="3"></td>
												<td class="text-center" colspan="2"><button type="button" onclick="$(this).tooltip('destroy'); addScore();" data-toggle="tooltip" title="<?php echo $button_add_score; ?>" class="btn btn-primary"><i class="fa fa-plus"></i></button></td>
											</tfoot>
										</table>
									</div>
								</div>
							</div>


							<div class="tab-pane active" id="tab-uload">
								<div class="panel panel-default">
									<div class="panel-body">

										<div class="panel panel-heading"><input type="file" name="uload_file"/></div>

										<div class="form-group">
											<label class="col-sm-2 control-label">Поставщик</label>
											<div class="col-sm-4">
												<select name="upload[pc_score_id]" class="form-control">
													<option value="0" > --- Все постащики --- </option>
													<?php foreach ($scores as $score) { ?>
														<option value="<?php echo $score['pc_score_id']; ?>" ><?php echo $score['name']; ?></option>
													<?php } ?>
												</select>
											</div>

											<div class="col-sm-3">
												<div class="input-group">
													<input type="text" id="input-upload-manufacturer" placeholder="Производитель" class="form-control" />
													<span class="input-group-btn">
														<button class="btn btn-danger" type="button" onclick="$('#input-upload-manufacturer').val('');$('input[name=upload\\[manufacturer_id\\]]').val('');"><i class="fa fa-minus"></i></button>
													</span>
												</div>
												<input type="hidden" name="upload[manufacturer_id]" />
											</div>

											<div class="col-sm-3">
												<div id="status_update" class="alert alert-success pull-left"></div>
												<div class="pull-right"><button type="button" id="clear_label" data-toggle="tooltip" title="Очистить статус обновления" class="btn btn-warning"><i class="fa fa-refresh"></i></button></div>
											</div>
										</div>

										<div class="text-center col-sm-6">
											<h4>Значения поставщика</h4>
											<?php foreach ($forValueSettings as $val) {   ?>
												<div class="form-group">
													<label class="col-sm-4 control-label" for="input-contractor-<?php echo $val['name']; ?>"><?php echo $val['entry']; ?></label>
													<div class="text-left col-sm-8"><input <?php echo $val['name'] == 'model' ? '' : 'checked'; ?> type="checkbox" name="upload[contractor][<?php echo $val['name']; ?>]" id="input-contractor-<?php echo $val['name']; ?>" /></div>
												</div>
											<?php } ?>
											<div class="form-group">
												<label class="col-sm-4 control-label" for="input-contractor-extra_charge">Скидка от розницы</label>
												<div class="text-left col-sm-8"><input type="checkbox" name="upload[contractor][extra_charge]" id="input-contractor-extra_charge" /></div>
											</div>
											<div class="form-group">
												<label class="col-sm-4 control-label" for="input-contractor-contractor_no">Отсутствующим "Нет в наличии"</label>
												<div class="text-left col-sm-8"><input type="checkbox" name="upload[contractor][contractor_no]" id="input-contractor-contractor_no" /></div>
											</div>
										</div>

										<div class="text-center col-sm-6">
											<?php
												# Настройки
												$forValueSettingsUploadProduct = [
													['name' => 'model', 'entry' => 'Артикул'],
													//['name' => 'price', 'entry' => $entry_settings_price],
													['name' => 'quantity', 'entry' => $entry_settings_quantity],
													['name' => 'extra_charge', 'entry' => 'Наценка'],
													['name' => 'base_price', 'entry' => 'Базовая цена'],
													['name' => 'base_currency_code', 'entry' => 'Базовая валюта']
												];
											?>

											<h4>Значения товара</h4>

											<div class="form-group">
												<label class="col-sm-4 control-label" for="input-product-status">Обновлять данные в товаре</label>
												<div class="text-left col-sm-8"><input type="checkbox" name="upload[product][status]" id="input-product-status" /></div>
											</div>

											<div id="pars_input_product">
												<?php foreach ($forValueSettingsUploadProduct as $val) {  ?>
													<div class="form-group">
														<label class="col-sm-4 control-label" for="input-product-<?php echo $val['name']; ?>"><?php echo $val['entry']; ?></label>
														<div class="text-left col-sm-8"><input type="checkbox" name="upload[product][<?php echo $val['name']; ?>]" id="input-product-<?php echo $val['name']; ?>" /></div>
													</div>
												<?php } ?>
												<div class="form-group">
													<label class="col-sm-4 control-label" for="input-product-product_no">Отсутствующим "Нет в наличии"</label>
													<div class="text-left col-sm-8"><input type="checkbox" name="upload[product][product_no]" id="input-product-product_no" /></div>
												</div>
											</div>
										</div>

									</div>
									<div class="panel-footer text-right">
										<button type="button" onclick="$(this).tooltip('destroy'); updateMinPrice();" data-toggle="tooltip" title="Проставить минимальные цены" class="btn btn-primary" style="float:left;">Минимальные цены</button>
										<button type="button" onclick="$(this).tooltip('destroy'); parsingFile();" data-toggle="tooltip" title="<?php echo $entry_download; ?>" class="btn btn-success"><?php echo $entry_parsing; ?></button>
									</div>
								</div>
							</div>

							<div class="tab-pane" id="tab-contractor">
								<div class="panel panel-default">
									<div class="panel-body">
										<div class="form-group">
											<label class="col-sm-2 control-label"><?php echo $entry_score; ?></label>
											<div class="col-sm-5">
												<select id="contractor_download" class="form-control">
													<option value="0" > --- Все постащики --- </option>
													<?php foreach ($scores as $score) { ?>
														<option value="<?php echo $score['pc_score_id']; ?>" ><?php echo $score['name']; ?></option>
													<?php } ?>
												</select>
											</div>

											<div class="col-sm-3">
												<div class="input-group">
													<input type="text" id="input-contractor-manufacturer" placeholder="Производитель" class="form-control" />
													<span class="input-group-btn">
														<button class="btn btn-danger" type="button" onclick="$('#input-contractor-manufacturer').val('');$('#contractor_manufacturer_id').val('');"><i class="fa fa-minus"></i></button>
													</span>
												</div>
												<input type="hidden" id="contractor_manufacturer_id" />
											</div>

											<div class="col-sm-1">
												<button type="button" onclick="$(this).tooltip('destroy'); contractorDownload();" data-toggle="tooltip" title="<?php echo $entry_contractor; ?>" class="btn btn-success"><i class="fa fa-download pars_downl"></i></button>
											</div>
										</div>
									</div>

									<div class="panel-body" style="padding-top:0px;">
										<div style="text-align:end;">
											Гривня <input type="number" id="currency_uah" min="0" value="" />
											<input type="number" disabled id="currency_result" value="" />
											Курс <input type="number" id="currency_well" min="0" value="" />
											Скидка <input type="number" id="currency_procent" value="" />
										</div>

									</div>

									<div class="panel-body parsing-value">
											<table class="table table-hover table-condensed">
												<thead>
													<tr>
														<th width="1" style="text-align: center;"><input type="checkbox" onclick="$('input[name*=\'contractor_selected\']').prop('checked', this.checked);" /></th>
														<th class="text-center" style="width:20px">№</th>
														<th class="text-left"><?php echo $entry_model; ?></th>
														<th class="text-left"><?php echo $column_name; ?></th>
														<th class="text-left"><?php echo $entry_price; ?></th>
														<th class="text-left"><?php echo $entry_stock; ?></th>
														<th class="text-left">Нац.</th>
														<th class="text-center"><?php echo $entry_date; ?></th>
														<th class="text-center">Отметка</th>
													</tr>
													<tr class="update_all">
														<th colspan="9">
															<select id="update_all_name" class="form-control">
																<option value="0" > --- </option>
																<option data-type="contractor" value="stock_status_id">[Пост.] <?php echo $entry_stock; ?></option>
																<option data-type="contractor" value="extra_charge">[Пост.] Наценка</option>
																<option data-type="contractor" value="label">[Пост.] Отметка</option>
																<option value="0" > ------- </option>
																<option data-type="product" value="stock_status_id">[Товар] <?php echo $entry_stock; ?></option>
																<option data-type="product" value="extra_charge">[Товар] Наценка</option>
																<option data-type="product" value="base_currency_code">[Товар] Валюта</option>
															</select>
															<input id="update_all_val" type="number" class="form-control" />
															<button type="button" class="btn btn-primary" onclick="updateAll();">Обновить</button>
														</th>
													</tr>
												</thead>
												<tbody id="contractor_value"></tbody>
											</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
  	</div>
</div>

<script>

	var score_row = <?php echo $score_row; ?>;
	var stock_status_row = <?php echo $stock_status_row; ?>;
	var manufacturers = <?php echo $manufacturers; ?>;
	var popid = 0;
	var stock_statuses_edit = [];
	var stock_statuses = '';

	<?php foreach ($stock_statuses as $stock_status) { ?>
		//stock_statuses_edit[i] = {'value':'<?php echo $stock_status['stock_status_id']; ?>', 'text':'<?php echo $stock_status['name']; ?>'} ;
		stock_statuses_edit.push ({'value':'<?php echo $stock_status['stock_status_id']; ?>', 'text':'<?php echo $stock_status['name']; ?>'}) ;
		stock_statuses += '<option value="<?php echo $stock_status['stock_status_id']; ?>" ><?php echo $stock_status['name']; ?></option>';
	<?php } ?>

	function addScore () {
		entry_scores = '<?php echo $entry_scores; ?>';
		type = 'scores';

		html  = '<tr id="score' + score_row + '">';
		html += '  <td></td>'
		html += '  <td class="text-center">';
		html += '  <input type="text" name="scores[' + score_row + '][name]" value="" placeholder="<?php echo $text_name; ?> ' + entry_scores + '" class="form-control" /></td>';
		html += '  <td class="text-center">';
		html += '  <input type="text" name="scores[' + score_row + '][url]" value="" placeholder="<?php echo $text_url; ?>" class="form-control" />';
		html += '  </td>';
		html += '  <td class="text-center"><button type="button" onclick="$(this).tooltip(\'destroy\');score_remove(' + score_row + ');" data-toggle="tooltip" title="<?php echo $button_remove; ?> ' + entry_scores + '" class="btn btn-danger btn-sm"><i class="fa fa-minus-circle"></i></button></td></tr>';

		$('#tab-scores tbody').append(html);
		$('[data-toggle="tooltip"]').tooltip();
		score_row++;
	}

	function settings_display (row) {
		hidden = $('#score' + '_settings'+row).is(':hidden');

		$('.settings-button .fa-plus').show();
		$('.settings-button .fa-minus').hide();
		$('[id ^= score_settings]').slideUp(0);

		if (hidden) {
			$('#score' + row + ' .settings-button .fa-plus').hide();
			$('#score' + row + ' .settings-button .fa-minus').show();
			$('#score_settings'+row).slideDown(0);
		}

		/*if (hidden) {
			$('#score' + row + ' .settings-button .fa-plus').hide();
			$('#score' + row + ' .settings-button .fa-minus').show();
		} else {
			$('#score' + row + ' .settings-button .fa-plus').show();
			$('#score' + row + ' .settings-button .fa-minus').hide();
		}
		$('#score_settings'+row).slideToggle(0);*/
	}

	function score_remove(row) {
		$('#score' + row).remove();
		$('#score' + '_settings' + row).remove();
	}

	function add_stockStatus(row) {

		html  = '<div class="input-group select-group" id="stock'+stock_status_row+'">';
		html += '	<span class="input-group-addon">';
		html += '		<select name="scores['+row+'][stock_status]['+stock_status_row+'][stock_status_id]" class="form-control">';
		html += stock_statuses;
		html += '		</select>';
		html += '	</span>';
		html += '	<div class="input-group">';
		html += '		<input type="text" name="scores['+row+'][stock_status]['+stock_status_row+'][quantity]" class="form-control">';
		html += '		<span class="input-group-btn">';
		html += '					<button type="button" class="btn btn-danger" data-toggle="tooltip" title="Удалить статус" onclick="$(this).tooltip(\'hide\');$(\'#stock'+stock_status_row+'\').remove()"><i class="fa fa-minus fa-lg"></i></button>';
		html += '		</span>';
		html += '	</div>';
		html += '</div>';

		$('#score_settings'+row+' .panel-body.stock .pull-right').prev().before(html);

		$('.select-group [data-toggle="tooltip"]').tooltip();
		stock_status_row++;
	}

	function scoreChange() {
		$.ajax({
			type: 'POST',
			url: 'index.php?route=extension/module/price_control/totalContractor&user_token='+getURLVar('user_token')+'&pc_score_id='+$('[name=upload\\[pc_score_id\\]]').val(),
			dataType: 'json',
			success: function(json) {
				html = 'Обновлено <label>' + json.total_update + '</label> из <label>' + json.total  + '</label>';
				$('#status_update').fadeOut().html(html).fadeIn();
			}
		});
	}

	function parsingFile() {
		$.ajax({
			type: 'POST',
			url: 'index.php?route=extension/module/price_control/parsingFile&user_token='+getURLVar('user_token'),
			data: new FormData($('#form-priceControl')[0]),
			beforeSend: function() {$('form').css({'opacity':0.3, 'pointer-events':'none'})},
			processData: false,
			contentType: false,
			dataType: 'json',
			complete: function() {$('form').css({'opacity':1, 'pointer-events':'unset'})},
			success: function(json) {
				if (json['error']) {
					popup(json['error'], 'danger');
				}

				if (json['success']) {
					popup(json['success'], 'success');
					$('[name=uload_file]').val('');
					scoreChange();
				}
			}
		});
	}

	function updateMinPrice() {

		if (!$('[name=upload\\[manufacturer_id\\]]').val()) {
			if(!confirm('Не указан производитель! Желаете обновить все товары?')) return false;
		}

		$.ajax({
			type: 'POST',
			url: 'index.php?route=extension/module/price_control/updateMinPrice&user_token='+getURLVar('user_token'),
			data: new FormData($('#form-priceControl')[0]),
			beforeSend: function() {$('form').css({'opacity':0.3, 'pointer-events':'none'})},
			processData: false,
			contentType: false,
			dataType: 'json',
			complete: function() {$('form').css({'opacity':1, 'pointer-events':'unset'})},
			success: function(json) {
				if (json['error']) {
					popup(json['error'], 'danger');
				}

				if (json['success']) {
					popup(json['success'], 'success');
				}
			}
		});
	}

	function popup (text, popClass) {
		html  = '<div class="alert alert-' + popClass + ' alert-dismissable" id="popup' + popid + '">';
		html += '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>';
		html += text;
		html += '</div>';
		$('#popup_content').append(html);
		$('#popup'+popid).fadeIn('slow').delay(3000).fadeOut('slow');
		popid++;
	}

	function contractorDownload() {
		$('#contractor_value').html('');

		user_token = getURLVar('user_token');

		$.ajax({
			type: 'GET',
			url: 'index.php?route=extension/module/price_control/contractorDownload&user_token='+user_token+'&pc_score_id='+$('#contractor_download').val()+'&manufacturer_id='+$('#contractor_manufacturer_id').val(),
			beforeSend: function() {$('form').css({'opacity':0.3, 'pointer-events':'none'})},
			dataType: 'json',
			complete: function() {$('form').css({'opacity':1, 'pointer-events':'unset'})},
			success: function(json) {
				if (json.contractor) {

					num = 1;
					$.each(json.contractor, function (i, val) {

						if (!(num & 1)) tabl_class = 'class = "warning"';
						else tabl_class = '';

						html  = '<tr ' + tabl_class + ' style="border-top:groove;">';

							html += '<td rowspan="2" style="vertical-align:middle;"><input type="checkbox" tabindex="' + num + '" name="contractor_selected[]" value="' + val.price_control_id + '" data-product_id=' + val.product_id + '></td>';

							html += '<td rowspan="2" style="vertical-align:middle;">' + num + '</td>';

							html += '<td class="text-left">';
							html += '<button type="button" class="btn btn-link btn-sm control-name-copy" ><i class="fa fa-clone fa-sm"></i></button></div>';
							html += '<a href="javascript:" class="contractor_edit" data-name="model" data-pk="' + val.price_control_id + '" data-url="index.php?route=extension/module/price_control/editContractor&user_token=' + user_token + '" data-type="text" data-placement="right" data-title="<?php echo $entry_model; ?>" style="background:lightcyan;">' + val.model + '</a>';
							html += '</br><span style="padding-left: 34px;">' + val.contractor_name + '</span>';
							html += '</td>';

							html += '<td class="text-left">';
							html += '<button type="button" class="btn btn-link btn-sm control-name-copy" ><i class="fa fa-clone fa-sm"></i></button>';
							html += '<a href="javascript:" class="contractor_edit" data-name="name" data-pk="' + val.price_control_id + '" data-url="index.php?route=extension/module/price_control/editContractor&user_token=' + user_token + '" data-type="text" data-placement="right" data-title="<?php echo $column_name; ?>">' + val.name + '</a>';
							html += '</td>';

							html += '<td class="text-left">';
							html += '<a href="javascript:" class="contractor_edit" data-name="price" data-pk="' + val.price_control_id + '" data-url="index.php?route=extension/module/price_control/editContractor&user_token=' + user_token + '" data-type="text" data-placement="right" data-title="<?php echo $entry_price; ?>">' + val.price + '</a>';
							html += '</td>';

							html += '<td class="text-left">';
							html += '<a href="javascript:" class="contractor_stock_edit" data-name="stock_status_id" data-pk="' + val.price_control_id + '" data-url="index.php?route=extension/module/price_control/editContractor&user_token=' + user_token + '" data-type="select" data-placement="left" data-title="<?php echo $entry_stock; ?>">' + json['stock_status'][val.stock_status_id] + '</a>';
							html += '</td>';

							html += '<td class="text-left">';
							html += '<a href="javascript:" class="contractor_edit" data-name="extra_charge" data-pk="' + val.price_control_id + '" data-url="index.php?route=extension/module/price_control/editContractor&user_token=' + user_token + '" data-type="text" data-placement="left" data-title="Отметка">' + val.extra_charge + '</a>';
							html += '</td>';

							html += '<td class="text-center">' + val.date + '</td>';

							html += '<td class="text-center">';
							//html += '<a href="javascript:" class="contractor_edit" data-name="label" data-pk="' + val.price_control_id + '" data-url="index.php?route=extension/module/price_control/editContractor&user_token=' + user_token + '" data-type="text" data-placement="left" data-title="Отметка">' + val.label + '</a>';
							html += '<a href="javascript:" class="contractor_label_edit" data-name="label" data-pk="' + val.price_control_id + '" data-url="index.php?route=extension/module/price_control/editContractor&user_token=' + user_token + '" data-type="checklist" data-placement="left" data-title="Отметка">' + val.label + '</a>';
							html += '</td>';

						html += '</tr>';

						html += '<tr ' + tabl_class + ' style="border-bottom:groove;">';
							html += '<td class="text-left">';
							html += '<button type="button" class="btn btn-link btn-sm control-name-copy" ><i class="fa fa-clone fa-sm"></i></button></div>';
							html += '<a href="javascript:" class="contractor_edit" data-name="model" data-pk="' + val.product_id + '" data-url="index.php?route=extension/module/price_control/editProduct&user_token=' + user_token + '" data-type="text" data-placement="right" data-title="Артикул">' + val.product_model + '</a>';
							html += '</br><span style="padding-left: 34px;">' + manufacturers[val.product_manufacturer_id] + '</span>';
							html += '</td>';

							html += '<td class="text-left">';
							html += '<div style="padding-left:34px;">' + val.product_name + '</div>';
							html += '</td>';

							html += '<td class="text-left">';
							html += 'Тов.: <a href="javascript:" class="contractor_edit" data-name="price" data-pk="' + val.product_id + '" data-url="index.php?route=extension/module/price_control/editProduct&user_token=' + user_token + '" data-type="text" data-placement="right" data-title="Цена товара">' + val.product_price + '</a>';

							html += '</br>Баз.: <a href="javascript:" class="contractor_edit" data-name="base_price" data-pk="' + val.product_id + '" data-url="index.php?route=extension/module/price_control/editProduct&user_token=' + user_token + '" data-type="text" data-placement="right" data-title="Базовая цена">' + val.product_base_price + '</a>';
							html += '</td>';

							html += '<td class="text-left">';
							html += '<a href="javascript:" class="contractor_stock_edit" data-name="stock_status_id" data-pk="' + val.product_id + '" data-url="index.php?route=extension/module/price_control/editProduct&user_token=' + user_token + '" data-type="select" data-placement="left" data-title="<?php echo $entry_stock; ?>">' + json['stock_status'][val.product_stock_status_id] + '</a>';
							html += '</td>';

							html += '<td>';
							html += '<a href="javascript:" class="contractor_edit" data-name="extra_charge" data-pk="' + val.product_id + '" data-url="index.php?route=extension/module/price_control/editProduct&user_token=' + user_token + '" data-type="text" data-placement="left" data-title="Наценка в процентах">' + val.product_extra_charge + '</a>';
							html += '</td>';

							html += '<td colspan="2">';
							html += 'Вал.: <a href="javascript:" class="contractor_edit" data-name="base_currency_code" data-pk="' + val.product_id + '" data-url="index.php?route=extension/module/price_control/editProduct&user_token=' + user_token + '" data-type="text" data-placement="left" data-title="Базовая валюта">' + val.product_base_currency_code + '</a>';
							html += '</td>';
						html += '</tr>';
						num++;
						$('#contractor_value').append(html);
					});
				}

				$('.contractor_edit').editable();

				$('.contractor_stock_edit').editable({
					source: stock_statuses_edit
				});

				$('.contractor_label_edit').editable({
					source: [
						{value: 1, text: 'On'},
						{value: 0, text: 'Off'}
					]
				});

				$('#tab-contractor thead th input[type=checkbox], input[name*=\'contractor_selected\']').on('change', function () {
					if ($('input[name*=\'contractor_selected\']:checked').length) {
						$('tr.update_all').slideDown();
					} else {
						$('tr.update_all').slideUp();
					}
				});

				$('.control-name-copy').on('click', function() {
					if (event.target.tagName != 'A' && !window.getSelection().toString()) {
						var $tmp = $("<textarea>");
						$("body").append($tmp);

						if ($(this).prev('a')['length']) $tmp.val($(this).prev('a').text()).select();
						else $tmp.val($(this).next('a').text()).select();

						if ($tmp.val() != 'Empty') {
							document.execCommand("copy");
						} else {
							$tmp.val(' ').select();
							document.execCommand("copy");
						}
						$tmp.remove();
					}
				});
			}
		});
	}

	function update_currency(type) {
		$.ajax({
			//url: 'index.php?route=localisation/currency/updatecurrency&type='+type+'&user_token='+getURLVar('user_token'),
			url: '<?php echo $web_catalog; ?>index.php?route=wgi/currency_plus&type='+type,
			dataType: 'json',
			beforeSend: function() {$('#update_currency_id').attr('disabled', true);},
			complete: function() {$('#update_currency_id').attr('disabled', false);popup('Цены успешно обновленны!', 'success');},
			success: function(json) {

			}
		});
	}

	function updateAll() {

		name = $('#update_all_name').val();
		val = $('#update_all_val').val();
		type = $('#update_all_name option:selected').data('type');

		if (!$('input[name*=\'contractor_selected\']:checked').length || !val || name == 0) {
			popup('Укажите все данные!', 'danger');
			return false;
		}

		if (type == 'product') {
			url = 'index.php?route=extension/module/price_control/editProduct&user_token=' + user_token;
		} else {
			url = 'index.php?route=extension/module/price_control/editContractor&user_token=' + user_token;
		}

		$('input[name*=\'contractor_selected\']:checked').each(function() {

			if (type == 'product') {
				pk = $(this).data('product_id');
			} else {
				pk = this.value;
			}

			$.ajax({
				url: url,
				type:'POST',
				data: {
					name: name,
					value: val,
					pk: pk
				},
				async : false,
				success: function(response) {
					$('a[data-name=' + name + '][data-pk=' + pk + '][data-url=\'' + url + '\']').text(val);
				}
			});
		});
		popup('Данные успешно обновленны!', 'success');
	}

	$(document).ready(function() {

		$('[name=upload\\[pc_score_id\\]]').on('change', function () {
			scoreChange();
		});

		$('.savescore').on('click', function (){
			$.ajax({
				url: 'index.php?route=extension/module/price_control/addScore&user_token='+getURLVar('user_token'),
				type:'POST',
				dataType: 'html',
				data: $('#form-priceControl').serialize(),
				before: $('.alert-dismissable').remove(),
				success: function(response) {
					popup('Данные успешно обновленны!', 'success');
				}
			});
		});

		$('#clear_label').on('click', function () {
			$.ajax({
				type: 'POST',
				url: 'index.php?route=extension/module/price_control/editContractor&user_token='+getURLVar('user_token')+'&pc_score_id='+$('[name=upload\\[pc_score_id\\]]').val(),
				data: {
					name: 'label',
					value:	0
				},
				success: function() {
					scoreChange();
				}
			});
		});

		$('#input-product-status').on('click', function () {
			if ($(this).prop('checked')) {
				$('[name ^= upload\\[product\\]]').prop('checked', true);
				$('#pars_input_product').fadeIn();
			} else {
				$('[name ^= upload\\[product\\]]').prop('checked', false);
				$('#pars_input_product').fadeOut();
			}
		});

		$('#update_all_name').on('change', function () {
			if ($('#update_all_name option:selected').val() == 'base_currency_code') {
				$('#update_all_val').attr('type','text');
			} else {
				$('#update_all_val').attr('type','number');
			}
		});

		$('#currency_uah').on('change', function () {
			price = $('#currency_uah').val()/$('#currency_well').val();
			$('#currency_result').val(price+(price*$('#currency_procent').val()/100));
		});

			// Manufacturer
		$('#input-upload-manufacturer').autocomplete({
			'source': function(request, response) {
				$.ajax({
					url: 'index.php?route=catalog/manufacturer/autocomplete&user_token='+getURLVar('user_token')+'&filter_name=' +  encodeURIComponent(request),
					dataType: 'json',
					success: function(json) {
						response($.map(json, function(item) {
							return {
								label: item['name'],
								value: item['manufacturer_id']
							}
						}));
					}
				});
			},
			'select': function(item) {
				$('#input-upload-manufacturer').val(item['label']);
				$('input[name=upload\\[manufacturer_id\\]]').val(item['value']);
			}
		});
		$('#input-contractor-manufacturer').autocomplete({
			'source': function(request, response) {
				$.ajax({
					url: 'index.php?route=catalog/manufacturer/autocomplete&user_token='+getURLVar('user_token')+'&filter_name=' +  encodeURIComponent(request),
					dataType: 'json',
					success: function(json) {
						response($.map(json, function(item) {
							return {
								label: item['name'],
								value: item['manufacturer_id']
							}
						}));
					}
				});
			},
			'select': function(item) {
				$('#input-contractor-manufacturer').val(item['label']);
				$('#contractor_manufacturer_id').val(item['value']);
			}
		});

		$('[data-toggle="tooltip"]').tooltip();

		scoreChange();
	});
</script>
<?php echo $footer; ?>