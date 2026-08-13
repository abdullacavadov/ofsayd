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
// Yalnız ən azı bir aktiv liqası və həmin liqada ən azı bir aktiv klubu olan ölkələr

    $stmt = $pdo->query("
    SELECT DISTINCT
        c.id,
        c.api_key,
        c.name_az,
        c.flag
    FROM countries c
    INNER JOIN leagues l
        ON l.country_id = c.id
    INNER JOIN league_teams lt
        ON lt.league_id = l.id
    WHERE c.is_active = 1
      AND l.is_active = 1
      AND lt.is_active = 1
    ORDER BY c.name_az
");

    $clubCountries = $stmt->fetchAll();



    $stmt = $pdo->prepare("
    SELECT country_id
    FROM user_setting_club_countries
    WHERE user_id = ?
");

    $stmt->execute([$userId]);

    $selectedClubCountries = array_map(
        'intval',
        array_column($stmt->fetchAll(), 'country_id')
    );

    // Milli komandalar
// Bütün aktiv ölkələr

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

    $nationalTeams = $stmt->fetchAll();


    $stmt = $pdo->prepare("
    SELECT country_id
    FROM user_setting_national_teams
    WHERE user_id = ?
");

    $stmt->execute([$userId]);

    $selectedNationalTeams = array_map(
        'intval',
        array_column($stmt->fetchAll(), 'country_id')
    );

    // Liqalar
    // Bütün aktiv liqalar
    $stmt = $pdo->query("
    SELECT
        l.id,
        l.country_id,
        l.api_id,
        l.name,
        l.name_az,
        l.sport,
        l.banner,
        l.is_top_tier,
        l.is_active
    FROM leagues l
    WHERE l.is_active = 1
    ORDER BY l.country_id, l.name
");

    $leagues = $stmt->fetchAll();



    $stmt = $pdo->prepare("
    SELECT league_id
    FROM user_setting_leagues
    WHERE user_id = ?
");

    $stmt->execute([$userId]);

    $selectedLeagues = array_map(
        'intval',
        array_column($stmt->fetchAll(), 'league_id')
    );

    jsonResponse([
        'success' => true,
        'data' => [
            'countries' => $countries,

            'clubCountries' => $clubCountries,
            'selectedClubCountries' => $selectedClubCountries,

            'nationalTeams' => $nationalTeams,
            'selectedNationalTeams' => $selectedNationalTeams,

            'leagues' => $leagues,
            'selectedLeagues' => $selectedLeagues
        ]
    ]);

} catch (Throwable $e) {

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Tənzimləmələri almaq mümkün olmadı.'
    ], 500);
}