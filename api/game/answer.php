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
$questionType = $input['question_type'] ?? '';
$sideA = trim((string) ($input['side_a'] ?? ''));
$sideB = trim((string) ($input['side_b'] ?? ''));
$sideAId = (int) ($input['side_a_id'] ?? 0);
$sideBId = (int) ($input['side_b_id'] ?? 0);
$playerId = isset($input['player_id']) ? (int) $input['player_id'] : null;
$playerAnswer = trim((string) ($input['player_answer'] ?? ''));
$correctPlayer = trim((string) ($input['correct_player'] ?? ''));
$isCorrect = !empty($input['is_correct']) ? 1 : 0;
$points = (int) ($input['points'] ?? 0);

if ($gameId <= 0) {
    jsonResponse([
        'success' => false,
        'message' => 'Oyun tapılmadı.'
    ], 422);
}

if (!in_array($questionType, ['country-club', 'club-club'], true)) {
    jsonResponse([
        'success' => false,
        'message' => 'Sual tipi yanlışdır.'
    ], 422);
}

if ($sideA === '' || $sideB === '' || $sideAId <= 0 || $sideBId <= 0) {
    jsonResponse([
        'success' => false,
        'message' => 'Sual məlumatları tam deyil.'
    ], 422);
}

if ($points < 0) {
    $points = 0;
}

try {
    $pdo->beginTransaction();

    $stmt = $pdo->prepare("
        SELECT id, mode, finished_at
        FROM games
        WHERE id = ?
          AND user_id = ?
        FOR UPDATE
    ");

    $stmt->execute([$gameId, $userId]);
    $game = $stmt->fetch();

    if (!$game) {
        throw new RuntimeException('Oyun tapılmadı.');
    }

    if ($game['finished_at'] !== null) {
        throw new RuntimeException('Bu oyun artıq tamamlanıb.');
    }

    if ($game['mode'] !== $questionType) {
        throw new RuntimeException('Sual tipi oyun rejiminə uyğun deyil.');
    }

    $stmt = $pdo->prepare("
        INSERT INTO game_answers (
            user_id,
            game_id,
            question_type,
            side_a,
            side_b,
            side_a_id,
            side_b_id,
            player_id,
            player_answer,
            correct_player,
            is_correct,
            points
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ");

    $stmt->execute([
        $userId,
        $gameId,
        $questionType,
        $sideA,
        $sideB,
        $sideAId,
        $sideBId,
        $playerId ?: null,
        $playerAnswer !== '' ? $playerAnswer : null,
        $correctPlayer !== '' ? $correctPlayer : null,
        $isCorrect,
        $points
    ]);

    $stmt = $pdo->prepare("
        UPDATE games
        SET
            total_questions = total_questions + 1,
            correct = correct + ?,
            wrong = wrong + ?,
            score = score + ?
        WHERE id = ?
    ");

    $stmt->execute([
        $isCorrect ? 1 : 0,
        $isCorrect ? 0 : 1,
        $points,
        $gameId
    ]);

    $stmt = $pdo->prepare("
        SELECT
            total_questions,
            correct,
            wrong,
            score
        FROM games
        WHERE id = ?
    ");

    $stmt->execute([$gameId]);
    $score = $stmt->fetch();

    $pdo->commit();

    jsonResponse([
        'success' => true,
        'data' => [
            'game_id' => $gameId,
            'total_questions' => (int) $score['total_questions'],
            'correct' => (int) $score['correct'],
            'wrong' => (int) $score['wrong'],
            'score' => (int) $score['score']
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