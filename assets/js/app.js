let gameId = null;

let COUNTRIES = [];
let countryByKey = {};

// ---------- Vəziyyət ----------
let settings = { clubCountries: [], nationalTeams: [] };
let score = { total: 0, correct: 0, wrong: 0 };
let mode = null; // "country-club" | "club-club"
let current = null; // cari sualın datası
let timerInterval = null;
let timeLeft = 10;
let answered = false;

const teamsCache = {}; // leagueName -> [{name, badge}]

// ---------- Köməkçi: normalizasiya və fuzzy müqayisə ----------
function normalize(str) {
  return (str || "")
    .toString()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9 ]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function levenshtein(a, b) {
  const m = a.length, n = b.length;
  if (m === 0) return n;
  if (n === 0) return m;
  const dp = Array.from({ length: m + 1 }, () => new Array(n + 1).fill(0));
  for (let i = 0; i <= m; i++) dp[i][0] = i;
  for (let j = 0; j <= n; j++) dp[0][j] = j;
  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      const cost = a[i - 1] === b[j - 1] ? 0 : 1;
      dp[i][j] = Math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost);
    }
  }
  return dp[m][n];
}

function namesMatch(a, b) {
  const na = normalize(a), nb = normalize(b);
  if (!na || !nb) return false;
  if (na === nb) return true;
  const threshold = Math.max(1, Math.floor(Math.min(na.length, nb.length) * 0.2));
  return levenshtein(na, nb) <= threshold;
}

function teamNameMatches(apiTeamName, requiredClubName) {
  const a = normalize(apiTeamName), b = normalize(requiredClubName);
  if (!a || !b) return false;
  if (a === b) return true;
  if (a.includes(b) || b.includes(a)) return true;
  const threshold = Math.max(2, Math.floor(Math.min(a.length, b.length) * 0.2));
  return levenshtein(a, b) <= threshold;
}

// ---------- API sarğıları (server proxy üzərindən) ----------
async function apiGet(endpoint, params = {}) {
  const query = new URLSearchParams({
    endpoint,
    ...params
  });

  const res = await fetch(
    `../../api/football/proxy.php?${query.toString()}`,
    {
      credentials: 'same-origin'
    }
  );

  if (!res.ok) {
    throw new Error("API sorğusu uğursuz oldu");
  }

  const data = await res.json();

  if (data.success === false) {
    throw new Error(
      data.message || "API sorğusu uğursuz oldu"
    );
  }

  return data;
}

const leagueIdCache = {}; // countryKey -> resolved idLeague

async function resolveLeagueId(country) {
  if (country.leagueId) return country.leagueId;
  if (leagueIdCache[country.key]) return leagueIdCache[country.key];
  const data = await apiGet("search_all_leagues.php", { c: country.key, s: "Soccer" });
  const leagues = data.countrys || data.leagues || [];
  const top = leagues.find(l => /premier|liga|liga|super|top|division 1|1\. liga/i.test(l.strLeague || "")) || leagues[0];
  if (top && top.idLeague) {
    leagueIdCache[country.key] = top.idLeague;
    return top.idLeague;
  }
  return null;
}

async function fetchTeamsByLeague(country) {
  if (teamsCache[country.key]) return teamsCache[country.key];

  let teams = [];

  // 1-ci yol: liqa ID-si ilə cari cədvəl (ən dəqiq divizion filtri)
  try {
    const idLeague = await resolveLeagueId(country);
    if (idLeague) {
      const table = await apiGet("lookuptable.php", { l: idLeague });
      teams = (table.table || [])
        .filter(t => t.strTeam && t.strBadge)
        .map(t => ({ id: t.idTeam, name: t.strTeam, badge: t.strBadge.replace(/\/tiny$/, "") }));
    }
  } catch (e) { /* aşağıdakı fallback-ə keç */ }

  // 2-ci yol: cədvəl boşdursa, ölkə üzrə komanda axtarışına keç
  if (!teams.length) {
    const data = await apiGet("search_all_teams.php", { c: country.key, s: "Soccer" });
    teams = (data.teams || [])
      .filter(t => t.strTeam && t.strTeamBadge)
      .map(t => ({ id: t.idTeam, name: t.strTeam, badge: t.strTeamBadge }));
  }

  teamsCache[country.key] = teams;
  console.log(`"${country.key}" üçün tapılan komandalar:`, teams.length, teams);
  return teams;
}

