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
    'lookupformerteams.php'
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