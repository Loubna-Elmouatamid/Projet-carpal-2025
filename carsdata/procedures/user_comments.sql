DELIMITER $$

CREATE PROCEDURE Ajouter_user_comment(
  IN p_user_id INT(10),
  IN p_car_id INT(10),
  IN p_comment TEXT,
  OUT p_message VARCHAR(200),
  OUT p_success VARCHAR(200)
)
BEGIN
  DECLARE v_user_exist INT;
  DECLARE v_car_exist INT;

  IF (p_user_id = 0 OR p_car_id = 0 OR p_comment = "") THEN
    SET p_message = 'Tous les champs sont requis';
    SET p_success = 'FALSE';
  ELSE
    SELECT COUNT(*) INTO v_user_exist FROM users WHERE id = p_user_id;
    SELECT COUNT(*) INTO v_car_exist FROM cars WHERE id = p_car_id;
    IF v_user_exist = 0 OR v_car_exist = 0 THEN
      SET p_success = 'FALSE';
      SET p_message = 'L\'utilisateur ou la voiture n\'existe pas.';
    ELSE
      INSERT INTO user_comments (user_id, car_id, comment) VALUES (p_user_id, p_car_id, p_comment);
      SET p_message = 'Commentaire ajouté avec succès';
      SET p_success = 'TRUE';
    END IF;
  END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE Modifier_user_comment(
  IN p_id INT,
  IN p_user_id INT,
  IN p_car_id INT,
  IN p_comment TEXT
)
BEGIN
  DECLARE user_comment_count INT;

  SELECT COUNT(*) INTO user_comment_count FROM user_comments WHERE id = p_id;
  IF user_comment_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : Le commentaire avec cet ID n\'existe pas.';
  ELSE
    UPDATE user_comments SET user_id = p_user_id, car_id = p_car_id, comment = p_comment WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE Supprimer_user_comment(
  IN p_id INT
)
BEGIN
  DECLARE user_comment_count INT;

  SELECT COUNT(*) INTO user_comment_count FROM user_comments WHERE id = p_id;
  IF user_comment_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : Le commentaire avec cet ID n\'existe pas.';
  ELSE
    DELETE FROM user_comments WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE rechercher_user_comment(
  IN p_car_id INT
)
BEGIN
  SELECT * FROM user_comments WHERE car_id = p_car_id;
END //

DELIMITER ;