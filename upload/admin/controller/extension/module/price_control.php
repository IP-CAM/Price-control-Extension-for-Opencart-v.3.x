<?php

class ControllerExtensionModulePriceControl extends Controller {
	private $error = array();
	private $contractorStock_status = array();
	private $contractorMarkup = array();

	public function index() {

		$language = $this->language->load('extension/module/price_control');

		foreach ($language as $key => $lang) {
			$data[$key] = $lang;
		}

		$this->document->setTitle($this->language->get('heading_title'));
		$this->document->addStyle('view/price_control/javascript/bootstrap3-editable/css/bootstrap-editable.css');
		$this->document->addScript('view/price_control/javascript/bootstrap3-editable/js/bootstrap-editable.min.js');
		$this->document->addStyle('view/price_control/stylesheet/price_control.css');

		$this->load->model('setting/setting');

		if ($this->request->server['REQUEST_METHOD'] == 'POST' && $this->validate()) {
			if ($this->config->get('module_price_control_status')) {
				$this->model_setting_setting->editSettingValue('module_price_control', 'module_price_control_status', $this->request->post['module_price_control_status']);
				$this->model_setting_setting->editSettingValue('module_price_control', 'module_price_control', $this->request->post['module_price_control']);
			} else {
				$this->model_setting_setting->editSetting('module_price_control', $this->request->post);
			}

			$this->addScore();

			$this->session->data['success'] = $this->language->get('text_success');

			if (isset($this->request->post['type_save'])) {
				$this->response->redirect($this->url->link('extension/module/price_control', 'user_token=' . $this->session->data['user_token'], true));
			} else {
				$this->response->redirect($this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module', true));
			}
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->error['name'])) {
			$data['error_name'] = $this->error['name'];
		} else {
			$data['error_name'] = array();
		}

		$data['breadcrumbs'] = array();

   		$data['breadcrumbs'][] = array(
       		'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
   		);

   		$data['breadcrumbs'][] = array(
       		'text' => $this->language->get('text_extension'),
			'href' => $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module', true)
   		);

   		$data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href' => $this->url->link('extension/module/price_control', 'user_token=' . $this->session->data['user_token'], true)
   		);

		$data['action'] = $this->url->link('extension/module/price_control', 'user_token=' . $this->session->data['user_token'], true);

		$data['cancel'] = $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module', true);

		if (isset($this->request->post['module_price_control_status'])) {
			$data['module_price_control_status'] = $this->request->post['module_price_control_status'];
		} elseif ($this->config->get('module_price_control_status')) {
			$data['module_price_control_status'] = $this->config->get('module_price_control_status');
		}

		if (isset($this->request->post['module_price_control'])) {
			$data['module_price_control'] = $this->request->post['module_price_control'];
		} elseif ($this->config->get('module_price_control')) {
			$data['module_price_control'] = $this->config->get('module_price_control');
		}

		$this->load->model('extension/module/price_control');

		$data['scores'] = $this->model_extension_module_price_control->getScores();

		$this->load->model('localisation/currency');
		$data['currencys'] = $this->model_localisation_currency->getCurrencies();

		$this->load->model('localisation/stock_status');
		$data['stock_statuses'] = $this->model_localisation_stock_status->getStockStatuses();

		$this->load->model('catalog/manufacturer');
		$manufacturers = $this->model_catalog_manufacturer->getManufacturers();
		foreach ($manufacturers as $manufacturer) {
			$manufactur[$manufacturer['manufacturer_id']] = $manufacturer['name'];
		}
		$data['manufacturers'] = json_encode($manufactur);

