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

$userId = requireAuth();

$input = json_decode(file_get_contents('php://input'), true);
$mode = is_array($input) ? ($input['mode'] ?? '') : '';

if (!in_array($mode, ['country-club', 'club-club'], true)) {
    jsonResponse([
        'success' => false,
        'message' => 'Oyun rejimi yanlışdır.'
    ], 422);
}

try {
    $stmt = $pdo->prepare("
    SELECT id, mode
    FROM games
    WHERE user_id = ?
      AND finished_at IS NULL
    LIMIT 1
");

    $stmt->execute([$userId]);

    $game = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($game) {
        if ($game['mode'] !== $mode) {
            jsonResponse([
                'success' => false,
                'message' => 'Hazırda başqa oyun davam edir.'
            ], 409);
        }

        jsonResponse([
            'success' => true,
            'data' => [
                'game_id' => (int) $game['id']
            ]
        ]);
    }

    $stmt = $pdo->prepare("
        INSERT INTO games (user_id, mode)
        VALUES (?, ?)
    ");

    $stmt->execute([$userId, $mode]);

    jsonResponse([
        'success' => true,
        'data' => [
            'game_id' => (int) $pdo->lastInsertId()
        ]
    ]);

} catch (Throwable $e) {

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Oyun başlatmaq mümkün olmadı.'
    ], 500);
}