async function searchPlayer(name) {
  const data = await apiGet("searchplayers.php", { p: name });
  return (data.player || [])[0] || null;
}

async function fetchFormerTeams(playerId) {
  const data = await apiGet("lookupformerteams.php", { id: playerId });
  return (data.formerteams || []).map(t => t.strFormerTeam).filter(Boolean);
}

// ---------- Random seçim ----------
function randomFrom(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

async function randomClub(allowedCountries) {
  const pool = allowedCountries.length
    ? allowedCountries
    : COUNTRIES;

  for (let attempt = 0; attempt < 5; attempt++) {
    const country = randomFrom(pool);

    if (!country) continue;

    try {
      const teams = await fetchTeamsByLeague(country);

      if (teams.length) {
        return {
          club: randomFrom(teams),
          country
        };
      }
    } catch (e) {
      console.warn(
        `"${country.key}" üçün klub tapılmadı:`,
        e
      );
    }
  }

  throw new Error(
    "Klub tapılmadı — tənzimləmələrdə daha çox ölkə seç."
  );
}

// ---------- Ekranlar arası keçid ----------
const views = {
  menu: document.getElementById("menuView"),
  game: document.getElementById("gameView"),
  settings: document.getElementById("settingsView")
};

function showView(name) {
  Object.values(views).forEach(v => v.classList.add("hidden"));
  views[name].classList.remove("hidden");
}

// ---------- Xal göstəricisi ----------
function renderScore() {
  document.getElementById("scoreValue").textContent = score.total;
  document.getElementById("scoreSummary").textContent =
    `Düzgün: ${score.correct}  ·  Səhv: ${score.wrong}`;
}

async function loadScore() {
  const res = await fetch("../../api/score/get.php", {
    credentials: "same-origin"
  });

  if (res.status === 401) {
    showLogin();
    return;
  }

  const data = await res.json();

  if (!data.success) {
    throw new Error(data.message || "Xal yüklənmədi.");
  }

  score = data.data;
  renderScore();
}

async function loadSettings() {
  const res = await fetch("../../api/settings/get.php", {
    credentials: "same-origin"
  });

  if (res.status === 401) {
    showLogin();
    return;
  }

  const data = await res.json();

  if (!data.success) {
    throw new Error(
      data.message || "Tənzimləmələr yüklənmədi."
    );
  }

  settings = data.data;

  COUNTRIES = settings.countries.map(c => ({
    id: Number(c.id),
    key: c.api_key,
    az: c.name_az,
    flag: c.flag,
    leagueId: null
  }));

  countryByKey = Object.fromEntries(
    COUNTRIES.map(c => [c.key, c])
  );

  settings.clubCountries = settings.clubCountries.map(c => ({
    id: Number(c.id),
    key: c.api_key,
    az: c.name_az,
    flag: c.flag,
    leagueId: null
  }));

  settings.nationalTeams = settings.nationalTeams.map(c => ({
    id: Number(c.id),
    key: c.api_key,
    az: c.name_az,
    flag: c.flag,
    leagueId: null
  }));
}



async function startGame(gameMode) {
  const res = await fetch("../../api/game/start.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    credentials: "same-origin",
    body: JSON.stringify({
      mode: gameMode
    })
  });

  if (res.status === 401) {
    showLogin();
    return false;
  }

  const data = await res.json();

  if (!data.success) {
    throw new Error(data.message || "Oyun başlatılmadı.");
  }

  gameId = Number(data.data.game_id);
  mode = data.data.mode;

  return true;
}


async function finishGame() {
  if (!gameId) return;

  const res = await fetch("../../api/game/finish.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    credentials: "same-origin",
    body: JSON.stringify({
      game_id: gameId
    })
  });

  if (res.status === 401) {
    showLogin();
    return;
  }

  const data = await res.json();

  if (!data.success) {
    throw new Error(data.message || "Oyun tamamlanmadı.");
  }

  gameId = null;

  return data.data;
}


// ---------- Timer ----------
const CIRC = 2 * Math.PI * 52;

