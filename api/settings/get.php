<?php

declare(strict_types=1);

require_once '../../config/database.php';
require_once '../../inc/response.php';
require_once '../../inc/auth.php';

$userId = requireAuth();

try {
    //Bütün ölkələr
    $stmt = $pdo->query("
        SELECT
            id,
            api_key,
            name_az,
            flag
        FROM countries
        WHERE is_active = 1
        ORDER BY name_az
    ");

    $countries = $stmt->fetchAll();



    // Klub ölkələri
    $stmt = $pdo->prepare("
        SELECT
            c.id,
            c.api_key,
            c.name_az,
            c.flag
        FROM user_setting_club_countries usc
        INNER JOIN countries c
            ON c.id = usc.country_id
        WHERE usc.user_id = ?
          AND c.is_active = 1
        ORDER BY c.name_az
    ");

    $stmt->execute([$userId]);

    $clubCountries = $stmt->fetchAll();

    // Milli komandalar
    $stmt = $pdo->prepare("
        SELECT
            c.id,
            c.api_key,
            c.name_az,
            c.flag
        FROM user_setting_national_teams usn
        INNER JOIN countries c
            ON c.id = usn.country_id
        WHERE usn.user_id = ?
          AND c.is_active = 1
        ORDER BY c.name_az
    ");

    $stmt->execute([$userId]);

    $nationalTeams = $stmt->fetchAll();

    // Liqalar
    $stmt = $pdo->prepare("
        SELECT
            l.id,
            l.country_id,
            l.api_id,
            l.name,
            l.name_az,
            l.sport
        FROM user_setting_leagues usl
        INNER JOIN leagues l
            ON l.id = usl.league_id
        WHERE usl.user_id = ?
          AND l.is_active = 1
        ORDER BY l.name_az
    ");

    $stmt->execute([$userId]);

    $leagues = $stmt->fetchAll();

    jsonResponse([
        'success' => true,
        'data' => [
            'countries' => $countries,
            'clubCountries' => $clubCountries,
            'nationalTeams' => $nationalTeams,
            'leagues' => $leagues
        ]
    ]);

} catch (Throwable $e) {

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Settings məlumatlarını almaq mümkün olmadı.'
    ], 500);
}