		$data['web_catalog'] = HTTPS_CATALOG;

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->config->set('template_engine', 'template');
		$this->response->setOutput($this->load->view('extension/module/price_control', $data));
	}

	public function addScore() {
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {

			$this->load->model('extension/module/price_control');

			if (isset($this->request->post['scores'])) {
				$this->model_extension_module_price_control->addScore($this->request->post['scores']);
			} else {
				$this->model_extension_module_price_control->deleteScore();
			}
		}
	}

		### Работа с товаром ###
	public function productScore() {
		$this->load->model('localisation/stock_status');
		$json['stock_statuses'] = $this->model_localisation_stock_status->getStockStatuses();

		$this->load->model('extension/module/price_control');
		$json['scores'] = $this->model_extension_module_price_control->getScores();

		$this->load->model('extension/module/price_control');
		$json['product_score'] = $this->model_extension_module_price_control->getProductScore($this->request->get['product_id']);

		$this->response->setOutput(json_encode($json));
	}

	public function productListScore() {
		if (isset($this->request->post['product_id'])) {
			$this->load->model('localisation/stock_status');
			$stock_statuses = $this->model_localisation_stock_status->getStockStatuses();

			foreach ($stock_statuses as $stock_status) {
				$json['stock_statuses'][$stock_status['stock_status_id']] = $stock_status['name'];
			}

			$this->load->model('extension/module/price_control');

			$product_scores = $this->model_extension_module_price_control->getProductListScore($this->request->post['product_id']);

			if ($product_scores) {
				foreach ($product_scores as $product_score) {
					$score_price = $product_score['price'] + ($product_score['price']/100*$product_score['extra_charge']);
					$price = $score_price/$product_score['currency_value'];

					$json['product_scores'][] = array (
						'price_control_id' => $product_score['price_control_id'],
						'pc_score_id' => $product_score['pc_score_id'],
						'product_id' => $product_score['product_id'],
						'model' => $product_score['model'],
						'product_name' => $product_score['product_name'],
						'score_price' => round($product_score['price']),
						'price_purchase' => round($score_price),
						'price_uah' => round($price),
						'stock_status_id' => $product_score['stock_status_id'],
						'score_name' => $product_score['score_name'],
						'score_url' => $product_score['score_url'],
						'currency_code' => $product_score['currency_code']
					);

				}
				$json['product_scores'] = $this->multiSort($json['product_scores'], 'stock_status_id', 'price_uah');

				$this->response->setOutput(json_encode($json));
			}
		}
	}

	private function multiSort() {
		//get args of the function
		$args = func_get_args();
		$c = count($args);
		if ($c < 2) {
			return false;
		}
		//get the array to sort
		$array = array_splice($args, 0, 1);
		$array = $array[0];
		//sort with an anoymous function using args
		usort($array, function($a, $b) use($args) {

			$i = 0;
			$c = count($args);
			$cmp = 0;
			while($cmp == 0 && $i < $c)
			{
				$cmp = strcmp($a[ $args[ $i ] ], $b[ $args[ $i ] ]);
				$i++;
			}

			return $cmp;

		});
		return $array;
	}

	public function totalContractor() {
		if($this->request->server['REQUEST_METHOD'] == 'POST' && isset($this->request->get['pc_score_id'])) {
			$this->load->model('extension/module/price_control');
			$this->response->setOutput(json_encode($this->model_extension_module_price_control->getTotalContractorByPcSoreId($this->request->get['pc_score_id'])));
		}
	}

	public function editContractor() {
		if($this->request->server['REQUEST_METHOD'] == 'POST') {

			$this->load->model('extension/module/price_control');

			$price_control_id = $pc_score_id = 0;

			if (isset($this->request->post['pk'])) {
				$price_control_id = $this->request->post['pk'];
			}

			if ($this->request->post['name'] == 'label') {
				$this->request->post['value'] = $this->request->post['value'][0];
			}

			if (isset($this->request->get['pc_score_id'])) {
				$pc_score_id = $this->request->get['pc_score_id'];
			}

			$this->model_extension_module_price_control->editContractor($price_control_id, $pc_score_id, 0, $this->request->post);
		}
	}

	public function editProduct() {
		if($this->request->server['REQUEST_METHOD'] == 'POST') {
			$this->load->model('extension/module/price_control');

			$data = $this->request->post;

			if($data['name'] == 'stock_status_id') {
				if($data['value'] == 1) {
					$data['quantity'] = 1;
				} else {
					$data['quantity'] = 0;
				}
			}

			$this->model_extension_module_price_control->editProduct($this->request->post['pk'], 0, 0, $data);
		}
	}

	public function contractorDownload() {
		if($this->request->server['REQUEST_METHOD'] == 'GET') {

			$this->load->model('localisation/stock_status');
			$stock_statuses = $this->model_localisation_stock_status->getStockStatuses();
			foreach ($stock_statuses as $stock_status) {
				$json['stock_status'][$stock_status['stock_status_id']] = $stock_status['name'];
			}

			if (isset($this->request->get['pc_score_id'])) $pc_score_id = $this->request->get['pc_score_id'];
			else $pc_score_id = 0;

			if (isset($this->request->get['manufacturer_id'])) $manufacturer_id = $this->request->get['manufacturer_id'];
			else $manufacturer_id = 0;

			$this->load->model('extension/module/price_control');
			$json['contractor'] = $this->model_extension_module_price_control->getContractorProduct($pc_score_id, $manufacturer_id);

			$this->response->setOutput(json_encode($json));
		}
	}

	public function updateMinPrice () {
		if($this->request->server['REQUEST_METHOD'] == 'POST') {
			$manufacturer_id = $this->request->post['upload']['manufacturer_id'];

			$this->load->model('extension/module/price_control');
			$contractor_product = $this->model_extension_module_price_control->getContractorMinPrice($manufacturer_id);

			foreach ($contractor_product as $value) {
				$markup = json_decode($value['markup'], true);
				$extra_charge = 0;
				if ($value['extra_charge']) {
					if ($markup['extra_charge_rozn']) {
						$this->contractorMarkup = explode(';', trim(str_replace(' ','',str_replace(',','.',$markup['extra_charge_rozn']))));
						$extra_charge = $this->parsMarkup($value['price']);
					} elseif ($markup['extra_charge']) {
						$this->contractorMarkup = explode(';', trim(str_replace(' ','',str_replace(',','.',$markup['extra_charge']))));
						$value['price'] = $value['price'] + ($value['price']*$value['extra_charge']/100);
						$extra_charge = $this->parsMarkup($value['price']);
					}
				} elseif ($markup['extra_charge']) {
					$this->contractorMarkup = explode(';', trim(str_replace(' ','',str_replace(',','.',$markup['extra_charge']))));
					$extra_charge = $this->parsMarkup($value['price']);
				}

				$data[] = array (
					'product_id' 			=> $value['product_id'],
					'extra_charge' 			=> $extra_charge,
					'base_price' 			=> $value['price'],
					'base_currency_code' 	=> $value['code'],
					'quantity' 				=> $value['stock_status_id'] == 1 ? 1 : 0,
					'stock_status_id' 		=> $value['stock_status_id']
				);
			}

			$this->model_extension_module_price_control->editProductMinPrice($data);

			$json['success'] = 'Цены товаров обновлены!';

			$this->response->setOutput(json_encode($json));
		}
	}


		### ПАРСИНГ ###
	public function parsingFile () {
		if($this->request->server['REQUEST_METHOD'] == 'POST' && $_FILES['uload_file']['name']) {

			do {
				$settings = $this->request->post['upload'];

					//Получаем данные поставщика
				$this->load->model('extension/module/price_control');
				if ($settings['pc_score_id']) {
					$contractor = $this->model_extension_module_price_control->getScores(array('pc_score_id' => $settings['pc_score_id']));
				} else {
					$json['error'] = 'Укажите поставщика!';
					break;
				}

				$contractor = $contractor[0];

				$this->contractorStock_status = $contractor['stock_status'];
				if($contractor['markup']['extra_charge']) $this->contractorMarkup = explode(';', trim(str_replace(' ','',str_replace(',','.',$contractor['markup']['extra_charge']))));

				$this->load->model('localisation/currency');
				$currency = $this->model_localisation_currency->getCurrency($contractor['currency_id']);

				$xls_column = $contractor['pc_column'];

				if ($xls_column['basic_col'] == 'model' && !is_numeric($xls_column['model'])) {
					$json['error'] = 'Не указана колонка для идентификатора!';
					break;
				} elseif ($xls_column['basic_col'] == 'name' && !is_numeric($xls_column['name'])) {
					$json['error'] = 'Не указана колонка для названия!';
					break;
				} elseif ($xls_column['basic_col'] != 'model' && $xls_column['basic_col'] != 'name') {
					$json['error'] = 'Неверно указан Главный идентификатор!';
					break;
				}

				if (isset($settings['product']['status']) && !isset($settings['product']['model']) && !isset($settings['product']['quantity']) && !isset($settings['product']['extra_charge']) && !isset($settings['product']['base_price']) && !isset($settings['product']['base_currency_code'])) unset($settings['product']['status']);

				require_once DIR_SYSTEM . 'SimpleXLS/SimpleXLSX.php';

				if ( $xlsx = SimpleXLSX::parse($_FILES['uload_file']['tmp_name']) ) {

					$settings['contractor']['manufacturer_id'] = $settings['product']['manufacturer_id'] = $settings['manufacturer_id'];

					$xls = $xlsx->rows();

					foreach ( $xls as $score_products ) {

						$score_product = array('model'=>'', 'name'=>'', 'price'=>'', 'stock_status_id'=>'', 'extra_charge'=>$contractor['markup']['skidka']);

						//if (is_numeric($xls_column['model'])) $score_product['model'] = trim($score_products[$xls_column['model']]);
						if (is_numeric($xls_column['model'])) $score_product['model'] = str_replace("\n",  " ", trim($score_products[$xls_column['model']]));
						//if (is_numeric($xls_column['name'])) $score_product['name'] = trim($score_products[$xls_column['name']]);
						if (is_numeric($xls_column['name'])) $score_product['name'] = str_replace("\n",  " ", trim($score_products[$xls_column['name']]));
						if (is_numeric($xls_column['price'])) $score_product['price'] = (float)trim(str_replace(' ', '', str_replace(',','.',$score_products[$xls_column['price']])));
						if (is_numeric($xls_column['quantity'])) $score_product['stock_status_id'] = $this->parsStockStatus(trim($score_products[$xls_column['quantity']]));

						if ($score_product[$xls_column['basic_col']]) {
							$update_product_id = $this->model_extension_module_price_control->parsEditContractor($settings['pc_score_id'], $settings['contractor'], $xls_column['basic_col'], $score_product);

							if (isset($settings['product']['status']) && $update_product_id) {
								$score_product['extra_charge'] = $this->parsMarkup($score_product['price']);
								$score_product['base_currency_code'] = $currency['code'];
								$this->model_extension_module_price_control->parsEditProduct($update_product_id, $settings['product'], $score_product);
							}

						}
					}

					if(isset($settings['contractor']['contractor_no'])) $this->model_extension_module_price_control->editContractor(0, $settings['pc_score_id'], $settings['contractor'], array('name'=>'stock_status_id', 'value'=>99, 'and_name'=>'label', 'and_value'=>0));

					if(isset($settings['product']['product_no'])) $this->model_extension_module_price_control->editProduct(0, $settings['pc_score_id'], $settings['product'], array('name'=>'stock_status_id', 'value'=>99, 'quantity'=>0));
				} else {
					$json['error'] = 'Неверный тип файла!';
					break;
				}

				$json['success'] = 'Обработка прайса завершена!';

			} while (0);

			//error_log(print_r($_FILES,true));
		} else {
			$json['error'] = 'Файл не выбран';
		}

		$this->response->setOutput(json_encode($json));
	}

	private function parsStockStatus($value) {
		if ($this->contractorStock_status) {
			foreach ($this->contractorStock_status as $stock_status) {
				$stock_status_quantity = htmlspecialchars_decode(trim($stock_status['quantity']));
				if ($stock_status_quantity == $value) {
					return $stock_status['stock_status_id'];
				} elseif ($stock_status_quantity == '{number}' && is_numeric($value) && $value > 0) {
					return $stock_status['stock_status_id'];
				} elseif ($stock_status_quantity == '{all}') {
					return $stock_status['stock_status_id'];
				}
			}
		}
		return 99;
	}

	private function parsMarkup($price) {
		if ($this->contractorMarkup) {
			foreach ($this->contractorMarkup as $val) {
				preg_match('#^\((.*?)\)#', $val, $value);
				$numbers = explode('-', $value[1]);

				if ($price >= $numbers[0] && $price <= $numbers[1]) {
					return preg_replace('#^\((.*?)\)#', '', $val);
				}
			}
		} else {
			return 0;
		}
	}

	protected function validate() {
		if (!$this->user->hasPermission('modify', 'extension/module/price_control')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if ($this->error && !isset($this->error['warning'])) {
			$this->error['warning'] = $this->language->get('error_warning');
		}

		return !$this->error;
	}
}