function startTimer(onExpire) {
  timeLeft = 10;
  answered = false;
  const progressEl = document.getElementById("timerProgress");
  const numberEl = document.getElementById("timerNumber");
  progressEl.classList.remove("danger");
  progressEl.style.strokeDashoffset = "0";
  numberEl.textContent = "10";

  const start = Date.now();
  clearInterval(timerInterval);
  timerInterval = setInterval(() => {
    const elapsed = (Date.now() - start) / 1000;
    const remaining = Math.max(0, 10 - elapsed);
    const frac = remaining / 10;
    progressEl.style.strokeDashoffset = String(CIRC * (1 - frac));
    numberEl.textContent = String(Math.ceil(remaining));
    if (remaining <= 3) progressEl.classList.add("danger");
    if (remaining <= 0) {
      clearInterval(timerInterval);
      timeLeft = 0;
      if (!answered) onExpire();
    }
  }, 100);
}

function stopTimer() {
  clearInterval(timerInterval);
}

// ---------- Oyun sualının qurulması ----------
async function buildQuestion() {
  const feedback = document.getElementById("feedback");
  feedback.textContent = "";
  feedback.className = "feedback";
  document.getElementById("answerInput").value = "";
  document.getElementById("answerInput").disabled = false;
  document.getElementById("submitBtn").disabled = false;

  if (mode === "country-club") {
    if (!settings.nationalTeams.length || !settings.clubCountries.length) {
      feedback.textContent = "Tənzimləmələrdə ən azı bir ölkə yığması və bir klub ölkəsi seç.";
      feedback.className = "feedback wrong";
      return;
    }
    const nation = randomFrom(settings.nationalTeams);
    const { club } = await randomClub(settings.clubCountries);

    current = { type: "country-club", nation, club };

    document.getElementById("sideAImg").src = `https://flagcdn.com/${nation.flag}.svg`;
    document.getElementById("sideAImg").alt = nation.az;
    document.getElementById("sideAName").textContent = nation.az;
    document.getElementById("sideATag").textContent = "Ölkə";

    document.getElementById("sideBImg").src = club.badge;
    document.getElementById("sideBImg").alt = club.name;
    document.getElementById("sideBName").textContent = club.name;
    document.getElementById("sideBTag").textContent = "Klub";
  } else {
    if (!settings.clubCountries.length) {
      feedback.textContent = "Tənzimləmələrdə ən azı bir klub ölkəsi seç.";
      feedback.className = "feedback wrong";
      return;
    }
    let clubA, clubB;
    do {
      clubA = (await randomClub(settings.clubCountries)).club;
      clubB = (await randomClub(settings.clubCountries)).club;
    } while (normalize(clubA.name) === normalize(clubB.name));

    current = { type: "club-club", clubA, clubB };

    document.getElementById("sideAImg").src = clubA.badge;
    document.getElementById("sideAImg").alt = clubA.name;
    document.getElementById("sideAName").textContent = clubA.name;
    document.getElementById("sideATag").textContent = "Klub";

    document.getElementById("sideBImg").src = clubB.badge;
    document.getElementById("sideBImg").alt = clubB.name;
    document.getElementById("sideBName").textContent = clubB.name;
    document.getElementById("sideBTag").textContent = "Klub";
  }

  startTimer(() => finishRound(""));
}

// ---------- Cavabın yoxlanılması ----------
async function verifyAnswer(playerName) {
  if (!playerName.trim()) return { ok: false, reason: "Cavab boş idi." };

  const player = await searchPlayer(playerName.trim());
  if (!player) return { ok: false, reason: "Bu adda oyunçu tapılmadı." };

  if (current.type === "country-club") {
    const nationOk = namesMatch(player.strNationality, current.nation.key);
    let clubOk = teamNameMatches(player.strTeam || "", current.club.name);
    if (!clubOk && player.idPlayer) {
      try {
        const former = await fetchFormerTeams(player.idPlayer);
        clubOk = former.some(t => teamNameMatches(t, current.club.name));
      } catch (e) { /* former teams alınmadı, davam et */ }
    }
    if (nationOk && clubOk) return { ok: true, player };
    if (!nationOk) return { ok: false, reason: `${player.strPlayer} tapıldı, amma millət uyğun gəlmədi.` };
    return { ok: false, reason: `${player.strPlayer} tapıldı, amma bu klubda oynadığı görünmür.` };
  } else {
    const teams = [player.strTeam || ""];
    if (player.idPlayer) {
      try {
        const former = await fetchFormerTeams(player.idPlayer);
        teams.push(...former);
      } catch (e) { /* former teams alınmadı, cari komanda ilə davam */ }
    }
    const matchA = teams.some(t => teamNameMatches(t, current.clubA.name));
    const matchB = teams.some(t => teamNameMatches(t, current.clubB.name));
    if (matchA && matchB) return { ok: true, player };
    return { ok: false, reason: `${player.strPlayer} tapıldı, amma hər iki klubla uyğunluq görmədim.` };
  }
}

