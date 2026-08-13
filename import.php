<?php

declare(strict_types=1);

require_once './config/database.php';

$jsonFile = __DIR__ . '/laliga.json';

if (!file_exists($jsonFile)) {
    die('JSON faylı tapılmadı.');
}

$data = json_decode(
    file_get_contents($jsonFile),
    true
);

if (!is_array($data)) {
    die('JSON düzgün deyil.');
}

$pdo->beginTransaction();

try {

    $stmt = $pdo->prepare("
        INSERT INTO league_teams (
            league_id,
            team_api_id,
            team_name,
            team_badge
        )
        VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            team_name = VALUES(team_name),
            team_badge = VALUES(team_badge),
            is_active = 1
    ");

    $count = 0;

    foreach ($data as $team) {

        $leagueId  = (int) ($team['league_id'] ?? 0);
        $teamApiId = (int) ($team['team_api_id'] ?? 0);
        $teamName  = trim($team['team_name'] ?? '');
        $teamBadge = trim($team['team_badge'] ?? '');

        if (
            $leagueId <= 0 ||
            $teamApiId <= 0 ||
            $teamName === ''
        ) {
            continue;
        }

        $stmt->execute([
            $leagueId,
            $teamApiId,
            $teamName,
            $teamBadge !== '' ? $teamBadge : null
        ]);

        $count++;
    }

    $pdo->commit();

    echo "Import tamamlandı. {$count} komanda emal edildi.";

} catch (Throwable $e) {

    $pdo->rollBack();

    echo 'Xəta: ' . $e->getMessage();
}