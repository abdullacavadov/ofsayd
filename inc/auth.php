<?php

declare(strict_types=1);

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start([
        'cookie_httponly' => true,
        'cookie_samesite' => 'Lax',
        'cookie_secure'   => !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off',
    ]);
}

/**
 * Hazırda login olmuş istifadəçinin ID-sini qaytarır.
 */
function getCurrentUserId(): ?int
{
    if (empty($_SESSION['user_id'])) {
        return null;
    }

    return (int) $_SESSION['user_id'];
}

/**
 * Login tələb edən endpoint-lər üçün.
 */
function requireAuth(): int
{
    $userId = getCurrentUserId();

    if ($userId === null || $userId <= 0) {
        require_once __DIR__ . '/response.php';

        jsonResponse([
            'success' => false,
            'message' => 'Giriş tələb olunur.'
        ], 401);
    }

    return $userId;
}