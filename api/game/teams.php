<?php

declare(strict_types=1);

require_once '../../config/database.php';
require_once '../../inc/response.php';
require_once '../../inc/auth.php';

$userId = requireAuth();

try {

    /*
     * İstifadəçinin seçdiyi aktiv liqalar
     */
    $stmt = $pdo->prepare("
        SELECT
            l.id,
            l.name,
            l.name_az
        FROM user_setting_leagues usl
        INNER JOIN leagues l
            ON l.id = usl.league_id
        WHERE usl.user_id = ?
          AND l.is_active = 1
        ORDER BY l.name
    ");

    $stmt->execute([$userId]);

    $leagues = $stmt->fetchAll();

    if (!$leagues) {
        jsonResponse([
            'success' => true,
            'data' => []
        ]);
    }


    /*
     * Seçilmiş liqaların ID-ləri
     */
    $leagueIds = array_map(
        'intval',
        array_column($leagues, 'id')
    );


    $placeholders = implode(
        ',',
        array_fill(0, count($leagueIds), '?')
    );


    /*
     * Seçilmiş liqalardakı bütün aktiv klublar
     */
    $stmt = $pdo->prepare("
        SELECT
            lt.id,
            lt.league_id,
            lt.team_api_id,
            lt.team_name,
            lt.team_badge
        FROM league_teams lt
        WHERE lt.league_id IN ($placeholders)
          AND lt.is_active = 1
        ORDER BY lt.league_id, lt.team_name
    ");

    $stmt->execute($leagueIds);

    $teams = $stmt->fetchAll();


    jsonResponse([
        'success' => true,
        'data' => $teams
    ]);

} catch (Throwable $e) {

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Klub məlumatlarını almaq mümkün olmadı.'
    ], 500);
}