async function finishRound(typedName) {
  if (answered) return;

  answered = true;
  stopTimer();

  const feedback = document.getElementById("feedback");

  document.getElementById("answerInput").disabled = true;
  document.getElementById("submitBtn").disabled = true;

  if (!typedName.trim()) {
    feedback.textContent = "⏱ Vaxt bitdi.";
    feedback.className = "feedback wrong";

    await postAnswer({
      playerAnswer: "",
      correctPlayer: "",
      isCorrect: false,
      points: 0
    });

    return;
  }

  feedback.textContent = "Yoxlanılır...";
  feedback.className = "feedback loading";

  try {
    const result = await verifyAnswer(typedName);

    if (result.ok) {
      const bonus = Math.max(0, Math.round(timeLeft * 5));
      const points = 50 + bonus;

      feedback.textContent =
        `✔ Doğrudur! ${result.player.strPlayer} (+${points} xal)`;

      feedback.className = "feedback correct";

      await postAnswer({
        playerId: result.player.idPlayer
          ? Number(result.player.idPlayer)
          : null,
        playerAnswer: typedName,
        correctPlayer: result.player.strPlayer,
        isCorrect: true,
        points
      });

    } else {
      feedback.textContent = `✘ ${result.reason}`;
      feedback.className = "feedback wrong";

      await postAnswer({
        playerAnswer: typedName,
        correctPlayer: "",
        isCorrect: false,
        points: 0
      });
    }

  } catch (e) {
    feedback.textContent =
      "API-yə çatmaq mümkün olmadı, bir az sonra yenidən cəhd et.";

    feedback.className = "feedback wrong";
    console.error(e);
  }
}

async function postAnswer({
  playerId = null,
  playerAnswer = "",
  correctPlayer = "",
  isCorrect = false,
  points = 0
}) {
  if (!gameId || !current) {
    throw new Error("Aktiv oyun tapılmadı.");
  }

  const payload = {
    game_id: gameId,
    question_type: current.type,

    side_a: current.type === "country-club"
      ? current.nation.az
      : current.clubA.name,

    side_b: current.type === "country-club"
      ? current.club.name
      : current.clubB.name,

    side_a_id: current.type === "country-club"
      ? Number(current.nation.id || 0)
      : Number(current.clubA.id || 0),

    side_b_id: current.type === "country-club"
      ? Number(current.club.id || 0)
      : Number(current.clubB.id || 0),

    player_id: playerId,
    player_answer: playerAnswer,
    correct_player: correctPlayer,
    is_correct: isCorrect ? 1 : 0,
    points: points
  };

  const res = await fetch("../../api/game/answer.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    credentials: "same-origin",
    body: JSON.stringify(payload)
  });

  if (res.status === 401) {
    showLogin();
    return;
  }

  const data = await res.json();

  if (!data.success) {
    throw new Error(data.message || "Cavab yadda saxlanılmadı.");
  }

  score = {
    total: data.data.score,
    correct: data.data.correct,
    wrong: data.data.wrong
  };

  renderScore();

  return data.data;
}


// ---------- Tənzimləmələr ekranı ----------
function renderCheckboxList(containerId, selectedCountries) {
  const container = document.getElementById(containerId);

  container.innerHTML = "";

  const selectedIds = new Set(
    selectedCountries.map(c => Number(c.id))
  );

  COUNTRIES.forEach(country => {
    const label = document.createElement("label");
    label.className = "checkbox-row";

    const input = document.createElement("input");

    input.type = "checkbox";
    input.value = country.id;
    input.checked = selectedIds.has(country.id);

    const span = document.createElement("span");
    span.textContent = country.az;

    label.appendChild(input);
    label.appendChild(span);

    container.appendChild(label);
  });
}

