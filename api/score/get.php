<?php

declare(strict_types=1);

require_once '../../config/database.php';
require_once '../../inc/response.php';
require_once '../../inc/auth.php';

$userId = requireAuth();

try {
    $stmt = $pdo->prepare("
        SELECT
            COALESCE(SUM(score), 0) AS total,
            COALESCE(SUM(correct), 0) AS correct,
            COALESCE(SUM(wrong), 0) AS wrong
        FROM games
        WHERE user_id = ?
          AND finished_at IS NOT NULL
    ");

    $stmt->execute([$userId]);
    $score = $stmt->fetch();

    jsonResponse([
        'success' => true,
        'data' => [
            'total' => (int) $score['total'],
            'correct' => (int) $score['correct'],
            'wrong' => (int) $score['wrong']
        ]
    ]);

} catch (Throwable $e) {

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Xallar yüklənmədi.'
    ], 500);
}