<?php

declare(strict_types=1);

require_once __DIR__ . '/config/database.php';

$apiKey = '123';

$stmt = $pdo->query("
    SELECT id, api_id, name
    FROM leagues
    WHERE is_active = 1
      AND api_id IS NOT NULL
      AND api_id != ''
");

$leagues = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo "Tapılan liqa sayı: " . count($leagues) . PHP_EOL;
echo str_repeat('-', 60) . PHP_EOL;

$update = $pdo->prepare("
    UPDATE leagues
    SET banner = :banner
    WHERE id = :id
");

foreach ($leagues as $league) {

    $url = "https://www.thesportsdb.com/api/v1/json/{$apiKey}/lookup_league.php?id="
        . urlencode((string)$league['api_id']);

    echo "→ {$league['name']} ";

    $ch = curl_init($url);

    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 15,
        CURLOPT_CONNECTTIMEOUT => 5,
        CURLOPT_HTTPHEADER => [
            'Accept: application/json'
        ],
    ]);

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    if ($response === false) {
        echo "❌ CURL xətası: " . curl_error($ch) . PHP_EOL;
        curl_close($ch);
        continue;
    }

    curl_close($ch);

    if ($httpCode !== 200) {
        echo "❌ HTTP {$httpCode}" . PHP_EOL;
        continue;
    }

    $data = json_decode($response, true);

    if (!is_array($data)) {
        echo "❌ JSON xətası" . PHP_EOL;
        continue;
    }

    $apiLeague = $data['leagues'][0] ?? null;

    if (!$apiLeague) {
        echo "⚠️ Liqa tapılmadı" . PHP_EOL;
        continue;
    }

    $banner = trim((string)($apiLeague['strBanner'] ?? ''));

    if ($banner === '') {
        echo "⚠️ strBanner yoxdur" . PHP_EOL;
        continue;
    }

    $update->execute([
        ':banner' => $banner,
        ':id' => $league['id'],
    ]);

    echo "✅ {$banner}" . PHP_EOL;
}

echo str_repeat('-', 60) . PHP_EOL;
echo "Hazırdır." . PHP_EOL;