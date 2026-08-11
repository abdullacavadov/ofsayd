<?php

declare(strict_types=1);

require_once '../../config/database.php';
require_once '../../inc/response.php';

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    jsonResponse([
        'success' => false,
        'message' => 'Yalnız POST sorğusuna icazə verilir.'
    ], 405);
}

$input = json_decode(
    file_get_contents('php://input'),
    true
);

if (!is_array($input)) {
    jsonResponse([
        'success' => false,
        'message' => 'Yanlış request formatı.'
    ], 400);
}

$username = trim($input['username'] ?? '');
$email = trim($input['email'] ?? '');
$password = $input['password'] ?? '';

/*
 * Username
 */
if ($username === '') {
    jsonResponse([
        'success' => false,
        'message' => 'Username tələb olunur.'
    ], 422);
}

if (mb_strlen($username) < 3 || mb_strlen($username) > 50) {
    jsonResponse([
        'success' => false,
        'message' => 'Username 3-50 simvol arasında olmalıdır.'
    ], 422);
}

/*
 * Yalnız təhlükəsiz username simvolları.
 */
if (!preg_match('/^[a-zA-Z0-9_.-]+$/', $username)) {
    jsonResponse([
        'success' => false,
        'message' => 'Username yalnız hərf, rəqəm, _, . və - simvollarından ibarət ola bilər.'
    ], 422);
}

/*
 * Email optional-dır.
 */
if ($email !== '' && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    jsonResponse([
        'success' => false,
        'message' => 'Email düzgün deyil.'
    ], 422);
}

if ($email === '') {
    $email = null;
}

/*
 * Password
 */
if (!is_string($password) || $password === '') {
    jsonResponse([
        'success' => false,
        'message' => 'Password tələb olunur.'
    ], 422);
}

if (strlen($password) < 6) {
    jsonResponse([
        'success' => false,
        'message' => 'Password ən azı 6 simvol olmalıdır.'
    ], 422);
}

try {

    /*
     * Username artıq istifadə olunub?
     */
    $stmt = $pdo->prepare("
        SELECT id
        FROM users
        WHERE username = ?
        LIMIT 1
    ");

    $stmt->execute([$username]);

    if ($stmt->fetch()) {
        jsonResponse([
            'success' => false,
            'message' => 'Bu username artıq istifadə olunur.'
        ], 409);
    }

    /*
     * Email verilibsə, onun da unikal olmasını yoxlayırıq.
     */
    if ($email !== null) {

        $stmt = $pdo->prepare("
            SELECT id
            FROM users
            WHERE email = ?
            LIMIT 1
        ");

        $stmt->execute([$email]);

        if ($stmt->fetch()) {
            jsonResponse([
                'success' => false,
                'message' => 'Bu email artıq istifadə olunur.'
            ], 409);
        }
    }

    /*
     * Password heç vaxt plaintext saxlanılmır.
     */
    $passwordHash = password_hash(
        $password,
        PASSWORD_DEFAULT
    );

    $pdo->beginTransaction();

    /*
     * User
     */
    $stmt = $pdo->prepare("
        INSERT INTO users
            (username, email, password_hash)
        VALUES
            (?, ?, ?)
    ");

    $stmt->execute([
        $username,
        $email,
        $passwordHash
    ]);

    $userId = (int) $pdo->lastInsertId();

    /*
     * Hər user üçün settings sətri yaradırıq.
     */
    $stmt = $pdo->prepare("
        INSERT INTO user_settings
            (user_id)
        VALUES
            (?)
    ");

    $stmt->execute([$userId]);

    $pdo->commit();

    /*
     * Qeydiyyatdan sonra avtomatik login.
     */
    session_regenerate_id(true);

    $_SESSION['user_id'] = $userId;

    jsonResponse([
        'success' => true,
        'message' => 'Qeydiyyat uğurla tamamlandı.',
        'user' => [
            'id' => $userId,
            'username' => $username,
            'email' => $email
        ]
    ], 201);

} catch (Throwable $e) {

    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Qeydiyyat zamanı xəta baş verdi.'
    ], 500);
}