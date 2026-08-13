-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Авг 13 2026 г., 10:06
-- Версия сервера: 10.4.28-MariaDB
-- Версия PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `ofsayd`
--

-- --------------------------------------------------------

--
-- Структура таблицы `countries`
--

CREATE TABLE `countries` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `api_key` varchar(100) NOT NULL,
  `name_az` varchar(100) NOT NULL,
  `flag` varchar(30) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `countries`
--

INSERT INTO `countries` (`id`, `api_key`, `name_az`, `flag`, `is_active`, `created_at`) VALUES
(1, 'Algeria', 'Əlcəzair', 'dz', 1, '2026-08-11 09:13:49'),
(2, 'Angola', 'Anqola', 'ao', 1, '2026-08-11 09:13:49'),
(3, 'Benin', 'Benin', 'bj', 1, '2026-08-11 09:13:49'),
(4, 'Botswana', 'Botsvana', 'bw', 1, '2026-08-11 09:13:49'),
(5, 'Burkina Faso', 'Burkina-Faso', 'bf', 1, '2026-08-11 09:13:49'),
(6, 'Burundi', 'Burundi', 'bi', 1, '2026-08-11 09:13:49'),
(13, 'DR Congo', 'Konqo Demokratik Respublikası', 'cd', 1, '2026-08-11 09:13:49'),
(14, 'Ivory Coast', 'Kot-d\'İvuar', 'ci', 1, '2026-08-11 09:13:49'),
(16, 'Egypt', 'Misir', 'eg', 1, '2026-08-11 09:13:49'),
(20, 'Ethiopia', 'Efiopiya', 'et', 1, '2026-08-11 09:13:49'),
(22, 'Gambia', 'Qambiya', 'gm', 1, '2026-08-11 09:13:49'),
(23, 'Ghana', 'Qana', 'gh', 1, '2026-08-11 09:13:49'),
(24, 'Guinea', 'Qvineya', 'gn', 1, '2026-08-11 09:13:49'),
(26, 'Kenya', 'Keniya', 'ke', 1, '2026-08-11 09:13:49'),
(28, 'Liberia', 'Liberiya', 'lr', 1, '2026-08-11 09:13:49'),
(29, 'Libya', 'Liviya', 'ly', 1, '2026-08-11 09:13:49'),
(33, 'Mauritania', 'Mavritaniya', 'mr', 1, '2026-08-11 09:13:49'),
(35, 'Morocco', 'Mərakeş', 'ma', 1, '2026-08-11 09:13:49'),
(39, 'Nigeria', 'Nigeriya', 'ng', 1, '2026-08-11 09:13:49'),
(40, 'Rwanda', 'Ruanda', 'rw', 1, '2026-08-11 09:13:49'),
(42, 'Senegal', 'Seneqal', 'sn', 1, '2026-08-11 09:13:49'),
(45, 'Somalia', 'Somali', 'so', 1, '2026-08-11 09:13:49'),
(46, 'South Africa', 'Cənubi Afrika Respublikası', 'za', 1, '2026-08-11 09:13:49'),
(48, 'Sudan', 'Sudan', 'sd', 1, '2026-08-11 09:13:49'),
(51, 'Tunisia', 'Tunis', 'tn', 1, '2026-08-11 09:13:49'),
(52, 'Uganda', 'Uqanda', 'ug', 1, '2026-08-11 09:13:49'),
(53, 'Zambia', 'Zambiya', 'zm', 1, '2026-08-11 09:13:49'),
(54, 'Zimbabwe', 'Zimbabve', 'zw', 1, '2026-08-11 09:13:49'),
(56, 'Armenia', 'Ermənistan', 'am', 1, '2026-08-11 09:13:49'),
(57, 'Azerbaijan', 'Azərbaycan', 'az', 1, '2026-08-11 09:13:49'),
(58, 'Bahrain', 'Bəhreyn', 'bh', 1, '2026-08-11 09:13:49'),
(59, 'Bangladesh', 'Banqladeş', 'bd', 1, '2026-08-11 09:13:49'),
(60, 'Bhutan', 'Butan', 'bt', 1, '2026-08-11 09:13:49'),
(62, 'Cambodia', 'Kamboca', 'kh', 1, '2026-08-11 09:13:49'),
(63, 'China', 'Çin', 'cn', 1, '2026-08-11 09:13:49'),
(64, 'Cyprus', 'Kipr', 'cy', 1, '2026-08-11 09:13:49'),
(65, 'Georgia', 'Gürcüstan', 'ge', 1, '2026-08-11 09:13:49'),
(66, 'India', 'Hindistan', 'in', 1, '2026-08-11 09:13:49'),
(67, 'Indonesia', 'İndoneziya', 'id', 1, '2026-08-11 09:13:49'),
(68, 'Iran', 'İran', 'ir', 1, '2026-08-11 09:13:49'),
(69, 'Iraq', 'İraq', 'iq', 1, '2026-08-11 09:13:49'),
(70, 'Israel', 'İsrail', 'il', 1, '2026-08-11 09:13:49'),
(71, 'Japan', 'Yaponiya', 'jp', 1, '2026-08-11 09:13:49'),
(72, 'Jordan', 'İordaniya', 'jo', 1, '2026-08-11 09:13:49'),
(73, 'Kazakhstan', 'Qazaxıstan', 'kz', 1, '2026-08-11 09:13:49'),
(74, 'Kuwait', 'Küveyt', 'kw', 1, '2026-08-11 09:13:49'),
(75, 'Kyrgyzstan', 'Qırğızıstan', 'kg', 1, '2026-08-11 09:13:49'),
(76, 'Laos', 'Laos', 'la', 1, '2026-08-11 09:13:49'),
(77, 'Lebanon', 'Livan', 'lb', 1, '2026-08-11 09:13:49'),
(78, 'Malaysia', 'Malayziya', 'my', 1, '2026-08-11 09:13:49'),
(79, 'Maldives', 'Maldiv adaları', 'mv', 1, '2026-08-11 09:13:49'),
(80, 'Mongolia', 'Monqolustan', 'mn', 1, '2026-08-11 09:13:49'),
(81, 'Myanmar', 'Myanma', 'mm', 1, '2026-08-11 09:13:49'),
(82, 'Nepal', 'Nepal', 'np', 1, '2026-08-11 09:13:49'),
(84, 'Oman', 'Oman', 'om', 1, '2026-08-11 09:13:49'),
(85, 'Pakistan', 'Pakistan', 'pk', 1, '2026-08-11 09:13:49'),
(86, 'Palestine', 'Fələstin', 'ps', 1, '2026-08-11 09:13:49'),
(87, 'Philippines', 'Filippin', 'ph', 1, '2026-08-11 09:13:49'),
(88, 'Qatar', 'Qətər', 'qa', 1, '2026-08-11 09:13:49'),
(89, 'Saudi Arabia', 'Səudiyyə Ərəbistanı', 'sa', 1, '2026-08-11 09:13:49'),
(90, 'Singapore', 'Sinqapur', 'sg', 1, '2026-08-11 09:13:49'),
(91, 'South Korea', 'Cənubi Koreya', 'kr', 1, '2026-08-11 09:13:49'),
(93, 'Syria', 'Suriya', 'sy', 1, '2026-08-11 09:13:49'),
(94, 'Tajikistan', 'Tacikistan', 'tj', 1, '2026-08-11 09:13:49'),
(95, 'Thailand', 'Tailand', 'th', 1, '2026-08-11 09:13:49'),
(97, 'Turkey', 'Türkiyə', 'tr', 1, '2026-08-11 09:13:49'),
(98, 'Turkmenistan', 'Türkmənistan', 'tm', 1, '2026-08-11 09:13:49'),
(99, 'United Arab Emirates', 'Birləşmiş Ərəb Əmirlikləri', 'ae', 1, '2026-08-11 09:13:49'),
(100, 'Uzbekistan', 'Özbəkistan', 'uz', 1, '2026-08-11 09:13:49'),
(101, 'Vietnam', 'Vyetnam', 'vn', 1, '2026-08-11 09:13:49'),
(103, 'Albania', 'Albaniya', 'al', 1, '2026-08-11 09:13:49'),
(104, 'Andorra', 'Andorra', 'ad', 1, '2026-08-11 09:13:49'),
(105, 'Austria', 'Avstriya', 'at', 1, '2026-08-11 09:13:49'),
(106, 'Belarus', 'Belarus', 'by', 1, '2026-08-11 09:13:49'),
(107, 'Belgium', 'Belçika', 'be', 1, '2026-08-11 09:13:49'),
(108, 'Bosnia and Herzegovina', 'Bosniya və Herseqovina', 'ba', 1, '2026-08-11 09:13:49'),
(109, 'Bulgaria', 'Bolqarıstan', 'bg', 1, '2026-08-11 09:13:49'),
(110, 'Croatia', 'Xorvatiya', 'hr', 1, '2026-08-11 09:13:49'),
(111, 'Czech Republic', 'Çexiya', 'cz', 1, '2026-08-11 09:13:49'),
(112, 'Denmark', 'Danimarka', 'dk', 1, '2026-08-11 09:13:49'),
(113, 'Estonia', 'Estoniya', 'ee', 1, '2026-08-11 09:13:49'),
(114, 'Finland', 'Finlandiya', 'fi', 1, '2026-08-11 09:13:49'),
(115, 'France', 'Fransa', 'fr', 1, '2026-08-11 09:13:49'),
(116, 'Germany', 'Almaniya', 'de', 1, '2026-08-11 09:13:49'),
(117, 'Greece', 'Yunanıstan', 'gr', 1, '2026-08-11 09:13:49'),
(118, 'Hungary', 'Macarıstan', 'hu', 1, '2026-08-11 09:13:49'),
(119, 'Iceland', 'İslandiya', 'is', 1, '2026-08-11 09:13:49'),
(120, 'Ireland', 'İrlandiya', 'ie', 1, '2026-08-11 09:13:49'),
(121, 'Italy', 'İtaliya', 'it', 1, '2026-08-11 09:13:49'),
(122, 'Latvia', 'Latviya', 'lv', 1, '2026-08-11 09:13:49'),
(123, 'Liechtenstein', 'Lixtenşteyn', 'li', 1, '2026-08-11 09:13:49'),
(124, 'Lithuania', 'Litva', 'lt', 1, '2026-08-11 09:13:49'),
(125, 'Luxembourg', 'Lüksemburq', 'lu', 1, '2026-08-11 09:13:49'),
(126, 'Malta', 'Malta', 'mt', 1, '2026-08-11 09:13:49'),
(127, 'Moldova', 'Moldova', 'md', 1, '2026-08-11 09:13:49'),
(129, 'Montenegro', 'Monteneqro', 'me', 1, '2026-08-11 09:13:49'),
(130, 'Dutch', 'Niderland', 'nl', 1, '2026-08-11 09:13:49'),
(132, 'Norway', 'Norveç', 'no', 1, '2026-08-11 09:13:49'),
(133, 'Poland', 'Polşa', 'pl', 1, '2026-08-11 09:13:49'),
(134, 'Portugal', 'Portuqaliya', 'pt', 1, '2026-08-11 09:13:49'),
(135, 'Romania', 'Rumıniya', 'ro', 1, '2026-08-11 09:13:49'),
(136, 'Russia', 'Rusiya', 'ru', 1, '2026-08-11 09:13:49'),
(137, 'San Marino', 'San-Marino', 'sm', 1, '2026-08-11 09:13:49'),
(138, 'Serbia', 'Serbiya', 'rs', 1, '2026-08-11 09:13:49'),
(139, 'Slovakia', 'Slovakiya', 'sk', 1, '2026-08-11 09:13:49'),
(140, 'Slovenia', 'Sloveniya', 'si', 1, '2026-08-11 09:13:49'),
(141, 'Spain', 'İspaniya', 'es', 1, '2026-08-11 09:13:49'),
(142, 'Sweden', 'İsveç', 'se', 1, '2026-08-11 09:13:49'),
(143, 'Switzerland', 'İsveçrə', 'ch', 1, '2026-08-11 09:13:49'),
(144, 'Ukraine', 'Ukrayna', 'ua', 1, '2026-08-11 09:13:49'),
(145, 'England', 'Böyük Britaniya', 'gb', 1, '2026-08-11 09:13:49'),
(147, 'Antigua and Barbuda', 'Antiqua və Barbuda', 'ag', 1, '2026-08-11 09:13:49'),
(149, 'Barbados', 'Barbados', 'bb', 1, '2026-08-11 09:13:49'),
(151, 'Canada', 'Kanada', 'ca', 1, '2026-08-11 09:13:49'),
(152, 'Costa Rica', 'Kosta-Rika', 'cr', 1, '2026-08-11 09:13:49'),
(155, 'Dominican Republic', 'Dominikan Respublikası', 'do', 1, '2026-08-11 09:13:49'),
(156, 'El Salvador', 'Salvador', 'sv', 1, '2026-08-11 09:13:49'),
(158, 'Guatemala', 'Qvatemala', 'gt', 1, '2026-08-11 09:13:49'),
(160, 'Honduras', 'Honduras', 'hn', 1, '2026-08-11 09:13:49'),
(161, 'Jamaica', 'Yamayka', 'jm', 1, '2026-08-11 09:13:49'),
(162, 'Mexico', 'Meksika', 'mx', 1, '2026-08-11 09:13:49'),
(163, 'Nicaragua', 'Nikaraqua', 'ni', 1, '2026-08-11 09:13:49'),
(164, 'Panama', 'Panama', 'pa', 1, '2026-08-11 09:13:49'),
(169, 'USA', 'Amerika Birləşmiş Ştatları', 'us', 1, '2026-08-11 09:13:49'),
(170, 'Argentina', 'Argentina', 'ar', 1, '2026-08-11 09:13:49'),
(171, 'Bolivia', 'Boliviya', 'bo', 1, '2026-08-11 09:13:49'),
(172, 'Brazil', 'Braziliya', 'br', 1, '2026-08-11 09:13:49'),
(173, 'Chile', 'Çili', 'cl', 1, '2026-08-11 09:13:49'),
(174, 'Colombia', 'Kolumbiya', 'co', 1, '2026-08-11 09:13:49'),
(175, 'Ecuador', 'Ekvador', 'ec', 1, '2026-08-11 09:13:49'),
(177, 'Paraguay', 'Paraqvay', 'py', 1, '2026-08-11 09:13:49'),
(178, 'Peru', 'Peru', 'pe', 1, '2026-08-11 09:13:49'),
(179, 'Suriname', 'Surinam', 'sr', 1, '2026-08-11 09:13:49'),
(180, 'Uruguay', 'Uruqvay', 'uy', 1, '2026-08-11 09:13:49'),
(181, 'Venezuela', 'Venesuela', 've', 1, '2026-08-11 09:13:49'),
(182, 'Australia', 'Avstraliya', 'au', 1, '2026-08-11 09:13:49'),
(183, 'Fiji', 'Fici', 'fj', 1, '2026-08-11 09:13:49'),
(188, 'New Zealand', 'Yeni Zelandiya', 'nz', 1, '2026-08-11 09:13:49');

