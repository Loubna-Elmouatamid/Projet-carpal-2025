CREATE procedure Ajouter_cars (
    IN p_name varchar(50),
    IN p_manufacturer varchar(50),
    IN p_production_year int(10),
    IN p_engine_type VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_description TEXT;

out p_message VARCHAR(200),
out p_success VARCHAR(200)
)

begin 
rollback;
SET p_success = FALSE;
SET p_message = 'Une ereur est survenue lors de cette operation';
End;

DECLARE v_cars_id int;
DECLARE v_exist int;

if (p_name= "" or p_manufacturer="" or p_production_year="" or p_engine_type="" or p_price="" or p_description="") THEN
SET p_message = 'name , manufacturer , production_year , engine_type , price et description obligatoire';
SET p_success = 'FALSE';
LEAVE proc;
End if;
SELECT count(*)into v_exist
from cars 
where (name = p_name or manufacturer = p_manufacturer or production_year = p_production_year or engine_type = p_engine_type or price = p_price or description = p_description);
if v_exist> 0 THEN
SET p_success = 'FALSE';
SET p_message = 'la voiture existe déja.';
LEAVE proc;
ELSE
INSERT INTO cars (name,manufacturer,production_year,engine_type,price,description)
VALUES (p_name,p_manufacturer,p_production_year,p_engine_type,p_price,p_description);
SET p_message = 'voiture ajouter avec succès';
SET p_success = 'TRUE';
COMMIT;
END IF;
END $$

DELIMITER $$

CREATE PROCEDURE Modifier_car(
  IN p_id INT,
  IN p_name VARCHAR(50),
  IN p_manufacturer VARCHAR(50),
  IN p_production_year INT,
  IN p_engine_type VARCHAR(50),
  IN p_price DECIMAL(10,2)
)
BEGIN
  DECLARE car_count INT;

  SELECT COUNT(*) INTO car_count FROM cars WHERE id = p_id;
  IF car_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : La voiture avec cet ID n\'existe pas.';
  ELSE
    UPDATE cars SET name = p_name, manufacturer = p_manufacturer, production_year = p_production_year, engine_type = p_engine_type, price = p_price WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE Supprimer_car(
  IN p_id INT
)
BEGIN
  DECLARE car_count INT;
  DECLARE integrity_violation INT;

  SELECT COUNT(*) INTO car_count FROM cars WHERE id = p_id;
  IF car_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : La voiture avec cet ID n\'existe pas.';
  ELSE
    SELECT COUNT(*) INTO integrity_violation 
    FROM (
      SELECT car_id FROM purchase_requests WHERE car_id = p_id
      UNION ALL
      SELECT car_id FROM sale_ads WHERE car_id = p_id
      UNION ALL
      SELECT car_id FROM user_comments WHERE car_id = p_id
      UNION ALL
      SELECT car_id FROM car_additional_info WHERE car_id = p_id
      UNION ALL
      SELECT car_id FROM car_images WHERE car_id = p_id
    ) AS associated_records;

    IF integrity_violation > 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : Impossible de supprimer cette voiture car des enregistrements associés existent.';
    ELSE
      DELETE FROM cars WHERE id = p_id;
    END IF;
  END IF;
END$$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE rechercher_voiture(
  IN p_name VARCHAR(50)
)
BEGIN
  SELECT * FROM cars WHERE name LIKE CONCAT('%', p_name, '%');
END //

DELIMITER ;
