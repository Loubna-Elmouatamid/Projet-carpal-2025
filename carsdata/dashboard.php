<?php
session_start();
if (!isset($_SESSION['user'])) {
    header("Location: login.php");
    exit;
}

echo "Bienvenue " . $_SESSION['user']['name'] . "!<br>";
echo "<a href='add_car.php'>Ajouter une voiture</a> | ";
echo "<a href='buy_car.php'>Acheter une voiture</a> | ";
echo "<a href='logout.php'>Déconnexion</a>";
?>