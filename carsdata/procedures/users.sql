CREATE procedure Ajouter_users (
    IN p_name varchar(50),
    IN p_email varchar(50),
    IN p_password varchar(50);
    

out p_message VARCHAR(200),
out p_success VARCHAR(200)
)

begin 
rollback;
SET p_success = FALSE;
SET p_message = 'Une ereur est survenue lors de cette operation';
End;

DECLARE v_users_id int;
DECLARE v_exist int;

if (p_name= "" or p_email="" or p_password="" ) THEN
SET p_message = 'name , email , password';
SET p_success = 'FALSE';
LEAVE proc;
End if;
SELECT count(*)into v_exist
from users 
where (name = p_name or email = p_email or password = p_password);
if v_exist> 0 THEN
SET p_success = 'FALSE';
SET p_message = ' le visiteur existe déja.';
LEAVE proc;
ELSE
INSERT INTO users (name,email,password)
VALUES (p_name,p_email,p_password);
SET p_message = 'visiteur ajouter avec succès';
SET p_success = 'TRUE';
COMMIT;
END IF;
END $$



DELIMITER $$
USE `cars_database`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Modifier_user`(
    IN p_id INT,
    IN p_nom VARCHAR(50), 
    IN p_email VARCHAR(50),
    IN p_password VARCHAR(50);
)
BEGIN
    DECLARE user_count INT;

    
    SELECT COUNT(*) INTO user_count FROM users WHERE id = p_id;

    IF user_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur : L\'utilisateur avec cet ID n\'existe pas.';
    ELSE
        
        UPDATE users 
        SET nome = p_nom, email = p_email, password = p_password
        WHERE id = p_id;
    END IF;
END$$

DELIMITER ;

DELIMITER $$
USE `cars_database`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Supprimer_user`(IN p_id INT)
BEGIN
    DECLARE user_count INT;
    DECLARE integrity_violation INT;

    
    SELECT COUNT(*) INTO user_count FROM users WHERE id = p_id;

    IF user_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur : L\'utilisateur avec cet ID n\'existe pas.';
    ELSE
        
        SELECT COUNT(*) INTO integrity_violation FROM commandes WHERE user_id = p_id;

        IF integrity_violation > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erreur : Impossible de supprimer cet utilisateur car des enregistrements associés existent.';
        ELSE
            
            DELETE FROM users WHERE id = p_id;
        END IF;
    END IF;
END$$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE rechercher_utilisateur(
  IN p_username VARCHAR(50)
)
BEGIN
  SELECT * FROM users 
  WHERE username LIKE CONCAT('%', p_username, '%');
END //

DELIMITER ;
