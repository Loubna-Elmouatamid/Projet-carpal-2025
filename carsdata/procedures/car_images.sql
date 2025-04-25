CREATE procedure Ajouter_car_images (
    IN p_car_id int(10) ,
    IN p_image_url varchar(255) ;

out p_message VARCHAR(200),
out p_success VARCHAR(200)
)

begin 
rollback;
SET p_success = FALSE;
SET p_message = 'Une ereur est survenue lors de cette operation';
End;

DECLARE v_car_images_id int;
DECLARE v_exist int;

if (p_car_id= "" or p_image_url="") THEN
SET p_message = 'car_id , image_url  ';
SET p_success = 'FALSE';
LEAVE proc;
End if;
SELECT count(*)into v_exist
from car_images 
where (car_id = p_car_id or image_url = p_image_url);
if v_exist> 0 THEN
SET p_success = 'FALSE';
SET p_message = ' la image existe déja.';
LEAVE proc;
ELSE
INSERT INTO car_images (car_id , image_url )
VALUES (p_car_id,p_image_url);
SET p_message = 'image ajouter avec succès';
SET p_success = 'TRUE';
COMMIT;
END IF;
END $$

DELIMITER $$

CREATE PROCEDURE Modifier_car_image(
  IN p_id INT,
  IN p_image_url VARCHAR(255)
)
BEGIN
  DECLARE car_image_count INT;

  SELECT COUNT(*) INTO car_image_count FROM car_images WHERE id = p_id;
  IF car_image_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : L\'image de la voiture avec cet ID n\'existe pas.';
  ELSE
    UPDATE car_images SET image_url = p_image_url WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE Supprimer_car_image(
  IN p_id INT
)
BEGIN
  DECLARE car_image_count INT;

  SELECT COUNT(*) INTO car_image_count FROM car_images WHERE id = p_id;
  IF car_image_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : L\'image de la voiture avec cet ID n\'existe pas.';
  ELSE
    DELETE FROM car_images WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE rechercher_car_image(
  IN p_car_id INT
)
BEGIN
  SELECT * FROM car_images WHERE car_id = p_car_id;
END //

DELIMITER ;