function collectChecked(containerId) {
  return Array.from(document.querySelectorAll(`#${containerId} input:checked`)).map(i => i.value);
}

async function openSettings() {
  await loadSettings();
  renderCheckboxList("clubCountryList", settings.clubCountries);
  renderCheckboxList("nationalTeamList", settings.nationalTeams);
  document.getElementById("saveStatus").textContent = "";
  showView("settings");
}

// ---------- Hadisə dinləyiciləri ----------
document.querySelectorAll(".mode-card").forEach(btn => {
  btn.addEventListener("click", async () => {
    const selectedMode = btn.dataset.mode;

    try {
      const started = await startGame(selectedMode);

      if (!started) return;

      mode = selectedMode;

      showView("game");

      document.getElementById("feedback").textContent =
        "Sual hazırlanır...";

      document.getElementById("feedback").className =
        "feedback loading";

      await buildQuestion();

    } catch (e) {
      document.getElementById("feedback").textContent =
        e.message || "Oyun başlatılmadı.";

      document.getElementById("feedback").className =
        "feedback wrong";
    }
  });
});

document.getElementById("answerForm").addEventListener("submit", (e) => {
  e.preventDefault();
  const val = document.getElementById("answerInput").value;
  finishRound(val);
});

document.getElementById("nextBtn").addEventListener("click", async () => {
  document.getElementById("feedback").textContent = "Sual hazırlanır...";
  document.getElementById("feedback").className = "feedback loading";
  try {
    await buildQuestion();
  } catch (e) {
    document.getElementById("feedback").textContent = "Sual yaradıla bilmədi, yenidən cəhd et.";
    document.getElementById("feedback").className = "feedback wrong";
  }
});

document.getElementById("quitBtn").addEventListener("click", async () => {
  stopTimer();

  try {
    await finishGame();
  } catch (e) {
    console.error(e);
  }

  showView("menu");
});

document.getElementById("settingsBtn").addEventListener("click", openSettings);
document.getElementById("backFromSettings").addEventListener("click", () => showView("menu"));

document.getElementById("saveSettingsBtn").addEventListener("click", async () => {
  const clubCountries = collectChecked("clubCountryList");
  const nationalTeams = collectChecked("nationalTeamList");
  const res = await fetch("../../api/settings/save.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    credentials: "same-origin",
    body: JSON.stringify({
      clubCountries,
      nationalTeams
    })
  });

  const data = await res.json();

  if (!data.success) {
    throw new Error(
      data.message || "Tənzimləmələr yadda saxlanılmadı."
    );
  }

  await loadSettings();

  document.getElementById("saveStatus").textContent =
    "Yadda saxlanıldı ✓";

  setTimeout(
    () => (
      document.getElementById("saveStatus").textContent = ""
    ),
    2000
  );
});


// ---------- Başlanğıc ----------
(async function init() {
  try {
    await Promise.all([
      loadScore(),
      loadSettings()
    ]);
  } catch (e) {
    console.error(e);
  }
})();


async function login(username, password) {
  const res = await fetch("../../api/auth/login.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    credentials: "same-origin",
    body: JSON.stringify({
      username,
      password
    })
  });

  const data = await res.json();

  if (!data.success) {
    throw new Error(data.message || "Giriş mümkün olmadı.");
  }

  await Promise.all([
    loadScore(),
    loadSettings()
  ]);

  showView("menu");
}

async function register(username, email, password) {
  const res = await fetch("../../api/auth/register.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    credentials: "same-origin",
    body: JSON.stringify({
      username,
      email,
      password
    })
  });

  const data = await res.json();

  if (!data.success) {
    throw new Error(data.message || "Qeydiyyat mümkün olmadı.");
  }

  await login(username, password);
}

async function logout() {
  if (gameId) {
    try {
      await finishGame();
    } catch (e) {
      console.error(e);
    }
  }

  await fetch("../../api/auth/logout.php", {
    method: "POST",
    credentials: "same-origin"
  });

  gameId = null;
  score = {
    total: 0,
    correct: 0,
    wrong: 0
  };

  showLogin();
}
