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

if (!is_array($input)) {
    jsonResponse([
        'success' => false,
        'message' => 'Yanlış sorğu məlumatı.'
    ], 422);
}

$gameId = (int) ($input['game_id'] ?? 0);

if ($gameId <= 0) {
    jsonResponse([
        'success' => false,
        'message' => 'Oyun tapılmadı.'
    ], 422);
}

try {
    $pdo->beginTransaction();

    $stmt = $pdo->prepare("
        SELECT
            id,
            finished_at
        FROM games
        WHERE id = ?
          AND user_id = ?
        FOR UPDATE
    ");

    $stmt->execute([
        $gameId,
        $userId
    ]);

    $game = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$game) {
        throw new RuntimeException('Oyun tapılmadı.');
    }

    if ($game['finished_at'] !== null) {
        throw new RuntimeException('Bu oyun artıq tamamlanıb.');
    }

    $stmt = $pdo->prepare("
        UPDATE games
        SET total_questions = total_questions + 1
        WHERE id = ?
          AND user_id = ?
    ");

    $stmt->execute([
        $gameId,
        $userId
    ]);

    $stmt = $pdo->prepare("
        SELECT
            total_questions,
            correct,
            wrong,
            skipped,
            score
        FROM games
        WHERE id = ?
    ");

    $stmt->execute([$gameId]);

    $stats = $stmt->fetch(PDO::FETCH_ASSOC);

    $pdo->commit();

    jsonResponse([
        'success' => true,
        'data' => [
            'game_id' => $gameId,
            'total_questions' => (int) $stats['total_questions'],
            'correct' => (int) $stats['correct'],
            'wrong' => (int) $stats['wrong'],
            'skipped' => (int) $stats['skipped'],
            'game_score' => (int) $stats['score']
        ]
    ]);

} catch (Throwable $e) {

    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => $e->getMessage()
    ], 400);
}