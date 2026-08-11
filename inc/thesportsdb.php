<?php

declare(strict_types=1);

require_once __DIR__ . '/../config/config.php';

function sportsDbRequest(
    string $endpoint,
    array $params = []
): array {

    $url = THESPORTSDB_BASE_URL
        . rawurlencode(THESPORTSDB_API_KEY)
        . '/'
        . ltrim($endpoint, '/');

    if ($params) {
        $url .= '?' . http_build_query($params);
    }

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
        throw new RuntimeException(
            'TheSportsDB sorğusu uğursuz oldu.'
        );
    }

    $data = json_decode($response, true);

    if (!is_array($data)) {
        throw new RuntimeException(
            'TheSportsDB düzgün JSON qaytarmadı.'
        );
    }

    return $data;
}