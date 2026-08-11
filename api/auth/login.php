<?php

declare(strict_types=1);

require_once '../../config/database.php';
require_once '../../inc/response.php';
require_once '../../inc/auth.php';

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

$login = trim((string) ($input['login'] ?? ''));
$password = (string) ($input['password'] ?? '');

if ($login === '') {
    jsonResponse([
        'success' => false,
        'message' => 'Username və ya email daxil edin.'
    ], 422);
}

if ($password === '') {
    jsonResponse([
        'success' => false,
        'message' => 'Şifrə daxil edin.'
    ], 422);
}

try {

    $stmt = $pdo->prepare("
        SELECT
            id,
            username,
            email,
            password_hash
        FROM users
        WHERE username = ?
           OR email = ?
        LIMIT 1
    ");

    $stmt->execute([
        $login,
        $login
    ]);

    $user = $stmt->fetch();

    if (!$user || empty($user['password_hash'])) {
        jsonResponse([
            'success' => false,
            'message' => 'İstifadəçi adı və ya şifrə yanlışdır.'
        ], 401);
    }

    if (!password_verify($password, $user['password_hash'])) {
        jsonResponse([
            'success' => false,
            'message' => 'İstifadəçi adı və ya şifrə yanlışdır.'
        ], 401);
    }

    /*
     * Session fixation qarşısını alır.
     */
    session_regenerate_id(true);

    $_SESSION['user_id'] = (int) $user['id'];

    jsonResponse([
        'success' => true,
        'data' => [
            'id' => (int) $user['id'],
            'username' => $user['username'],
            'email' => $user['email']
        ]
    ]);

} catch (Throwable $e) {

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Login zamanı xəta baş verdi.'
    ], 500);
}