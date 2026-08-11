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
$gameId = is_array($input) ? (int) ($input['game_id'] ?? 0) : 0;

if ($gameId <= 0) {
    jsonResponse([
        'success' => false,
        'message' => 'Oyun tapılmadı.'
    ], 422);
}

try {
    $stmt = $pdo->prepare("
        UPDATE games
        SET finished_at = CURRENT_TIMESTAMP
        WHERE id = ?
          AND user_id = ?
          AND finished_at IS NULL
    ");

    $stmt->execute([$gameId, $userId]);

    if ($stmt->rowCount() === 0) {
        $stmt = $pdo->prepare("
            SELECT id
            FROM games
            WHERE id = ?
              AND user_id = ?
              AND finished_at IS NOT NULL
        ");

        $stmt->execute([$gameId, $userId]);

        if (!$stmt->fetch()) {
            jsonResponse([
                'success' => false,
                'message' => 'Oyun tapılmadı.'
            ], 404);
        }
    }

    $stmt = $pdo->prepare("
        SELECT
            total_questions,
            correct,
            wrong,
            score,
            finished_at
        FROM games
        WHERE id = ?
          AND user_id = ?
    ");

    $stmt->execute([$gameId, $userId]);
    $game = $stmt->fetch();

    jsonResponse([
        'success' => true,
        'data' => [
            'game_id' => $gameId,
            'total_questions' => (int) $game['total_questions'],
            'correct' => (int) $game['correct'],
            'wrong' => (int) $game['wrong'],
            'score' => (int) $game['score'],
            'finished_at' => $game['finished_at']
        ]
    ]);

} catch (Throwable $e) {

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Oyun tamamlanmadı.'
    ], 500);
}