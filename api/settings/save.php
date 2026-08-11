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

$input = json_decode(
    file_get_contents('php://input'),
    true
);

if (!is_array($input)) {
    jsonResponse([
        'success' => false,
        'message' => 'Yanlış request formatı.'
    ], 400);
}

$clubCountries = $input['clubCountries'] ?? [];
$nationalTeams = $input['nationalTeams'] ?? [];

$leaguesProvided = array_key_exists('leagues', $input);
$leagues = $leaguesProvided ? $input['leagues'] : null;

if (
    !is_array($clubCountries) ||
    !is_array($nationalTeams) ||
    ($leaguesProvided && !is_array($leagues))
) {
    jsonResponse([
        'success' => false,
        'message' => 'Settings formatı yanlışdır.'
    ], 422);
}

/*
 * ID-ləri integer-ə çeviririk.
 * Eyni ID-ləri təkrarlamaq mənasızdır.
 */
$clubCountries = array_values(
    array_unique(
        array_map('intval', $clubCountries)
    )
);

$nationalTeams = array_values(
    array_unique(
        array_map('intval', $nationalTeams)
    )
);

if ($leaguesProvided) {
    $leagues = array_values(
        array_unique(
            array_map('intval', $leagues)
        )
    );
}

/*
 * 0 və mənfi ID-ləri silirik.
 */
$clubCountries = array_values(
    array_filter(
        $clubCountries,
        fn(int $id): bool => $id > 0
    )
);

$nationalTeams = array_values(
    array_filter(
        $nationalTeams,
        fn(int $id): bool => $id > 0
    )
);

if ($leaguesProvided) {
    $leagues = array_values(
        array_filter(
            $leagues,
            fn(int $id): bool => $id > 0
        )
    );
}

try {

    $pdo->beginTransaction();

    /*
     * Əvvəl mövcud settings-ləri silirik.
     */

    $stmt = $pdo->prepare("
        DELETE FROM user_setting_club_countries
        WHERE user_id = ?
    ");

    $stmt->execute([$userId]);

    $stmt = $pdo->prepare("
        DELETE FROM user_setting_national_teams
        WHERE user_id = ?
    ");

    $stmt->execute([$userId]);

    if ($leaguesProvided) {
        $stmt = $pdo->prepare("
            DELETE FROM user_setting_leagues
            WHERE user_id = ?
        ");

        $stmt->execute([$userId]);
    }


    /*
     * Klub ölkələri
     */

    if ($clubCountries) {

        $stmt = $pdo->prepare("
            INSERT INTO user_setting_club_countries
                (user_id, country_id)
            VALUES
                (?, ?)
        ");

        foreach ($clubCountries as $countryId) {
            $stmt->execute([
                $userId,
                $countryId
            ]);
        }
    }


    /*
     * Milli komandalar
     */

    if ($nationalTeams) {

        $stmt = $pdo->prepare("
            INSERT INTO user_setting_national_teams
                (user_id, country_id)
            VALUES
                (?, ?)
        ");

        foreach ($nationalTeams as $countryId) {
            $stmt->execute([
                $userId,
                $countryId
            ]);
        }
    }


    /*
     * Liqalar
     */

    if ($leagues) {

        $stmt = $pdo->prepare("
            INSERT INTO user_setting_leagues
                (user_id, league_id)
            VALUES
                (?, ?)
        ");

        foreach ($leagues as $leagueId) {
            $stmt->execute([
                $userId,
                $leagueId
            ]);
        }
    }

    $pdo->commit();

    jsonResponse([
        'success' => true,
        'message' => 'Settings yadda saxlanıldı.'
    ]);

} catch (Throwable $e) {

    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }

    error_log($e->getMessage());

    jsonResponse([
        'success' => false,
        'message' => 'Settings yadda saxlanılarkən xəta baş verdi.'
    ], 500);
}