-- --------------------------------------------------------

--
-- Структура таблицы `games`
--

CREATE TABLE `games` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `mode` enum('country-club','club-club') NOT NULL,
  `total_questions` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `correct` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `wrong` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `skipped` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `score` int(11) NOT NULL DEFAULT 0,
  `started_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `finished_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `games`
--

INSERT INTO `games` (`id`, `user_id`, `mode`, `total_questions`, `correct`, `wrong`, `skipped`, `score`, `started_at`, `finished_at`) VALUES
(6, 2, 'country-club', 3, 2, 1, 0, 200, '2026-08-12 06:34:55', '2026-08-12 07:21:25'),
(20, 2, 'country-club', 2, 1, 1, 0, 100, '2026-08-12 07:21:37', '2026-08-12 07:23:21'),
(21, 2, 'club-club', 0, 0, 0, 0, 0, '2026-08-12 07:23:22', '2026-08-12 07:23:39'),
(22, 2, 'country-club', 7, 2, 5, 0, 200, '2026-08-12 07:27:29', '2026-08-12 07:30:20'),
(23, 2, 'country-club', 5, 2, 3, 0, 200, '2026-08-12 07:36:30', '2026-08-12 07:43:57'),
(24, 2, 'country-club', 2, 2, 0, 0, 200, '2026-08-12 07:46:51', '2026-08-12 07:54:17'),
(25, 2, 'country-club', 12, 1, 0, 0, 100, '2026-08-12 07:54:23', '2026-08-12 07:56:26'),
(26, 2, 'country-club', 6, 1, 1, 0, 100, '2026-08-12 08:02:18', '2026-08-12 08:03:04'),
(27, 2, 'country-club', 5, 1, 0, 1, 100, '2026-08-12 08:08:52', '2026-08-12 08:09:35'),
(28, 2, 'country-club', 26, 1, 1, 4, 100, '2026-08-12 08:17:00', '2026-08-12 08:19:14'),
(29, 2, 'country-club', 15, 0, 3, 7, 0, '2026-08-12 08:26:19', '2026-08-12 08:28:57'),
(30, 2, 'country-club', 5, 0, 1, 2, 0, '2026-08-12 08:30:37', '2026-08-12 08:31:25'),
(31, 2, 'country-club', 28, 0, 0, 25, 0, '2026-08-12 08:31:38', '2026-08-12 08:40:06'),
(32, 2, 'country-club', 1, 0, 0, 0, 0, '2026-08-12 08:40:07', '2026-08-12 08:40:09'),
(33, 2, 'country-club', 7, 0, 0, 5, 0, '2026-08-12 08:40:33', '2026-08-12 08:42:08'),
(34, 2, 'country-club', 3, 0, 0, 1, 0, '2026-08-12 08:42:54', '2026-08-12 08:43:22'),
(35, 2, 'country-club', 3, 0, 0, 1, 0, '2026-08-12 08:44:26', '2026-08-12 08:44:45'),
(36, 2, 'country-club', 2, 0, 0, 0, 0, '2026-08-12 08:46:46', '2026-08-12 08:46:52'),
(37, 2, 'country-club', 7, 1, 1, 4, 100, '2026-08-12 08:46:53', '2026-08-12 08:48:00'),
(38, 2, 'country-club', 5, 0, 0, 2, 0, '2026-08-12 08:48:05', '2026-08-12 08:48:37'),
(39, 2, 'country-club', 4, 0, 1, 2, 0, '2026-08-12 08:53:38', '2026-08-12 08:54:17'),
(40, 2, 'country-club', 11, 0, 1, 10, 0, '2026-08-12 08:54:18', '2026-08-12 08:56:59'),
(41, 2, 'country-club', 6, 1, 0, 5, 100, '2026-08-12 20:45:11', '2026-08-12 20:46:23'),
(42, 2, 'club-club', 4, 0, 0, 3, 0, '2026-08-12 20:46:24', '2026-08-13 07:30:01'),
(43, 2, 'country-club', 13, 0, 0, 12, 0, '2026-08-13 07:30:10', '2026-08-13 07:32:15'),
(44, 2, 'country-club', 2, 0, 0, 2, 0, '2026-08-13 07:43:04', '2026-08-13 07:43:15'),
(45, 2, 'club-club', 4, 0, 0, 3, 0, '2026-08-13 07:43:35', '2026-08-13 07:44:06'),
(46, 2, 'country-club', 18, 1, 0, 16, 100, '2026-08-13 08:02:51', '2026-08-13 08:04:15'),
(47, 2, 'club-club', 14, 0, 0, 13, 0, '2026-08-13 08:04:16', '2026-08-13 08:05:18');

