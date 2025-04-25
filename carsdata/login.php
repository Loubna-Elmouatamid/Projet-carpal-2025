<?php
include 'config/database.php';
session_start();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->execute([$_POST['email']]);
    $user = $stmt->fetch();

    if ($user && password_verify($_POST['password'], $user['password'])) {
        $_SESSION['user'] = $user;
        header("Location: dashboard.php");
    } else {
        echo "Email ou mot de passe incorrect.";
    }
}
?>

<form method="post">
    Email: <input type="email" name="email" required><br>
    Mot de passe: <input type="password" name="password" required><br>
    <input type="submit" value="Connexion">
</form>