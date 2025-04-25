<?php
include 'config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);
    

    $stmt = $pdo->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
    $stmt->execute([$name, $email, $password]);
    echo "Compte créé avec succès. <a href='login.php'>Connectez-vous ici</a>";
}
?>

<form method="post">
    Nom: <input type="text" name="name" required><br>
    Email: <input type="email" name="email" required><br>
    Mot de passe: <input type="password" name="password" required><br>
    
</form>