-- --------------------------------------------------------

--
-- Структура таблицы `game_answers`
--

CREATE TABLE `game_answers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `game_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `question_type` enum('country-club','club-club') NOT NULL,
  `side_a` varchar(150) NOT NULL,
  `side_b` varchar(150) NOT NULL,
  `side_a_id` int(10) UNSIGNED NOT NULL,
  `side_b_id` int(10) UNSIGNED NOT NULL,
  `player_id` int(10) UNSIGNED DEFAULT NULL,
  `player_answer` varchar(150) DEFAULT NULL,
  `correct_player` varchar(150) DEFAULT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT 0,
  `points` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `game_answers`
--

INSERT INTO `game_answers` (`id`, `game_id`, `user_id`, `question_type`, `side_a`, `side_b`, `side_a_id`, `side_b_id`, `player_id`, `player_answer`, `correct_player`, `is_correct`, `points`, `created_at`) VALUES
(5, 6, 2, 'country-club', 'İspaniya', 'Athletic Bilbao', 141, 133727, NULL, NULL, NULL, 0, 0, '2026-08-12 06:35:26'),
(6, 6, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, 34146362, 'Xavi', 'Xavi', 1, 100, '2026-08-12 06:43:52'),
(7, 6, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, 34146371, 'Neymar', 'Neymar', 1, 100, '2026-08-12 06:44:18'),
(8, 20, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, NULL, NULL, NULL, 0, 0, '2026-08-12 07:21:55'),
(9, 20, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, 34146360, 'Alves', 'Dani Alves', 1, 100, '2026-08-12 07:22:18'),
(10, 22, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, 34146363, 'iniesta', 'Andres Iniesta', 1, 100, '2026-08-12 07:27:40'),
(11, 22, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, NULL, NULL, NULL, 0, 0, '2026-08-12 07:28:10'),
(12, 22, 2, 'country-club', 'İspaniya', 'Atlético Madrid', 141, 133729, NULL, 'alves', NULL, 0, 0, '2026-08-12 07:29:00'),
(13, 22, 2, 'country-club', 'Almaniya', 'Barcelona', 116, 133739, NULL, NULL, NULL, 0, 0, '2026-08-12 07:29:21'),
(14, 22, 2, 'country-club', 'İspaniya', 'Athletic Bilbao', 141, 133727, NULL, 'raul', NULL, 0, 0, '2026-08-12 07:29:33'),
(15, 22, 2, 'country-club', 'Almaniya', 'Barcelona', 116, 133739, NULL, 'oliver', NULL, 0, 0, '2026-08-12 07:30:03'),
(16, 22, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, 34146371, 'neymar', 'Neymar', 1, 100, '2026-08-12 07:30:17'),
(17, 23, 2, 'country-club', 'İspaniya', 'Atlético Madrid', 141, 133729, NULL, 'fdsfd', NULL, 0, 0, '2026-08-12 07:36:36'),
(18, 23, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, 34146352, 'valdes', 'Victor Valdes', 1, 100, '2026-08-12 07:36:48'),
(19, 23, 2, 'country-club', 'İspaniya', 'Athletic Bilbao', 141, 133727, NULL, 'dffds', NULL, 0, 0, '2026-08-12 07:42:19'),
(20, 23, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, NULL, 'alves', NULL, 0, 0, '2026-08-12 07:42:52'),
(21, 23, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, 34146360, 'alves', 'Dani Alves', 1, 100, '2026-08-12 07:43:28'),
(22, 24, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, 34146371, 'neymar', 'Neymar', 1, 100, '2026-08-12 07:47:00'),
(23, 24, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, 34146362, 'xavi', 'Xavi', 1, 100, '2026-08-12 07:47:34'),
(24, 25, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, 34146360, 'alves', 'Dani Alves', 1, 100, '2026-08-12 07:56:21'),
(25, 26, 2, 'country-club', 'İspaniya', 'Deportivo de A Coruña', 141, 133816, NULL, NULL, NULL, 0, 0, '2026-08-12 08:02:40'),
(26, 26, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, 34146362, 'xavi', 'Xavi', 1, 100, '2026-08-12 08:03:00'),
(27, 27, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, 34146363, 'iniesta', 'Andres Iniesta', 1, 100, '2026-08-12 08:09:01'),
(28, 27, 2, 'country-club', 'Almaniya', 'Athletic Bilbao', 116, 133727, NULL, NULL, NULL, 0, 0, '2026-08-12 08:09:15'),
(29, 28, 2, 'country-club', 'Almaniya', 'Deportivo Alavés', 116, 134221, NULL, NULL, NULL, 0, 0, '2026-08-12 08:17:10'),
(30, 28, 2, 'country-club', 'Almaniya', 'Celta Vigo', 116, 133937, NULL, NULL, NULL, 0, 0, '2026-08-12 08:17:26'),
(31, 28, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, 34146371, 'neymar', 'Neymar', 1, 100, '2026-08-12 08:17:59'),
(32, 28, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, NULL, 'dani', NULL, 0, 0, '2026-08-12 08:18:14'),
(33, 28, 2, 'country-club', 'İspaniya', 'Deportivo Alavés', 141, 134221, NULL, NULL, NULL, 0, 0, '2026-08-12 08:18:52'),
(34, 28, 2, 'country-club', 'İspaniya', 'Levante', 141, 133732, NULL, NULL, NULL, 0, 0, '2026-08-12 08:19:12'),
(35, 29, 2, 'country-club', 'Braziliya', 'Elche', 172, 134384, NULL, NULL, NULL, 0, 0, '2026-08-12 08:26:34'),
(36, 29, 2, 'country-club', 'Braziliya', 'Deportivo de A Coruña', 172, 133816, NULL, NULL, NULL, 0, 0, '2026-08-12 08:26:49'),
(37, 29, 2, 'country-club', 'Braziliya', 'Deportivo de A Coruña', 172, 133816, NULL, 'fghfggfh', NULL, 0, 0, '2026-08-12 08:26:55'),
(38, 29, 2, 'country-club', 'Braziliya', 'Celta Vigo', 172, 133937, NULL, 'f', NULL, 0, 0, '2026-08-12 08:27:01'),
(39, 29, 2, 'country-club', 'İspaniya', 'Celta Vigo', 141, 133937, NULL, 'dfgfdggdf', NULL, 0, 0, '2026-08-12 08:27:10'),
(40, 29, 2, 'country-club', 'Braziliya', 'Elche', 172, 134384, NULL, NULL, NULL, 0, 0, '2026-08-12 08:27:26'),
(41, 29, 2, 'country-club', 'İspaniya', 'Elche', 141, 134384, NULL, NULL, NULL, 0, 0, '2026-08-12 08:27:43'),
(42, 29, 2, 'country-club', 'Almaniya', 'Barcelona', 116, 133739, NULL, NULL, NULL, 0, 0, '2026-08-12 08:28:07'),
(43, 29, 2, 'country-club', 'Almaniya', 'Levante', 116, 133732, NULL, NULL, NULL, 0, 0, '2026-08-12 08:28:32'),
(44, 29, 2, 'country-club', 'Braziliya', 'Levante', 172, 133732, NULL, NULL, NULL, 0, 0, '2026-08-12 08:28:49'),
(45, 30, 2, 'country-club', 'İspaniya', 'Elche', 141, 134384, NULL, NULL, NULL, 0, 0, '2026-08-12 08:30:48'),
(46, 30, 2, 'country-club', 'İspaniya', 'Espanyol', 141, 133734, NULL, NULL, NULL, 0, 0, '2026-08-12 08:31:08'),
(47, 30, 2, 'country-club', 'Braziliya', 'Getafe', 172, 133731, NULL, 'fgdfg', NULL, 0, 0, '2026-08-12 08:31:18'),
(48, 31, 2, 'country-club', 'Braziliya', 'Espanyol', 172, 133734, NULL, NULL, NULL, 0, 0, '2026-08-12 08:31:49'),
(49, 31, 2, 'country-club', 'Almaniya', 'Deportivo de A Coruña', 116, 133816, NULL, NULL, NULL, 0, 0, '2026-08-12 08:32:06'),
(50, 31, 2, 'country-club', 'Braziliya', 'Getafe', 172, 133731, NULL, NULL, NULL, 0, 0, '2026-08-12 08:32:23'),
(51, 31, 2, 'country-club', 'İspaniya', 'Atlético Madrid', 141, 133729, NULL, NULL, NULL, 0, 0, '2026-08-12 08:32:40'),
(52, 31, 2, 'country-club', 'Almaniya', 'Barcelona', 116, 133739, NULL, NULL, NULL, 0, 0, '2026-08-12 08:32:57'),
(53, 31, 2, 'country-club', 'Braziliya', 'Levante', 172, 133732, NULL, NULL, NULL, 0, 0, '2026-08-12 08:33:26'),
(54, 31, 2, 'country-club', 'Almaniya', 'Getafe', 116, 133731, NULL, NULL, NULL, 0, 0, '2026-08-12 08:34:24'),
(55, 31, 2, 'country-club', 'İspaniya', 'Athletic Bilbao', 141, 133727, NULL, NULL, NULL, 0, 0, '2026-08-12 08:34:38'),
(56, 31, 2, 'country-club', 'Braziliya', 'Atlético Madrid', 172, 133729, NULL, NULL, NULL, 0, 0, '2026-08-12 08:34:54'),
(57, 31, 2, 'country-club', 'Almaniya', 'Athletic Bilbao', 116, 133727, NULL, NULL, NULL, 0, 0, '2026-08-12 08:35:06'),
(58, 31, 2, 'country-club', 'Almaniya', 'Atlético Madrid', 116, 133729, NULL, NULL, NULL, 0, 0, '2026-08-12 08:35:23'),
(59, 31, 2, 'country-club', 'Almaniya', 'Getafe', 116, 133731, NULL, NULL, NULL, 0, 0, '2026-08-12 08:35:39'),
(60, 31, 2, 'country-club', 'İspaniya', 'Deportivo Alavés', 141, 134221, NULL, NULL, NULL, 0, 0, '2026-08-12 08:35:58'),
(61, 31, 2, 'country-club', 'İspaniya', 'Getafe', 141, 133731, NULL, NULL, NULL, 0, 0, '2026-08-12 08:36:15'),
(62, 31, 2, 'country-club', 'Almaniya', 'Celta Vigo', 116, 133937, NULL, NULL, NULL, 0, 0, '2026-08-12 08:36:32'),
(63, 31, 2, 'country-club', 'İspaniya', 'Deportivo Alavés', 141, 134221, NULL, NULL, NULL, 0, 0, '2026-08-12 08:36:49'),
(64, 31, 2, 'country-club', 'İspaniya', 'Elche', 141, 134384, NULL, NULL, NULL, 0, 0, '2026-08-12 08:37:06'),
(65, 31, 2, 'country-club', 'Braziliya', 'Celta Vigo', 172, 133937, NULL, NULL, NULL, 0, 0, '2026-08-12 08:37:23'),
(66, 31, 2, 'country-club', 'Braziliya', 'Elche', 172, 134384, NULL, NULL, NULL, 0, 0, '2026-08-12 08:37:40'),
(67, 31, 2, 'country-club', 'İspaniya', 'Deportivo Alavés', 141, 134221, NULL, NULL, NULL, 0, 0, '2026-08-12 08:37:56'),
(68, 31, 2, 'country-club', 'İspaniya', 'Getafe', 141, 133731, NULL, NULL, NULL, 0, 0, '2026-08-12 08:38:22'),
(69, 31, 2, 'country-club', 'Braziliya', 'Deportivo Alavés', 172, 134221, NULL, NULL, NULL, 0, 0, '2026-08-12 08:38:39'),
(70, 31, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, NULL, NULL, NULL, 0, 0, '2026-08-12 08:38:56'),
(71, 31, 2, 'country-club', 'Braziliya', 'Elche', 172, 134384, NULL, NULL, NULL, 0, 0, '2026-08-12 08:39:13'),
(72, 31, 2, 'country-club', 'Almaniya', 'Levante', 116, 133732, NULL, NULL, NULL, 0, 0, '2026-08-12 08:39:59'),
(73, 33, 2, 'country-club', 'Almaniya', 'Deportivo de A Coruña', 116, 133816, NULL, NULL, NULL, 0, 0, '2026-08-12 08:40:43'),
(74, 33, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, NULL, NULL, NULL, 0, 0, '2026-08-12 08:41:00'),
(75, 33, 2, 'country-club', 'Braziliya', 'Levante', 172, 133732, NULL, NULL, NULL, 0, 0, '2026-08-12 08:41:17'),
(76, 33, 2, 'country-club', 'İspaniya', 'Deportivo de A Coruña', 141, 133816, NULL, NULL, NULL, 0, 0, '2026-08-12 08:41:42'),
(77, 33, 2, 'country-club', 'Braziliya', 'Elche', 172, 134384, NULL, NULL, NULL, 0, 0, '2026-08-12 08:41:59'),
(78, 34, 2, 'country-club', 'Braziliya', 'Deportivo Alavés', 172, 134221, NULL, NULL, NULL, 0, 0, '2026-08-12 08:43:05'),
(79, 35, 2, 'country-club', 'Braziliya', 'Deportivo de A Coruña', 172, 133816, NULL, NULL, NULL, 0, 0, '2026-08-12 08:44:38'),
(80, 37, 2, 'country-club', 'Almaniya', 'Deportivo Alavés', 116, 134221, NULL, NULL, NULL, 0, 0, '2026-08-12 08:46:56'),
(81, 37, 2, 'country-club', 'Braziliya', 'Getafe', 172, 133731, NULL, NULL, NULL, 0, 0, '2026-08-12 08:47:11'),
(82, 37, 2, 'country-club', 'Braziliya', 'Celta Vigo', 172, 133937, NULL, NULL, NULL, 0, 0, '2026-08-12 08:47:21'),
(83, 37, 2, 'country-club', 'Almaniya', 'Atlético Madrid', 116, 133729, NULL, NULL, NULL, 0, 0, '2026-08-12 08:47:36'),
(84, 37, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, 34146371, 'neymar', 'Neymar', 1, 100, '2026-08-12 08:47:48'),
(85, 37, 2, 'country-club', 'Braziliya', 'Getafe', 172, 133731, NULL, 'dfgfdg', NULL, 0, 0, '2026-08-12 08:47:57'),
(86, 38, 2, 'country-club', 'Almaniya', 'Espanyol', 116, 133734, NULL, NULL, NULL, 0, 0, '2026-08-12 08:48:15'),
(87, 38, 2, 'country-club', 'Almaniya', 'Atlético Madrid', 116, 133729, NULL, NULL, NULL, 0, 0, '2026-08-12 08:48:30'),
(88, 39, 2, 'country-club', 'İspaniya', 'Deportivo Alavés', 141, 134221, NULL, NULL, NULL, 0, 0, '2026-08-12 08:53:43'),
(89, 39, 2, 'country-club', 'Braziliya', 'Espanyol', 172, 133734, NULL, NULL, NULL, 0, 0, '2026-08-12 08:53:58'),
(90, 39, 2, 'country-club', 'Almaniya', 'Athletic Bilbao', 116, 133727, NULL, 'ghfgh', NULL, 0, 0, '2026-08-12 08:54:09'),
(91, 40, 2, 'country-club', 'Almaniya', 'Deportivo de A Coruña', 116, 133816, NULL, NULL, NULL, 0, 0, '2026-08-12 08:54:21'),
(92, 40, 2, 'country-club', 'Almaniya', 'Elche', 116, 134384, NULL, NULL, NULL, 0, 0, '2026-08-12 08:54:29'),
(93, 40, 2, 'country-club', 'İspaniya', 'Celta Vigo', 141, 133937, NULL, NULL, NULL, 0, 0, '2026-08-12 08:54:45'),
(94, 40, 2, 'country-club', 'Almaniya', 'Getafe', 116, 133731, NULL, NULL, NULL, 0, 0, '2026-08-12 08:55:01'),
(95, 40, 2, 'country-club', 'Almaniya', 'Deportivo Alavés', 116, 134221, NULL, NULL, NULL, 0, 0, '2026-08-12 08:55:18'),
(96, 40, 2, 'country-club', 'İspaniya', 'Atlético Madrid', 141, 133729, NULL, NULL, NULL, 0, 0, '2026-08-12 08:55:34'),
(97, 40, 2, 'country-club', 'İspaniya', 'Espanyol', 141, 133734, NULL, 'fgdfg', NULL, 0, 0, '2026-08-12 08:55:41'),
(98, 40, 2, 'country-club', 'Almaniya', 'Barcelona', 116, 133739, NULL, NULL, NULL, 0, 0, '2026-08-12 08:55:58'),
(99, 40, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, NULL, NULL, NULL, 0, 0, '2026-08-12 08:56:15'),
(100, 40, 2, 'country-club', 'Braziliya', 'Athletic Bilbao', 172, 133727, NULL, NULL, NULL, 0, 0, '2026-08-12 08:56:32'),
(101, 40, 2, 'country-club', 'Almaniya', 'Espanyol', 116, 133734, NULL, NULL, NULL, 0, 0, '2026-08-12 08:56:57'),
(102, 41, 2, 'country-club', 'Braziliya', 'Celta Vigo', 172, 133937, NULL, NULL, NULL, 0, 0, '2026-08-12 20:45:20'),
(103, 41, 2, 'country-club', 'Braziliya', 'Celta Vigo', 172, 133937, NULL, NULL, NULL, 0, 0, '2026-08-12 20:45:27'),
(104, 41, 2, 'country-club', 'Braziliya', 'Levante', 172, 133732, NULL, NULL, NULL, 0, 0, '2026-08-12 20:45:37'),
(105, 41, 2, 'country-club', 'İspaniya', 'Getafe', 141, 133731, NULL, NULL, NULL, 0, 0, '2026-08-12 20:45:52'),
(106, 41, 2, 'country-club', 'Braziliya', 'Barcelona', 172, 133739, 34146371, 'neymar', 'Neymar', 1, 100, '2026-08-12 20:46:05'),
(107, 41, 2, 'country-club', 'Braziliya', 'Deportivo de A Coruña', 172, 133816, NULL, NULL, NULL, 0, 0, '2026-08-12 20:46:20'),
(108, 42, 2, 'club-club', 'Athletic Bilbao', 'Getafe', 133727, 133731, NULL, NULL, NULL, 0, 0, '2026-08-12 20:46:35'),
(109, 42, 2, 'club-club', 'Espanyol', 'Barcelona', 133734, 133739, NULL, NULL, NULL, 0, 0, '2026-08-12 22:18:29'),
(110, 42, 2, 'club-club', 'Elche', 'Levante', 134384, 133732, NULL, NULL, NULL, 0, 0, '2026-08-12 22:18:47'),
(111, 43, 2, 'country-club', 'Amerika Birləşmiş Ştatları', 'Levante', 169, 133732, NULL, NULL, NULL, 0, 0, '2026-08-13 07:30:15'),
(112, 43, 2, 'country-club', 'Zimbabve', 'Deportivo de A Coruña', 54, 133816, NULL, NULL, NULL, 0, 0, '2026-08-13 07:30:23'),
(113, 43, 2, 'country-club', 'İsveç', 'Elche', 142, 134384, NULL, NULL, NULL, 0, 0, '2026-08-13 07:30:33'),
(114, 43, 2, 'country-club', 'Livan', 'Espanyol', 77, 133734, NULL, NULL, NULL, 0, 0, '2026-08-13 07:30:49'),
(115, 43, 2, 'country-club', 'İndoneziya', 'Atlético Madrid', 67, 133729, NULL, NULL, NULL, 0, 0, '2026-08-13 07:31:06'),
(116, 43, 2, 'country-club', 'Paraqvay', 'Barcelona', 177, 133739, NULL, NULL, NULL, 0, 0, '2026-08-13 07:31:23'),
(117, 43, 2, 'country-club', 'Panama', 'Barcelona', 164, 133739, NULL, NULL, NULL, 0, 0, '2026-08-13 07:31:39'),
(118, 43, 2, 'country-club', 'Sloveniya', 'Deportivo Alavés', 140, 134221, NULL, NULL, NULL, 0, 0, '2026-08-13 07:31:45'),
(119, 43, 2, 'country-club', 'Surinam', 'Atlético Madrid', 179, 133729, NULL, NULL, NULL, 0, 0, '2026-08-13 07:31:50'),
(120, 43, 2, 'country-club', 'Türkmənistan', 'Elche', 98, 134384, NULL, NULL, NULL, 0, 0, '2026-08-13 07:31:55'),
(121, 43, 2, 'country-club', 'Bolqarıstan', 'Athletic Bilbao', 109, 133727, NULL, NULL, NULL, 0, 0, '2026-08-13 07:32:05'),
(122, 43, 2, 'country-club', 'Lüksemburq', 'Atlético Madrid', 125, 133729, NULL, NULL, NULL, 0, 0, '2026-08-13 07:32:10'),
(123, 44, 2, 'country-club', 'Belarus', 'Levante', 106, 133732, NULL, NULL, NULL, 0, 0, '2026-08-13 07:43:06'),
(124, 44, 2, 'country-club', 'Venesuela', 'Deportivo de A Coruña', 181, 133816, NULL, NULL, NULL, 0, 0, '2026-08-13 07:43:12'),
(125, 45, 2, 'club-club', 'Deportivo de A Coruña', 'Atlético Madrid', 133816, 133729, NULL, NULL, NULL, 0, 0, '2026-08-13 07:43:37'),
(126, 45, 2, 'club-club', 'Atlético Madrid', 'Athletic Bilbao', 133729, 133727, NULL, NULL, NULL, 0, 0, '2026-08-13 07:43:50'),
(127, 45, 2, 'club-club', 'Athletic Bilbao', 'Barcelona', 133727, 133739, NULL, NULL, NULL, 0, 0, '2026-08-13 07:44:03'),
(128, 46, 2, 'country-club', 'İspaniya', 'Celta Vigo', 141, 133937, NULL, NULL, NULL, 0, 0, '2026-08-13 08:02:54'),
(129, 46, 2, 'country-club', 'İspaniya', 'Deportivo Alavés', 141, 134221, NULL, NULL, NULL, 0, 0, '2026-08-13 08:02:59'),
(130, 46, 2, 'country-club', 'İspaniya', 'Getafe', 141, 133731, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:03'),
(131, 46, 2, 'country-club', 'İspaniya', 'Deportivo Alavés', 141, 134221, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:07'),
(132, 46, 2, 'country-club', 'İspaniya', 'Espanyol', 141, 133734, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:12'),
(133, 46, 2, 'country-club', 'İspaniya', 'Athletic Bilbao', 141, 133727, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:16'),
(134, 46, 2, 'country-club', 'İspaniya', 'Barcelona', 141, 133739, 34219490, 'yamal', 'Lamine Yamal', 1, 100, '2026-08-13 08:03:27'),
(135, 46, 2, 'country-club', 'İspaniya', 'Getafe', 141, 133731, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:32'),
(136, 46, 2, 'country-club', 'İspaniya', 'Levante', 141, 133732, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:36'),
(137, 46, 2, 'country-club', 'İspaniya', 'Getafe', 141, 133731, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:40'),
(138, 46, 2, 'country-club', 'İspaniya', 'Espanyol', 141, 133734, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:44'),
(139, 46, 2, 'country-club', 'İspaniya', 'Athletic Bilbao', 141, 133727, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:49'),
(140, 46, 2, 'country-club', 'İspaniya', 'Getafe', 141, 133731, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:53'),
(141, 46, 2, 'country-club', 'İspaniya', 'Deportivo Alavés', 141, 134221, NULL, NULL, NULL, 0, 0, '2026-08-13 08:03:57'),
(142, 46, 2, 'country-club', 'İspaniya', 'Espanyol', 141, 133734, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:02'),
(143, 46, 2, 'country-club', 'İspaniya', 'Athletic Bilbao', 141, 133727, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:06'),
(144, 46, 2, 'country-club', 'İspaniya', 'Athletic Bilbao', 141, 133727, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:11'),
(145, 47, 2, 'club-club', 'Espanyol', 'Atlético Madrid', 133734, 133729, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:18'),
(146, 47, 2, 'club-club', 'Barcelona', 'Deportivo de A Coruña', 133739, 133816, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:23'),
(147, 47, 2, 'club-club', 'Espanyol', 'Athletic Bilbao', 133734, 133727, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:27'),
(148, 47, 2, 'club-club', 'Deportivo de A Coruña', 'Deportivo Alavés', 133816, 134221, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:32'),
(149, 47, 2, 'club-club', 'Espanyol', 'Getafe', 133734, 133731, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:36'),
(150, 47, 2, 'club-club', 'Celta Vigo', 'Atlético Madrid', 133937, 133729, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:40'),
(151, 47, 2, 'club-club', 'Barcelona', 'Athletic Bilbao', 133739, 133727, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:45'),
(152, 47, 2, 'club-club', 'Barcelona', 'Getafe', 133739, 133731, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:49'),
(153, 47, 2, 'club-club', 'Athletic Bilbao', 'Atlético Madrid', 133727, 133729, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:54'),
(154, 47, 2, 'club-club', 'Deportivo de A Coruña', 'Atlético Madrid', 133816, 133729, NULL, NULL, NULL, 0, 0, '2026-08-13 08:04:58'),
(155, 47, 2, 'club-club', 'Elche', 'Athletic Bilbao', 134384, 133727, NULL, NULL, NULL, 0, 0, '2026-08-13 08:05:03'),
(156, 47, 2, 'club-club', 'Athletic Bilbao', 'Getafe', 133727, 133731, NULL, NULL, NULL, 0, 0, '2026-08-13 08:05:07'),
(157, 47, 2, 'club-club', 'Atlético Madrid', 'Deportivo de A Coruña', 133729, 133816, NULL, NULL, NULL, 0, 0, '2026-08-13 08:05:12');

-- --------------------------------------------------------

--
-- Структура таблицы `leagues`
--

CREATE TABLE `leagues` (
  `id` int(10) UNSIGNED NOT NULL,
  `country_id` smallint(5) UNSIGNED NOT NULL,
  `api_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `name_az` varchar(150) DEFAULT NULL,
  `sport` varchar(50) NOT NULL DEFAULT 'Soccer',
  `banner` varchar(255) NOT NULL,
  `is_top_tier` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `leagues`
--

INSERT INTO `leagues` (`id`, `country_id`, `api_id`, `name`, `name_az`, `sport`, `banner`, `is_top_tier`, `is_active`, `created_at`) VALUES
(2, 1, 4753, 'Algerian Ligue 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:11:56'),
(3, 2, 5229, 'Angolan Girabola', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:11:57'),
(4, 3, 5231, 'Benin Championnat National', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:11:58'),
(5, 4, 5233, 'Botswana Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:11:59'),
(6, 5, 5234, 'Burkina Faso 1ere Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:00'),
(7, 6, 5235, 'Burundi Ligue A', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:01'),
(8, 13, 4955, 'DR Congo Ligue 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:07'),
(9, 14, 5241, 'Ivory Coast Ligue 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:08'),
(10, 16, 4829, 'Egyptian Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:10'),
(11, 20, 4959, 'Ethiopian Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:14'),
(12, 22, 5238, 'Gambia GFA League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:15'),
(13, 23, 4974, 'Ghanaian Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:16'),
(14, 24, 5240, 'Guinea Ligue 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:17'),
(15, 26, 4745, 'Kenyan Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:19'),
(16, 28, 5244, 'Liberian LFA First Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:21'),
(17, 29, 5245, 'Libyan Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:22'),
(18, 33, 5247, 'Mauritania Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:12:27'),
(19, 35, 4520, 'Moroccan Championship', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:18:27'),
(20, 39, 4827, 'Nigerian NPFL', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:18:33'),
(21, 40, 5253, 'Rwandan National Soccer League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:18:34'),
(22, 42, 4754, 'Senegal Ligue 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:18:37'),
(23, 45, 5254, 'Somali Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:18:42'),
(24, 48, 5255, 'Sudani Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:00'),
(25, 51, 4828, 'Tunisian Ligue 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:04'),
(26, 52, 5259, 'Ugandan Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:06'),
(27, 53, 5211, 'Zambia Super League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:07'),
(28, 54, 5261, 'Zimbabwe Premier Soccer League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:09'),
(29, 56, 4619, 'Armenian Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:12'),
(30, 57, 4693, 'Azerbaijani Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:13'),
(31, 58, 4826, 'Bahrain Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:15'),
(32, 59, 5078, 'Bangladesh Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:16'),
(33, 60, 5881, 'Bhutan Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:18'),
(34, 62, 4793, 'Cambodian Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:21'),
(35, 63, 4359, 'Chinese Super League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:22'),
(36, 64, 4630, 'Cypriot First Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:24'),
(37, 65, 4638, 'Georgian Erovnuli Liga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:25'),
(38, 66, 4797, 'Indian I-League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:26'),
(39, 67, 4790, 'Indonesian Super League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:28'),
(40, 68, 4742, 'Iranian Persian Gulf Pro League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:29'),
(41, 69, 5056, 'Iraqi Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:30'),
(42, 70, 4644, 'Israeli Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:32'),
(43, 71, 4633, 'Japanese J1 League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:33'),
(44, 72, 5055, 'Jordanian Pro League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:35'),
(45, 73, 4649, 'Kazakhstan Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:36'),
(46, 74, 4823, 'Kuwait Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:38'),
(47, 75, 4969, 'Kyrgyz Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:39'),
(48, 76, 4970, 'Lao League 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:41'),
(49, 77, 5243, 'Lebanon Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:42'),
(50, 78, 4792, 'Malaysian Super League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:21:44'),
(51, 80, 5248, 'Mongolian Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:44'),
(52, 81, 5630, 'Myanmar National League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:46'),
(53, 82, 5249, 'Nepalese A Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:47'),
(54, 84, 5250, 'Oman Professional League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:50'),
(55, 85, 5251, 'Pakistan Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:51'),
(56, 86, 5252, 'Palestinian West Bank Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:52'),
(57, 87, 5708, 'Philippines Football League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:54'),
(58, 88, 4663, 'Qatar Stars League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:55'),
(59, 89, 4668, 'Saudi-Arabian Pro League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:56'),
(60, 90, 4795, 'Singapore Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:58'),
(61, 91, 4689, 'South Korean K League 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:23:59'),
(62, 93, 5256, 'Syrian Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:02'),
(63, 94, 4811, 'Tajikistan Vysshaya Liga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:03'),
(64, 95, 4743, 'Thai Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:04'),
(65, 97, 4676, 'Turkish 1 Lig', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:07'),
(66, 98, 5257, 'Turkmenistan Yokary Liga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:08'),
(67, 99, 4678, 'UAE Pro League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:09'),
(68, 100, 4794, 'Uzbekistan Super League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:11'),
(69, 101, 4803, 'Vietnamese V.League 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:12'),
(70, 103, 4617, 'Albanian Superliga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:15'),
(71, 104, 4618, 'Andorran 1a Divisió', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:16'),
(72, 105, 4621, 'Austrian Bundesliga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:17'),
(73, 106, 4622, 'Belarus Vyscha Liga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:19'),
(74, 107, 4623, 'Belgian Challenger Pro League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:20'),
(75, 108, 4624, 'Bosnian Premier Liga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:21'),
(76, 109, 4626, 'Bulgarian First League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:24'),
(77, 110, 4629, 'Croatian First Football League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:25'),
(78, 112, 4340, 'Danish Superliga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:29'),
(79, 113, 4634, 'Estonian Meistriliiga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:31'),
(80, 114, 4636, 'Finnish Veikkausliiga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:32'),
(81, 115, 4334, 'French Ligue 1', NULL, 'Soccer', '9f7z9d1742983155', 0, 1, '2026-08-11 11:24:35'),
(82, 116, 4331, 'German Bundesliga', NULL, 'Soccer', 'teqh1b1679952008', 0, 1, '2026-08-11 11:24:36'),
(83, 117, 5842, 'Greek Gamma Ethniki Group 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:37'),
(84, 118, 4690, 'Hungarian NB I', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:24:39'),
(85, 121, 4332, 'Italian Serie A', NULL, 'Soccer', '67q3q21679951383', 0, 1, '2026-08-11 11:26:55'),
(86, 122, 4650, 'Latvian Higher League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:26:56'),
(87, 123, 4972, 'Liechtenstein Cup', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:26:58'),
(88, 124, 4651, 'Lithuanian TOPLYGA', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:26:59'),
(89, 125, 4694, 'Luxembourg National Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:00'),
(90, 126, 4653, 'Maltese Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:02'),
(91, 127, 4655, 'Moldovan National Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:03'),
(92, 129, 4656, 'Montenegrin First League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:06'),
(93, 132, 5208, 'Norway Toppserien', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:10'),
(94, 133, 4422, 'Polish Ekstraklasa', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:11'),
(95, 134, 5745, 'Campeonato de Portugal Serie A', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:12'),
(96, 135, 4691, 'Romanian Liga I', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:14'),
(97, 136, 5492, 'Russia FNL 2 Division A Gold Group', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:15'),
(98, 137, 4667, 'San-Marino Campionato', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:16'),
(99, 138, 4671, 'Serbian Super Liga', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:18'),
(100, 139, 4672, 'Slovak First Football League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:19'),
(101, 140, 4692, 'Slovenian 1. SNL', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:20'),
(102, 141, 4335, 'Spanish La Liga', NULL, 'Soccer', 'ja4it51687628717', 0, 1, '2026-08-11 11:27:22'),
(103, 142, 5209, 'Sweden Damallsvenskan', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:23'),
(104, 143, 5936, 'Swiss 1. Liga Classic Group 1', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:25'),
(105, 144, 4354, 'Ukrainian Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:27'),
(106, 145, 4328, 'English Premier League', NULL, 'Soccer', 'gasy9d1737743125', 0, 1, '2026-08-11 11:27:29'),
(107, 147, 5886, 'Antigua and Barbuda Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:34'),
(108, 149, 5860, 'Barbados Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:37'),
(109, 151, 5602, 'Canadian Northern Super League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:40'),
(110, 152, 4815, 'Costa-Rica Liga FPD', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:27:41'),
(111, 158, 4817, 'Guatemala Liga Nacional', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:04'),
(112, 160, 4818, 'Honduras Liga Nacional de Futbol', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:07'),
(113, 161, 5075, 'Jamaican Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:08'),
(114, 162, 5206, 'Mexican Liga Femenil', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:10'),
(115, 163, 4806, 'Nicaragua Primera Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:11'),
(116, 164, 4819, 'Panama Liga Panamena de Futbol', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:12'),
(117, 170, 5215, 'Argentina Primera B Metropolitana', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:20'),
(118, 171, 4685, 'Bolivian Primera División', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:21'),
(119, 172, 5201, 'Brazil Brasileiro Women', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:23'),
(120, 173, 4627, 'Chile Primera Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:25'),
(121, 174, 4497, 'Colombian Liga DIMAYOR', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:26'),
(122, 175, 4686, 'Ecuadorian Serie A', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:28'),
(123, 177, 4687, 'Paraguayan Primera Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:31'),
(124, 178, 4688, 'Peruvian Primera Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:32'),
(125, 179, 5802, 'Suriname Major League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:33'),
(126, 180, 4432, 'Uruguayan Primera Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:36'),
(127, 181, 4513, 'Venezuela Primera Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:38'),
(128, 182, 5013, 'Australia Brisbane Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:40'),
(129, 183, 4962, 'Fijian Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:30:42'),
(130, 46, 4802, 'South African Premier Soccer League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:47:28'),
(131, 79, 5246, 'Maldives Dhivehi Premier League', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:47:38'),
(132, 120, 4643, 'Irish Premier Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:50:01'),
(133, 155, 4956, 'Dominican LDF', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:50:14'),
(134, 156, 4816, 'El Salvador Primera Division', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:50:16'),
(135, 188, 5504, 'New Zealand National League Championship', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:50:35'),
(136, 119, 4642, 'Icelandic Úrvalsdeild karla', NULL, 'Soccer', '', 0, 1, '2026-08-11 11:57:50'),
(137, 130, 4337, 'Dutch Eredivisie', NULL, 'Soccer', '5cdsu21725984946', 0, 1, '2026-08-11 11:58:42'),
(138, 111, 4954, 'Czech National Football League', NULL, 'Soccer', '', 0, 1, '2026-08-11 12:01:18'),
(139, 169, 4346, 'American Major League Soccer', NULL, 'Soccer', '', 0, 1, '2026-08-11 12:02:36');

-- --------------------------------------------------------

--
-- Структура таблицы `league_teams`
--

CREATE TABLE `league_teams` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `league_id` int(10) UNSIGNED NOT NULL,
  `team_api_id` int(10) UNSIGNED NOT NULL,
  `team_name` varchar(150) NOT NULL,
  `team_badge` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `league_teams`
--

INSERT INTO `league_teams` (`id`, `league_id`, `team_api_id`, `team_name`, `team_badge`, `is_active`, `created_at`) VALUES
(1, 102, 134221, 'Deportivo Alavés', 'mfn99h1734673842', 1, '2026-08-12 22:49:14'),
(2, 102, 133816, 'Deportivo La Coruña', '62bvwv1783013156', 1, '2026-08-12 22:49:14'),
(3, 102, 133727, 'Athletic Bilbao', '68w7fe1639408210', 1, '2026-08-12 22:49:14'),
(4, 102, 133729, 'Atlético Madrid', '0ulh3q1719984315', 1, '2026-08-12 22:49:14'),
(5, 102, 133739, 'FC Barcelona', 'wq9sir1639406443', 1, '2026-08-12 22:49:14'),
(6, 102, 134384, 'Elche', 'e4vaw51655594332', 1, '2026-08-12 22:49:14'),
(7, 102, 133937, 'Celta Vigo', 'xfjtku1690436219', 1, '2026-08-12 22:49:14'),
(8, 102, 133734, 'Espanyol', '867nzz1681703222', 1, '2026-08-12 22:49:14'),
(9, 102, 133731, 'Getafe CF', 'eyh2891655594452', 1, '2026-08-12 22:49:14'),
(10, 102, 133732, 'Levante', 'xwtxsx1473503739', 1, '2026-08-12 22:49:14'),
(11, 102, 133736, 'Málaga', 'upqyvr1473502952', 1, '2026-08-12 22:49:14'),
(12, 102, 133730, 'CA Osasuna', 'rvspvt1473502960', 1, '2026-08-12 22:49:14'),
(13, 102, 133726, 'Racing de Santander', '97kkiq1536575158', 1, '2026-08-12 22:49:14'),
(14, 102, 133728, 'Rayo Vallecano', 'nzhu941655595465', 1, '2026-08-12 22:49:14'),
(15, 102, 133722, 'Real Betis', '2oqulv1663245386', 1, '2026-08-12 22:49:14'),
(16, 102, 133738, 'Real Madrid', 'vwvwrw1473502969', 1, '2026-08-12 22:49:14'),
(17, 102, 133724, 'Real Sociedad', 'vptvpr1473502986', 1, '2026-08-12 22:49:14'),
(18, 102, 133735, 'Sevilla FC', 'vpsqqx1473502977', 1, '2026-08-12 22:49:14'),
(19, 102, 133725, 'Valencia CF', 'dm8l6o1655594864', 1, '2026-08-12 22:49:14'),
(20, 102, 133740, 'Villarreal CF', 'vrypqy1473503073', 1, '2026-08-12 22:49:14');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `created_at`) VALUES
(2, 'DrGraf', 'beatsgraf@gmail.com', '$2y$10$uj7PDnBM1uEB6spG2NN1Mu5UTiUhJeofHTMn.Ghx4i03cg5MRtVs2', '2026-08-11 13:09:21');

-- --------------------------------------------------------

--
-- Структура таблицы `user_settings`
--

CREATE TABLE `user_settings` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `user_settings`
--

INSERT INTO `user_settings` (`user_id`, `updated_at`) VALUES
(2, '2026-08-11 13:09:21');

-- --------------------------------------------------------

--
-- Структура таблицы `user_setting_club_countries`
--

CREATE TABLE `user_setting_club_countries` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `country_id` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `user_setting_club_countries`
--

INSERT INTO `user_setting_club_countries` (`user_id`, `country_id`) VALUES
(2, 141);

-- --------------------------------------------------------

--
-- Структура таблицы `user_setting_leagues`
--

CREATE TABLE `user_setting_leagues` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `league_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `user_setting_leagues`
--

INSERT INTO `user_setting_leagues` (`user_id`, `league_id`) VALUES
(2, 102);

-- --------------------------------------------------------

--
-- Структура таблицы `user_setting_national_teams`
--

CREATE TABLE `user_setting_national_teams` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `country_id` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `user_setting_national_teams`
--

INSERT INTO `user_setting_national_teams` (`user_id`, `country_id`) VALUES
(2, 141);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `api_key` (`api_key`);

--
-- Индексы таблицы `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_games_user` (`user_id`),
  ADD KEY `idx_games_score` (`score`),
  ADD KEY `idx_games_finished` (`finished_at`),
  ADD KEY `idx_games_user_finished` (`user_id`,`finished_at`);

--
-- Индексы таблицы `game_answers`
--
ALTER TABLE `game_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_game_answers_game` (`game_id`),
  ADD KEY `idx_game_answers_correct` (`is_correct`);

--
-- Индексы таблицы `leagues`
--
ALTER TABLE `leagues`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_leagues_api_id` (`api_id`),
  ADD KEY `idx_leagues_country` (`country_id`),
  ADD KEY `idx_leagues_active` (`is_active`);

--
-- Индексы таблицы `league_teams`
--
ALTER TABLE `league_teams`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_league_team` (`league_id`,`team_api_id`),
  ADD KEY `idx_league_teams_league` (`league_id`),
  ADD KEY `idx_league_teams_team` (`team_api_id`),
  ADD KEY `idx_league_teams_active` (`is_active`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `uq_users_username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- Индексы таблицы `user_settings`
--
ALTER TABLE `user_settings`
  ADD PRIMARY KEY (`user_id`);

--
-- Индексы таблицы `user_setting_club_countries`
--
ALTER TABLE `user_setting_club_countries`
  ADD PRIMARY KEY (`user_id`,`country_id`),
  ADD KEY `fk_uscc_country` (`country_id`);

--
-- Индексы таблицы `user_setting_leagues`
--
ALTER TABLE `user_setting_leagues`
  ADD PRIMARY KEY (`user_id`,`league_id`),
  ADD KEY `fk_usl_league` (`league_id`);

--
-- Индексы таблицы `user_setting_national_teams`
--
ALTER TABLE `user_setting_national_teams`
  ADD PRIMARY KEY (`user_id`,`country_id`),
  ADD KEY `fk_usnt_country` (`country_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `countries`
--
ALTER TABLE `countries`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=196;

--
-- AUTO_INCREMENT для таблицы `games`
--
ALTER TABLE `games`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT для таблицы `game_answers`
--
ALTER TABLE `game_answers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=158;

--
-- AUTO_INCREMENT для таблицы `leagues`
--
ALTER TABLE `leagues`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=140;

--
-- AUTO_INCREMENT для таблицы `league_teams`
--
ALTER TABLE `league_teams`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `games`
--
ALTER TABLE `games`
  ADD CONSTRAINT `fk_games_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `game_answers`
--
ALTER TABLE `game_answers`
  ADD CONSTRAINT `fk_game_answers_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `leagues`
--
ALTER TABLE `leagues`
  ADD CONSTRAINT `fk_leagues_country` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `league_teams`
--
ALTER TABLE `league_teams`
  ADD CONSTRAINT `fk_league_teams_league` FOREIGN KEY (`league_id`) REFERENCES `leagues` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `user_settings`
--
ALTER TABLE `user_settings`
  ADD CONSTRAINT `fk_user_settings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `user_setting_club_countries`
--
ALTER TABLE `user_setting_club_countries`
  ADD CONSTRAINT `fk_uscc_country` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_uscc_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `user_setting_leagues`
--
ALTER TABLE `user_setting_leagues`
  ADD CONSTRAINT `fk_usl_league` FOREIGN KEY (`league_id`) REFERENCES `leagues` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_usl_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `user_setting_national_teams`
--
ALTER TABLE `user_setting_national_teams`
  ADD CONSTRAINT `fk_usnt_country` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_usnt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
