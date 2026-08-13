<?php

declare(strict_types=1);

require_once '../../inc/response.php';
require_once '../../inc/thesportsdb.php';

$endpoint = trim($_GET['endpoint'] ?? '');

if ($endpoint === '') {
    jsonResponse([
        'success' => false,
        'message' => 'Endpoint göstərilməyib.'
    ], 400);
}

/*
 * Yalnız oyunda istifadə etdiyimiz endpoint-lərə icazə veririk.
 *
 * İstənilən URL-i proxy etmək olmaz.
 */
$allowedEndpoints = [
    'search_all_leagues.php',
    'lookuptable.php',
    'search_all_teams.php',
    'searchplayers.php',
    'lookupformerteams.php',
    'lookup_all_players.php',
    'list_league_teams.php',
];

if (!in_array($endpoint, $allowedEndpoints, true)) {
    jsonResponse([
        'success' => false,
        'message' => 'Bu football endpoint-ə icazə verilmir.'
    ], 403);
}

/*
 * endpoint parametrini TheSportsDB sorğusuna daxil etmirik.
 * Yalnız konkret endpoint üçün lazım olan parametrləri ötürürük.
 */
$params = $_GET;

unset($params['endpoint']);

/*
 * TheSportsDB v2:
 * Liqanın ID-si ilə bütün komandaları götürürük.
 */
if ($endpoint === 'list_league_teams.php') {

    $leagueId = (int) ($_GET['league_id'] ?? 0);

    if ($leagueId <= 0) {
        jsonResponse([
            'success' => false,
            'message' => 'League ID düzgün göstərilməyib.'
        ], 400);
    }

    $url = 'https://www.thesportsdb.com/api/v2/json/list/teams/'
        . $leagueId;

    $context = stream_context_create([
        'http' => [
            'method' => 'GET',
            'timeout' => 10,
            'ignore_errors' => true,
            'header' => [
                'Accept: application/json',
                'User-Agent: Ofsayd/1.0'
            ]
        ]
    ]);

    $response = @file_get_contents($url, false, $context);

    if ($response === false) {
        jsonResponse([
            'success' => false,
            'message' => 'TheSportsDB sorğusu uğursuz oldu.'
        ], 502);
    }

    $data = json_decode($response, true);

    if (!is_array($data)) {
        jsonResponse([
            'success' => false,
            'message' => 'TheSportsDB düzgün JSON qaytarmadı.'
        ], 502);
    }

    jsonResponse($data);
}

try {

    $data = sportsDbRequest(
        $endpoint,
        $params
    );

    jsonResponse($data);

} catch (Throwable $e) {

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Football API sorğusu uğursuz oldu.'
    ], 502);
}