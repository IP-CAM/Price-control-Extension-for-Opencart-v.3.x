<?php
class ModelExtensionModulePriceControl extends Model {

	//price_control_product - связи

	public function deleteScore() {
		$this->db->query("DELETE FROM " . DB_PREFIX . "price_control");
		$this->db->query("DELETE FROM " . DB_PREFIX . "price_control_to_product");
	}

	public function addScore($data) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "price_control");
		if (!empty($data)) {

			foreach ($data as $scores) {
				if (isset($scores['pc_score_id'])) {
					$pc_score_id = $scores['pc_score_id'];
				} else {
					$pc_score_id = 0;
				}

				if (isset($scores['currency_id'])) {
					$currency_id = $scores['currency_id'];
				} else {
					$currency_id = 0;
				}

				$pc_column = $markup = $stock_status = '';
				if (isset($scores['pc_column'])) {
					$pc_column = json_encode($scores['pc_column'], true);
				}

				if (isset($scores['stock_status'])) {
					$stock_status = json_encode($scores['stock_status'], true);
				}

				if (isset($scores['markup'])) {
					//$markup = $scores['markup'];
					$markup = json_encode($scores['markup'], true);
				}

				$this->db->query("INSERT INTO " . DB_PREFIX . "price_control SET pc_score_id = '" . (int)$pc_score_id . "', currency_id = '" . (int)$currency_id . "', name = '" . $this->db->escape(trim($scores['name'])) . "', url = '" . $this->db->escape($scores['url']) . "', pc_column = '" . $this->db->escape($pc_column) . "', markup = '" . $this->db->escape($markup) . "', stock_status = '" . $this->db->escape($stock_status) . "'");
			}
		}
	}


	public function getScores($filter = array()) {
		$data = array();

		$sql = "SELECT * FROM " . DB_PREFIX . "price_control";

		if($filter) {
			$sql .= " WHERE";

			if($filter['pc_score_id']) {
				$sql .= " pc_score_id = '" . $filter['pc_score_id'] . "'";
			}
		}

		$sql .= " GROUP BY pc_score_id ORDER BY name ASC";

		$query = $this->db->query($sql);

		foreach ($query->rows as $score) {

			$data[] = array(
				'pc_score_id'         => $score['pc_score_id'],
				'currency_id'         => $score['currency_id'],
				'name' 				  => $score['name'],
				'url'                 => $score['url'],
				'pc_column' 		  => json_decode($score['pc_column'], true),
				//'markup' 			  => $score['markup'],
				'markup' 			  => json_decode($score['markup'], true),
				'stock_status' 		  => json_decode($score['stock_status'], true)
			);
		}
		return $data;
	}


		### Работа с товаром ###
	public function addProductScore ($product_id, $data = array()) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "price_control_to_product WHERE product_id = '" . (int)$product_id . "'");
		if (!empty($data)) {
			foreach ($data as $score) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "price_control_to_product SET price_control_id = '" . (int)$score['price_control_id'] . "', pc_score_id = '" . (int)$score['pc_score_id'] . "', product_id = '" . (int)$product_id . "', model = '" . $this->db->escape(trim($score['model'])) . "', name = '" . $this->db->escape(trim($score['name'])) . "', price = '" . (float)$score['price'] . "', extra_charge = '" . (float)$score['extra_charge'] . "', stock_status_id = '" . (int)$score['stock_status_id'] . "', label = '" . (int)$score['label'] . "', date = NOW()");
			}
		}
	}

	public function getProductScore ($product_id) {
		$query = $this->db->query("SELECT pcp.price_control_id, pcp.pc_score_id, pcp.model, pcp.name, pcp.price, pcp.extra_charge, pcp.stock_status_id, pcp.label FROM " . DB_PREFIX . "price_control_to_product pcp LEFT JOIN " . DB_PREFIX . "price_control pc ON (pc.pc_score_id = pcp.pc_score_id) WHERE pcp.product_id = '" . (int)$product_id . "' ORDER BY pc.name, pcp.model");

		return $query->rows;
	}

	public function getProductListScore ($product_id) {
		$query = $this->db->query("SELECT pcp.price_control_id, pcp.pc_score_id, pcp.product_id, pcp.model, pcp.name AS product_name, pcp.price, pcp.extra_charge, pcp.stock_status_id, pc.name AS score_name, pc.url AS score_url, c.code AS currency_code, c.value AS currency_value FROM " . DB_PREFIX . "price_control_to_product pcp LEFT JOIN " . DB_PREFIX . "price_control pc ON (pc.pc_score_id = pcp.pc_score_id) LEFT JOIN " . DB_PREFIX . "currency c ON (c.currency_id = pc.currency_id) WHERE pcp.product_id IN (" . $this->db->escape(implode(',', $product_id)) . ")");

		return $query->rows;
	}

	public function getContractorProduct($pc_score_id, $manufacturer_id) {
		$sql = "SELECT pcp.price_control_id, pcp.pc_score_id, pcp.product_id, pcp.model, pcp.name, pcp.price, pcp.extra_charge, pcp.stock_status_id, pcp.label, pcp.date, pc.name AS contractor_name, pd.name AS product_name, p.model AS product_model, p.price AS product_price, p.extra_charge AS product_extra_charge, p.base_price AS product_base_price, p.base_currency_code AS product_base_currency_code, p.quantity AS product_quantity, p.stock_status_id AS product_stock_status_id, p.manufacturer_id AS product_manufacturer_id FROM " . DB_PREFIX . "price_control_to_product pcp LEFT JOIN " . DB_PREFIX . "price_control pc ON (pc.pc_score_id = pcp.pc_score_id) LEFT JOIN " . DB_PREFIX . "product p ON (p.product_id = pcp.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON (pd.product_id = pcp.product_id)";

		if ($pc_score_id && !$manufacturer_id) {
			$sql .= " WHERE pcp.pc_score_id = '" . (int)$pc_score_id . "' AND pd.language_id = '" . (int)$this->config->get('config_language_id') . "' ORDER BY pcp.label, pd.name";
		} elseif ($pc_score_id && $manufacturer_id) {
			$sql .= " WHERE pcp.pc_score_id = '" . (int)$pc_score_id . "' AND p.manufacturer_id = '" . (int)$manufacturer_id . "' AND pd.language_id = '" . (int)$this->config->get('config_language_id') . "' ORDER BY pcp.label, pd.name";
		} elseif (!$pc_score_id && $manufacturer_id) {
			$sql .= " WHERE p.manufacturer_id = '" . (int)$manufacturer_id . "' AND pd.language_id = '" . (int)$this->config->get('config_language_id') . "' ORDER BY pcp.label, pd.name";
		}

		$query = $this->db->query($sql);

		return $query->rows;
	}

	public function editContractor($price_control_id, $pc_score_id, $settings, $data) {
		if ($data['name'] == 'price')  $data['value'] = (float)str_replace(' ', '', str_replace(',','.',$data['value']));

		$sql = "UPDATE " . DB_PREFIX . "price_control_to_product pcp LEFT JOIN " . DB_PREFIX . "product p ON (pcp.product_id = p.product_id) SET";

		if(isset($data['name'])) $sql .= " pcp." . $data['name'] . " = '" . $this->db->escape(trim($data['value'])) . "',";

		if ($price_control_id) {
			$sql .= " pcp.date = NOW() WHERE pcp.price_control_id = '" . (int)$price_control_id. "'";
		} else {
			$sql .= " pcp.date = NOW() WHERE pcp.pc_score_id = '" . (int)$pc_score_id. "'";
		}

		if (isset($data['and_name']) && isset($data['and_value'])) $sql .= " AND pcp." . $data['and_name'] . " = '" . $this->db->escape($data['and_value']) . "'";

		if (!empty($settings['manufacturer_id'])) $sql .= " AND p.manufacturer_id = '" . (int)$settings['manufacturer_id'] . "'";

		$this->db->query($sql);
	}

	public function editProduct($product_id, $pc_score_id, $settings, $data) {

		if ($data['name'] == 'price' || $data['name'] == 'base_price') $data['value'] = (float)str_replace(' ', '', str_replace(',','.',$data['value']));

		if($pc_score_id) {
			$sql = "UPDATE " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "price_control_to_product pcp ON (p.product_id = pcp.product_id)";
		} else {
			$sql = "UPDATE " . DB_PREFIX . "product p";
		}

		if(isset($data['name'])) $sql .= " SET p." . $data['name'] . " = '" . $this->db->escape(trim($data['value'])) . "',";

		if(isset($data['quantity'])) $sql .= " p.quantity = '" . (int)$data['quantity'] . "',";

		if ($pc_score_id) {
			$sql .= " p.date_modified = NOW() WHERE pcp.pc_score_id = '" . (int)$pc_score_id. "' AND pcp.label = 0";
		} else {
			$sql .= " p.date_modified = NOW() WHERE p.product_id = '" . (int)$product_id. "'";
		}

		if (!empty($settings['manufacturer_id'])) $sql .= " AND p.manufacturer_id = '" . (int)$settings['manufacturer_id'] . "'";

		$this->db->query($sql);
	}

	public function getContractorMinPrice($manufacturer_id) {
		$sql = "SELECT pcp.pc_score_id, pcp.product_id, pcp.price, pcp.stock_status_id, pcp.extra_charge, pc.markup, c.code FROM " . DB_PREFIX . "price_control_to_product pcp LEFT JOIN " . DB_PREFIX . "price_control pc ON (pc.pc_score_id = pcp.pc_score_id) LEFT JOIN " . DB_PREFIX . "currency c ON (c.currency_id = pc.currency_id)";

		if ($manufacturer_id) {
			//$sql .= " LEFT JOIN " . DB_PREFIX . "product p ON (p.product_id = pcp.product_id) WHERE p.manufacturer_id = '" . (int)$manufacturer_id . "' AND ((pcp.price+pcp.price/100*pcp.extra_charge)/c.value) = (SELECT ((pcp2.price+pcp2.price/100*pcp2.extra_charge)/c2.value) as price_uah FROM " . DB_PREFIX . "price_control_to_product pcp2 LEFT JOIN " . DB_PREFIX . "price_control pc2 ON (pc2.pc_score_id = pcp2.pc_score_id) LEFT JOIN " . DB_PREFIX . "currency c2 ON (c2.currency_id = pc2.currency_id) WHERE pcp2.product_id = pcp.product_id AND pcp2.price <> 0 AND p.manufacturer_id = '" . (int)$manufacturer_id . "' ORDER BY pcp2.stock_status_id, price_uah LIMIT 1)";
			$sql .= " LEFT JOIN " . DB_PREFIX . "product p ON (p.product_id = pcp.product_id) WHERE p.manufacturer_id = '" . (int)$manufacturer_id . "' AND pcp.price_control_id = (SELECT pcp2.price_control_id FROM " . DB_PREFIX . "price_control_to_product pcp2 LEFT JOIN " . DB_PREFIX . "price_control pc2 ON (pc2.pc_score_id = pcp2.pc_score_id) LEFT JOIN " . DB_PREFIX . "currency c2 ON (c2.currency_id = pc2.currency_id) WHERE pcp2.product_id = pcp.product_id AND pcp2.price <> 0 AND p.manufacturer_id = '" . (int)$manufacturer_id . "' ORDER BY pcp2.stock_status_id, ((pcp2.price+pcp2.price/100*pcp2.extra_charge)/c2.value) LIMIT 1)";
		} else {
			$sql .= " WHERE ((pcp.price+pcp.price/100*pcp.extra_charge)/c.value) = (SELECT ((pcp2.price+pcp2.price/100*pcp2.extra_charge)/c2.value) as price_uah FROM " . DB_PREFIX . "price_control_to_product pcp2 LEFT JOIN " . DB_PREFIX . "price_control pc2 ON (pc2.pc_score_id = pcp2.pc_score_id) LEFT JOIN " . DB_PREFIX . "currency c2 ON (c2.currency_id = pc2.currency_id) WHERE pcp2.product_id = pcp.product_id AND pcp2.price <> 0 ORDER BY pcp2.stock_status_id, price_uah LIMIT 1)";
		}

		$sql .= " GROUP BY pcp.product_id";

		$query = $this->db->query($sql);

		return $query->rows;
	}

	public function editProductMinPrice($data) {
		foreach ($data as $value) {
			$this->db->query("UPDATE " . DB_PREFIX . "product SET extra_charge = '" . (float)$value['extra_charge'] . "', base_price = '" . (float)$value['base_price'] . "', base_currency_code = '" . $this->db->escape($value['base_currency_code']) . "', quantity = '" . (int)$value['quantity'] . "', stock_status_id = '" . (int)$value['stock_status_id'] . "' WHERE product_id = '" . (int)$value['product_id'] . "'");
		}
	}

	public function parsEditContractor($pc_score_id, $settings, $basic_col, $data) {
		$this->db->query("SET @update_product_id := 0");

		$sql = "UPDATE " . DB_PREFIX . "price_control_to_product pcp LEFT JOIN " . DB_PREFIX . "product p ON (pcp.product_id = p.product_id)";

		$sql .=" SET pcp.product_id = (SELECT @update_product_id := pcp.product_id),";

		if (isset($settings['model']) && $data['model']) $sql .=" pcp.model = '" . $this->db->escape($data['model']) . "',";

		if (isset($settings['name']) && $data['name']) $sql .= " pcp.name = '" . $this->db->escape($data['name']) . "',";

		if (isset($settings['price']) && !empty($data['price'])) $sql .= " pcp.price = '" . (float)$data['price'] . "',";

		if (isset($settings['extra_charge'])) $sql .= " pcp.extra_charge = '" . (int)$data['extra_charge'] . "',";

		if (isset($settings['quantity']) && !empty($data['stock_status_id'])) $sql .= " pcp.stock_status_id = '" . (int)$data['stock_status_id'] . "',";

		$sql .= " pcp.label = 1, pcp.date = NOW() WHERE pcp.pc_score_id = '" . (int)$pc_score_id. "' AND pcp." . $basic_col . " = '" . $this->db->escape($data[$basic_col]) . "'";

		if ($settings['manufacturer_id']) $sql .= " AND p.manufacturer_id = '" . (int)$settings['manufacturer_id'] . "'";

		$this->db->query($sql);

		$product_id = $this->db->query("SELECT @update_product_id");

		return $product_id->row['@update_product_id'];
	}

	public function parsEditProduct($product_id, $settings, $data) {
		$sql = "UPDATE " . DB_PREFIX . "product SET";

		if (isset($settings['model']) && $data['model']) $sql .=" model = '" . $this->db->escape($data['model']) . "',";

		if (isset($settings['quantity']) && !empty($data['stock_status_id'])) {
			if ($data['stock_status_id'] == 1) {
				$sql .= " quantity = 1, stock_status_id = '" . (int)$data['stock_status_id'] . "',";
			} else {
				$sql .= " quantity = 0, stock_status_id = '" . (int)$data['stock_status_id'] . "',";
			}
		}

		if (isset($settings['extra_charge']) && is_numeric($data['extra_charge']) && !empty($data['price'])) $sql .= " extra_charge = '" . (int)$data['extra_charge'] . "',";

		if (isset($settings['base_price']) && !empty($data['price'])) $sql .= " base_price = '" . (float)$data['price'] . "',";

		if (isset($settings['base_currency_code']) && $data['base_currency_code']) $sql .= " base_currency_code = '" . $this->db->escape($data['base_currency_code']) . "',";

		$sql .= " date_modified = NOW() WHERE product_id = '" . (int)$product_id . "'";

		if ($settings['manufacturer_id']) $sql .= " AND manufacturer_id = '" . (int)$settings['manufacturer_id'] . "'";

		$this->db->query($sql);
	}

	public function getTotalContractorByPcSoreId($pc_score_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "price_control_to_product WHERE pc_score_id = '" . (int)$pc_score_id . "'");
		$data['total'] = $query->row['total'];

		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "price_control_to_product WHERE pc_score_id = '" . (int)$pc_score_id . "' AND label = 1");
		$data['total_update'] = $query->row['total'];

		return $data;
	}

}