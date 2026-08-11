<?php

declare(strict_types=1);

require_once '../../config/database.php';
require_once '../../inc/response.php';
require_once '../../inc/auth.php';

$userId = requireAuth();

try {

    $stmt = $pdo->prepare("
        SELECT
            id,
            username,
            email,
            created_at
        FROM users
        WHERE id = ?
        LIMIT 1
    ");

    $stmt->execute([$userId]);

    $user = $stmt->fetch();

    if (!$user) {
        session_unset();
        session_destroy();

        jsonResponse([
            'success' => false,
            'message' => 'İstifadəçi tapılmadı.'
        ], 401);
    }

    jsonResponse([
        'success' => true,
        'data' => [
            'id' => (int) $user['id'],
            'username' => $user['username'],
            'email' => $user['email'],
            'created_at' => $user['created_at']
        ]
    ]);

} catch (Throwable $e) {

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'İstifadəçi məlumatını almaq mümkün olmadı.'
    ], 500);
}