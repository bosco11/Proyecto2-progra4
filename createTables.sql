-- MySQL Script generated by MySQL Workbench
-- Mon May 31 17:12:18 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema bd_marketplace
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bd_marketplace
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bd_marketplace` DEFAULT CHARACTER SET utf8 ;
USE `bd_marketplace` ;

-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_usuarios` (
  `id_usuarios` BIGINT NOT NULL AUTO_INCREMENT,
  `cedula` VARCHAR(100) NOT NULL,
  `user` VARCHAR(50) NOT NULL,
  `password` VARCHAR(200) NOT NULL,
  `nombre_real` VARCHAR(100) NOT NULL,
  `imagen` VARCHAR(100) NOT NULL,
  `telefono` BIGINT NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `tipo_usuario` VARCHAR(200) NOT NULL,
  `pais` VARCHAR(100) NOT NULL,
  `denuncias` BIGINT NULL,
  `fecha_giros` DATE NULL,
  `cantidad_giros` BIGINT NULL,
  PRIMARY KEY (`id_usuarios`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_redes_sociales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_redes_sociales` (
  `id_redes_sociales` BIGINT NOT NULL AUTO_INCREMENT,
  `red_social` VARCHAR(200) NOT NULL,
  `id_usuarios` BIGINT NOT NULL,
  PRIMARY KEY (`id_redes_sociales`),
  INDEX `fk_tbl_redes_sociales_tbl_usuarios1_idx` (`id_usuarios` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_redes_sociales_tbl_usuarios1`
    FOREIGN KEY (`id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_direcciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_direcciones` (
  `id_direcciones` BIGINT NOT NULL AUTO_INCREMENT,
  `pais_direccion` VARCHAR(200) NOT NULL,
  `provincia` VARCHAR(200) NOT NULL,
  `numero_casillero` VARCHAR(200) NOT NULL,
  `codigo_postal` VARCHAR(100) NOT NULL,
  `observaciones` VARCHAR(300) NOT NULL,
  `id_usuarios` BIGINT NOT NULL,
  PRIMARY KEY (`id_direcciones`),
  INDEX `fk_tbl_direcciones_tbl_usuarios1_idx` (`id_usuarios` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_direcciones_tbl_usuarios1`
    FOREIGN KEY (`id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_formas_pago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_formas_pago` (
  `id_formas_pago` BIGINT NOT NULL AUTO_INCREMENT,
  `nombre_dueño` VARCHAR(200) NOT NULL,
  `numero_tarjeta` BIGINT NOT NULL,
  `cvv` BIGINT NOT NULL,
  `fecha_vencimiento` DATE NOT NULL,
  `saldo` FLOAT NOT NULL,
  `id_usuarios` BIGINT NOT NULL,
  PRIMARY KEY (`id_formas_pago`),
  INDEX `fk_tbl_formas_pago_tbl_usuarios1_idx` (`id_usuarios` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_formas_pago_tbl_usuarios1`
    FOREIGN KEY (`id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_categorias` (
  `id_categorias` BIGINT NOT NULL AUTO_INCREMENT,
  `categorias` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id_categorias`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_productos` (
  `id_productos` BIGINT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(200) NOT NULL,
  `fecha_publicacion` DATE NOT NULL,
  `ubicacion_fisica` VARCHAR(200) NOT NULL,
  `precio` FLOAT NOT NULL,
  `tiempo_promedio` VARCHAR(45) NOT NULL,
  `costo_envio` FLOAT NOT NULL,
  `id_usuarios` BIGINT NOT NULL,
  `id_categorias` BIGINT NOT NULL,
  `cantidad` BIGINT NOT NULL,
  PRIMARY KEY (`id_productos`),
  INDEX `fk_tbl_productos_tbl_usuarios1_idx` (`id_usuarios` ASC) VISIBLE,
  INDEX `fk_tbl_productos_tbl_categorias1_idx` (`id_categorias` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_productos_tbl_usuarios1`
    FOREIGN KEY (`id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_productos_tbl_categorias1`
    FOREIGN KEY (`id_categorias`)
    REFERENCES `bd_marketplace`.`tbl_categorias` (`id_categorias`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_galeria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_galeria` (
  `id_galeria` BIGINT NOT NULL AUTO_INCREMENT,
  `imagen_producto` VARCHAR(200) NOT NULL,
  `tbl_productos_id_productos` BIGINT NOT NULL,
  PRIMARY KEY (`id_galeria`),
  INDEX `fk_tbl_galeria_tbl_productos1_idx` (`tbl_productos_id_productos` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_galeria_tbl_productos1`
    FOREIGN KEY (`tbl_productos_id_productos`)
    REFERENCES `bd_marketplace`.`tbl_productos` (`id_productos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_suscriptores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_suscriptores` (
  `tienda_id_usuarios` BIGINT NOT NULL,
  `comprador_id_usuarios` BIGINT NOT NULL,
  PRIMARY KEY (`tienda_id_usuarios`, `comprador_id_usuarios`),
  INDEX `fk_tbl_suscriptores_tbl_usuarios2_idx` (`comprador_id_usuarios` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_suscriptores_tbl_usuarios1`
    FOREIGN KEY (`tienda_id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_suscriptores_tbl_usuarios2`
    FOREIGN KEY (`comprador_id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_compras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_compras` (
  `id_compras` BIGINT NOT NULL AUTO_INCREMENT,
  `id_usuarios` BIGINT NOT NULL,
  `id_formas_pago` BIGINT NOT NULL,
  `fecha` DATE NOT NULL,
  `precio_total` FLOAT NOT NULL,
  PRIMARY KEY (`id_compras`),
  INDEX `fk_tbl_compras_tbl_usuarios1_idx` (`id_usuarios` ASC) VISIBLE,
  INDEX `fk_tbl_compras_tbl_formas_pago1_idx` (`id_formas_pago` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_compras_tbl_usuarios1`
    FOREIGN KEY (`id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_compras_tbl_formas_pago1`
    FOREIGN KEY (`id_formas_pago`)
    REFERENCES `bd_marketplace`.`tbl_formas_pago` (`id_formas_pago`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_productos_compras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_productos_compras` (
  `id_productos` BIGINT NOT NULL,
  `id_compras` BIGINT NOT NULL,
  INDEX `fk_tbl_productos_compras_tbl_productos1_idx` (`id_productos` ASC) VISIBLE,
  INDEX `fk_tbl_productos_compras_tbl_compras1_idx` (`id_compras` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_productos_compras_tbl_productos1`
    FOREIGN KEY (`id_productos`)
    REFERENCES `bd_marketplace`.`tbl_productos` (`id_productos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_productos_compras_tbl_compras1`
    FOREIGN KEY (`id_compras`)
    REFERENCES `bd_marketplace`.`tbl_compras` (`id_compras`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_carrito_deseos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_carrito_deseos` (
  `id_usuarios` BIGINT NOT NULL,
  `id_productos` BIGINT NOT NULL,
  `tipo_producto` VARCHAR(45) NOT NULL,
  INDEX `fk_tbl_carrito_deseos_tbl_usuarios1_idx` (`id_usuarios` ASC) VISIBLE,
  INDEX `fk_tbl_carrito_deseos_tbl_productos1_idx` (`id_productos` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_carrito_deseos_tbl_usuarios1`
    FOREIGN KEY (`id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_carrito_deseos_tbl_productos1`
    FOREIGN KEY (`id_productos`)
    REFERENCES `bd_marketplace`.`tbl_productos` (`id_productos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_calificacion_productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_calificacion_productos` (
  `id_productos` BIGINT NOT NULL,
  `calificacion` BIGINT NOT NULL,
  `comentarios` VARCHAR(300) NULL,
  `respuetas` VARCHAR(300) NULL,
  `id_usuarios` BIGINT NOT NULL,
  INDEX `fk_tbl_calificacion_productos_tbl_productos1_idx` (`id_productos` ASC) VISIBLE,
  PRIMARY KEY (`id_usuarios`, `id_productos`),
  CONSTRAINT `fk_tbl_calificacion_productos_tbl_productos1`
    FOREIGN KEY (`id_productos`)
    REFERENCES `bd_marketplace`.`tbl_productos` (`id_productos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_calificacion_productos_tbl_usuarios1`
    FOREIGN KEY (`id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_calificacion_tienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_calificacion_tienda` (
  `calificacion` BIGINT NOT NULL,
  `tienda_id_usuarios` BIGINT NOT NULL,
  `comprador_id_usuarios` BIGINT NOT NULL,
  PRIMARY KEY (`tienda_id_usuarios`, `comprador_id_usuarios`),
  INDEX `fk_tbl_calificacion_tienda_tbl_usuarios2_idx` (`comprador_id_usuarios` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_calificacion_tienda_tbl_usuarios1`
    FOREIGN KEY (`tienda_id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_calificacion_tienda_tbl_usuarios2`
    FOREIGN KEY (`comprador_id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_premios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_premios` (
  `id_premios` BIGINT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  `id_usuarios` BIGINT NOT NULL,
  PRIMARY KEY (`id_premios`),
  INDEX `fk_tbl_premios_tbl_usuarios1_idx` (`id_usuarios` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_premios_tbl_usuarios1`
    FOREIGN KEY (`id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_marketplace`.`tbl_notificaciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_marketplace`.`tbl_notificaciones` (
  `id_notificaciones` BIGINT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(300) NOT NULL,
  `id_usuarios` BIGINT NOT NULL,
  `estado` VARCHAR(1) NOT NULL,
  PRIMARY KEY (`id_notificaciones`),
  INDEX `fk_tbl_notificaciones_tbl_usuarios1_idx` (`id_usuarios` ASC) VISIBLE,
  CONSTRAINT `fk_tbl_notificaciones_tbl_usuarios1`
    FOREIGN KEY (`id_usuarios`)
    REFERENCES `bd_marketplace`.`tbl_usuarios` (`id_usuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
