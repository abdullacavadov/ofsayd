<?php

declare(strict_types=1);

require_once '../../config/database.php';
require_once '../../inc/response.php';
require_once '../../inc/auth.php';

$userId = requireAuth();

try {
    /*
     * İstifadəçinin bütün oyunlar üzrə ümumi xalı.
     *
     * game_answers əsas mənbədir.
     * Oyun bitmiş və ya davam edən olmasından asılı deyil.
     */
    $stmt = $pdo->prepare("
        SELECT
            COALESCE(SUM(points), 0) AS total
        FROM game_answers
        WHERE user_id = ?
    ");

    $stmt->execute([$userId]);

    $totalScore = (int) $stmt->fetchColumn();

    /*
     * Davam edən oyun.
     */
    $stmt = $pdo->prepare("
        SELECT
            id,
            total_questions,
            correct,
            wrong,
            score
        FROM games
        WHERE user_id = ?
          AND finished_at IS NULL
        ORDER BY id DESC
        LIMIT 1
    ");

    $stmt->execute([$userId]);

    $game = $stmt->fetch(PDO::FETCH_ASSOC);

    jsonResponse([
        'success' => true,
        'data' => [
            'total_score' => $totalScore,

            'game' => $game ? [
                'game_id' => (int) $game['id'],
                'total_questions' => (int) $game['total_questions'],
                'correct' => (int) $game['correct'],
                'wrong' => (int) $game['wrong'],
                'game_score' => (int) $game['score']
            ] : null
        ]
    ]);

} catch (Throwable $e) {

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Xallar yüklənmədi.'
    ], 500);
}