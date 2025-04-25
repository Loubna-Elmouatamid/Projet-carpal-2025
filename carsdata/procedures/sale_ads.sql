CREATE procedure Ajouter_sale_ads (
    IN p_user_id int(10),
    IN p_car_id int(10),
    IN p_price DECIMAL(10,2),
    IN p_car_condition varchar(50),
    IN p_created_at timestamp;

out p_message VARCHAR(200),
out p_success VARCHAR(200)
)

begin 
rollback;
SET p_success = FALSE;
SET p_message = 'Une ereur est survenue lors de cette operation';
End;

DECLARE v_sale_ads_id int;
DECLARE v_exist int;

if (p_user_id= "" or p_car_id="" or p_price="" or p_car_condition="" or p_created_at="") THEN
SET p_message = 'user_id , car_id , price , car_condition et created_at obligatoire';
SET p_success = 'FALSE';
LEAVE proc;
End if;
SELECT count(*)into v_exist
from sale_ads 
where (user_id = p_user_id or car_id = p_car_id or price = p_price or car_condition = p_car_condition or created_at = p_created_at );
if v_exist> 0 THEN
SET p_success = 'FALSE';
SET p_message = 'annonce existe déja.';
LEAVE proc;
ELSE
INSERT INTO sale_ads (user_id,car_id,price,car_condition,created_at)
VALUES (p_user_id,p_car_id,car_id,p_price,p_car_condition);
SET p_message = 'annonce ajouter avec succès';
SET p_success = 'TRUE';
COMMIT;
END IF;
END $$

DELIMITER $$

CREATE PROCEDURE Modifier_sale_ad(
  IN p_id INT,
  IN p_user_id INT,
  IN p_car_id INT,
  IN p_price DECIMAL(10,2)
)
BEGIN
  DECLARE sale_ad_count INT;

  SELECT COUNT(*) INTO sale_ad_count FROM sale_ads WHERE id = p_id;
  IF sale_ad_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : L\'annonce de vente avec cet ID n\'existe pas.';
  ELSE
    UPDATE sale_ads SET user_id = p_user_id, car_id = p_car_id, price = p_price WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE Supprimer_sale_ad(
  IN p_id INT
)
BEGIN
  DECLARE sale_ad_count INT;

  SELECT COUNT(*) INTO sale_ad_count FROM sale_ads WHERE id = p_id;
  IF sale_ad_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : L\'annonce de vente avec cet ID n\'existe pas.';
  ELSE
    DELETE FROM sale_ads WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE rechercher_sale_ad(
  IN p_car_id INT
)
BEGIN
  SELECT * FROM sale_ads WHERE car_id = p_car_id;
END //

DELIMITER ;