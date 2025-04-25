CREATE procedure Ajouter_car_additional_info (
    IN p_car_id int(10) ,
    IN p_technical_specs text,
    IN p_description text,
    

out p_message VARCHAR(200),
out p_success VARCHAR(200)
)

begin 
rollback;
SET p_success = FALSE;
SET p_message = 'Une ereur est survenue lors de cette operation';
End;

DECLARE v_car_additional_info_id int;
DECLARE v_exist int;

if (p_car_id= "" or p_technical_specs="" or p_description="") THEN
SET p_message = 'car_id , technical_specs , description ';
SET p_success = 'FALSE';
LEAVE proc;
End if;
SELECT count(*)into v_exist
from car_additional_info 
where (car_id = p_car_id or technical_specs = p_technical_specs or description = p_description );
if v_exist> 0 THEN
SET p_success = 'FALSE';
SET p_message = ' la voiture existe déja.';
LEAVE proc;
ELSE
INSERT INTO car_additional_info (car_id , technical_specs , description)
VALUES (p_car_id,p_technical_specs,p_description);
SET p_message = 'voiture ajouter avec succès';
SET p_success = 'TRUE';
COMMIT;
END IF;
END $$

DELIMITER $$

CREATE PROCEDURE Modifier_car_additional_info(
  IN p_id INT,
  IN p_technical_specs TEXT,
  IN p_description TEXT
)
BEGIN
  DECLARE car_additional_info_count INT;

  SELECT COUNT(*) INTO car_additional_info_count FROM car_additional_info WHERE id = p_id;
  IF car_additional_info_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : Les informations supplémentaires de la voiture avec cet ID n\'existent pas.';
  ELSE
    UPDATE car_additional_info SET technical_specs = p_technical_specs, description = p_description WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE Supprimer_car_additional_info(
  IN p_id INT
)
BEGIN
  DECLARE car_additional_info_count INT;

  SELECT COUNT(*) INTO car_additional_info_count FROM car_additional_info WHERE id = p_id;
  IF car_additional_info_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : Les informations supplémentaires de la voiture avec cet ID n\'existent pas.';
  ELSE
    DELETE FROM car_additional_info WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE rechercher_car_additional_info(
  IN p_car_id INT
)
BEGIN
  SELECT * FROM car_additional_info WHERE car_id = p_car_id;
END //

DELIMITER ;

