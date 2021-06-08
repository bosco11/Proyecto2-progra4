<?php

class Tienda_model extends CI_Model
{

	//Se utiliza el algoritmo de encriptación nativo de PHP password_hash('contraseña', PASSWORD_BCRYPT) para encriptar.
	//Para verificar la contraseña se utiliza password_verify('contraseña','passw de la BD')
	public function get_productos_tienda($id)
	{
		$query = $this->db->query("SELECT u.*,c.categorias FROM tbl_productos u JOIN tbl_categorias c ON c.id_categorias=u.id_categorias where u.id_usuarios = $id");
		return $query->result_array();
	}
	//Retorna los datos del usuario indicado por parámetro
	public function get_user_information($username)
	{

		$query = $this->db->query("SELECT u.* FROM tbl_usuarios u where u.user = '$username'");

		if ($query->num_rows() == 1) {
			return $query->result();
		} else {
			return false;
		}
	}
	public function get_productos_id($id)
	{
		$query = $this->db->query("SELECT u.*,c.categorias FROM tbl_productos u JOIN tbl_categorias c ON c.id_categorias=u.id_categorias where u.id_productos = $id");
		if ($query->num_rows() == 1) {
			return $query->result_array();
		} else {
			return false;
		}
	}
	public function get_elimnar_producto($id)
	{
		$this->db->delete('tbl_productos', array('id_productos' => $id));
	}
	public function get_categorias()
	{
		return $this->db->get('tbl_categorias')->result_array();
	}
	public function get_categorias_id($id)
	{
		$this->db->where('id_categorias', $id);
		return $this->db->get('tbl_categorias')->row_array();
	}
	public function addCategoria($params)
	{
		$this->db->insert('tbl_categorias', $params);
		$this->db->insert_id();
	}
	public function editCategoria($id,$params)
	{

		$this->db->where('id_categorias', $id);
		$this->db->update('tbl_categorias', $params);
	}
	public function addProducto($params)
	{
		$this->db->insert('tbl_productos', $params);
		return $this->db->insert_id();
	}
	public function editProducto($params, $id)
	{
		$this->db->where('id_productos', $id);
		$this->db->update('tbl_productos', $params);
	}
	public function addFotoProducto($params)
	{

		$this->db->insert('tbl_galeria', $params);
		return $this->db->insert_id();
	}
	public function getFotosProducto($id)
	{
		$this->db->where('id_productos', $id);
		return $this->db->get('tbl_galeria')->result_array();
	}
	public function deleteFoto($id)
	{
		$this->db->delete('tbl_galeria', array('id_galeria' => $id));
	}
	public function buscarProductos($id, $categoria, $descripcion)
	{
		if ($descripcion != null and $categoria == null) {
			$query = $this->db->query("SELECT u.*,c.categorias FROM tbl_productos u JOIN tbl_categorias c ON c.id_categorias=u.id_categorias where u.id_usuarios = $id AND u.descripcion LIKE '$descripcion%'");
		} else {
			if ($descripcion == null and $categoria != null) {
				$query = $this->db->query("SELECT u.*,c.categorias FROM tbl_productos u JOIN tbl_categorias c ON c.id_categorias=u.id_categorias where u.id_usuarios = $id AND u.id_categorias = " . $categoria);
			} else {
				if ($descripcion != null and $categoria != null) {
					$query = $this->db->query("SELECT u.*,c.categorias FROM tbl_productos u JOIN tbl_categorias c ON c.id_categorias=u.id_categorias where u.id_usuarios = $id AND u.descripcion LIKE '$descripcion%' AND u.id_categorias = $categoria");
				}
			}
		}

		return $query->result_array();
	}
	public function get_user_information_id($id)
	{

		$query = $this->db->query("SELECT u.* FROM tbl_usuarios u where u.id_usuarios = $id");
		return $query->row_array();
	}
	public function calificarTienda($params)
	{
		$this->db->delete('tbl_calificacion_tienda', array('tienda_id_usuarios' =>  $params['tienda_id_usuarios'], 'comprador_id_usuarios' => $params['comprador_id_usuarios']));

		$this->db->insert('tbl_calificacion_tienda', $params);
		return $this->db->insert_id();
	}
	public function notificaionesTienda($id)
	{
		$query = $this->db->query("SELECT u.* FROM tbl_notificaciones u where u.id_usuarios = $id AND u.estado='N'");
		return $query->result_array();
	}
	public function ocultarNotificacion($id)
	{
		$this->db->where('id_notificaciones', $id);
		$this->db->update('tbl_notificaciones', array('estado' => 'S'));
	}
	public function getSuscribircionTienda($params){
		
		$query = $this->db->query("SELECT u.*FROM tbl_suscriptores u where u.tienda_id_usuarios = ". $params['tienda_id_usuarios'] ." AND u.comprador_id_usuarios = ". $params['comprador_id_usuarios'] );
		if ($query->num_rows() == 1) {
			return true;
		} else {
			return false;
		}

	}
	public function desuscribirseTienda($params){
		$this->db->delete('tbl_suscriptores', array('tienda_id_usuarios' =>  $params['tienda_id_usuarios'], 'comprador_id_usuarios' => $params['comprador_id_usuarios']));

		
	}
	public function suscribirseTienda($params){
		$this->db->insert('tbl_suscriptores', $params);
		return $this->db->insert_id();
	}
	public function getCalificacionTienda($id){
		$query = $this->db->query("SELECT u.* FROM tbl_calificacion_tienda u where u.tienda_id_usuarios = $id");
		return $query->result_array();
	}
}
