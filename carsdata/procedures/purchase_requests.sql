CREATE PROCEDURE Ajouter_purchase_request(
  IN p_user_id INT(10),
  IN p_car_id INT(10),
  OUT p_message VARCHAR(200),
  OUT p_success VARCHAR(200)
)
BEGIN
  DECLARE v_user_id_count INT;
  DECLARE v_car_id_count INT;

  SELECT COUNT(*) INTO v_user_id_count FROM users WHERE id = p_user_id;
  SELECT COUNT(*) INTO v_car_id_count FROM cars WHERE id = p_car_id;
  IF v_user_id_count = 0 OR v_car_id_count = 0 THEN
    SET p_message = 'L\'utilisateur ou la voiture n\'existe pas';
    SET p_success = 'FALSE';

DELIMITER $$

CREATE PROCEDURE Modifier_purchase_request(
  IN p_id INT,
  IN p_user_id INT,
  IN p_car_id INT
)
BEGIN
  DECLARE purchase_request_count INT;

  SELECT COUNT(*) INTO purchase_request_count FROM purchase_requests WHERE id = p_id;
  IF purchase_request_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : La demande d\'achat avec cet ID n\'existe pas.';
  ELSE
    UPDATE purchase_requests SET user_id = p_user_id, car_id = p_car_id WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE Supprimer_purchase_request(
  IN p_id INT
)
BEGIN
  DECLARE purchase_request_count INT;

  SELECT COUNT(*) INTO purchase_request_count FROM purchase_requests WHERE id = p_id;
  IF purchase_request_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : La demande d\'achat avec cet ID n\'existe pas.';
  ELSE
    DELETE FROM purchase_requests WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE rechercher_purchase_request(
  IN p_user_id INT
)
BEGIN
  SELECT * FROM purchase_requests WHERE user_id = p_user_id;
END //

DELIMITER ;
