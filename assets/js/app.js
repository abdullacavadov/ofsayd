let authMode = "login";

let gameId = null;

let COUNTRIES = [];
let countryByKey = {};

// ---------- Vəziyyət ----------
let settings = {
  clubCountries: [],
  nationalTeams: [],
  leagues: [],
  selectedLeagues: []
};
let score = { total: 0, correct: 0, wrong: 0 };
let mode = null; // "country-club" | "club-club"
let current = null; // cari sualın datası
let timerInterval = null;
let timeLeft = 10;
let answered = false;

const teamsCache = {}; // leagueName -> [{name, badge}]
const leagueTeamsCache = {}; // leagueId -> [{id, name, badge}]
let allLeagueTeamsLoaded = false;

async function fetchTeamsByLeagueId(league) {
  const cacheKey = Number(league.id);

  if (leagueTeamsCache[cacheKey]) {
    return leagueTeamsCache[cacheKey];
  }

  if (!allLeagueTeamsLoaded) {
    const res = await fetch("./api/game/teams.php", {
      credentials: "same-origin"
    });

    if (res.status === 401) {
      showAuth("login");
      return [];
    }

    const data = await res.json();

    if (!data.success) {
      throw new Error(
        data.message || "Klub məlumatları alınmadı."
      );
    }

    data.data.forEach(team => {
      const leagueId = Number(team.league_id);

      if (!leagueTeamsCache[leagueId]) {
        leagueTeamsCache[leagueId] = [];
      }

      leagueTeamsCache[leagueId].push({
        id: Number(team.team_api_id),
        name: team.team_name,
        badge: team.team_badge || ""
      });
    });

    allLeagueTeamsLoaded = true;
  }

  return leagueTeamsCache[cacheKey] || [];
}


async function checkAuth() {
  try {
    const res = await fetch("./api/auth/me.php", {
      credentials: "same-origin"
    });

    const data = await res.json();

    if (!data.success) {
      showAuth("login");
      return;
    }

    await loadSettings();

    showView("menu");

  } catch (error) {
    showAuth("login");
  }
}


async function init() {
  try {
    const res = await fetch("./api/auth/me.php", {
      credentials: "same-origin"
    });

    const data = await res.json();

    if (!data.success) {
      showAuth("login");
      return;
    }

    document
      .getElementById("authenticatedUI")
      .classList.remove("hidden");

    await Promise.all([
      loadScore(),
      loadSettings()
    ]);

    showView("menu");

  } catch (error) {
    console.error(error);

    document
      .getElementById("authenticatedUI")
      .classList.add("hidden");

    showAuth("login");
  }
}

init();


const loginForm = document.getElementById("loginForm");
const registerForm = document.getElementById("registerForm");
const authTitle = document.getElementById("authTitle");
const authSubtitle = document.getElementById("authSubtitle");
const authSwitchBtn = document.getElementById("authSwitchBtn");
const authFeedback = document.getElementById("authFeedback");


function showAuth(mode = "login") {
  authMode = mode;

  authTitle.textContent =
    mode === "login" ? "Daxil ol" : "Qeydiyyatdan keç";

  authSubtitle.textContent =
    mode === "login"
      ? "Oyuna davam etmək üçün hesabına daxil ol."
      : "Oynamağa başlamaq üçün hesab yarat.";

  loginForm.classList.toggle("hidden", mode !== "login");
  registerForm.classList.toggle("hidden", mode !== "register");

  authSwitchBtn.textContent =
    mode === "login"
      ? "Hesabın yoxdur? Qeydiyyatdan keç"
      : "Artıq hesabın var? Daxil ol";

  authFeedback.textContent = "";

  showView("auth");
}


document.getElementById("loginForm").addEventListener("submit", async (e) => {
  e.preventDefault();

  const login = document.getElementById("loginInput").value.trim();
  const password = document.getElementById("loginPassword").value;

  const feedback = document.getElementById("authFeedback");

  feedback.textContent = "";

  try {
    const res = await fetch("./api/auth/login.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      credentials: "same-origin",
      body: JSON.stringify({
        login,
        password
      })
    });

    const data = await res.json();

    if (!data.success) {
      throw new Error(
        data.message || "Login uğursuz oldu."
      );
    }

    loginForm.reset();

    document.getElementById("authenticatedUI").classList.remove("hidden");

    await loadSettings();

    showView("menu");

  } catch (error) {
    authFeedback.textContent = error.message;
  }
});



document.getElementById("registerForm").addEventListener("submit", async (e) => {
  e.preventDefault();

  const username =
    document.getElementById("registerUsername").value.trim();

  const email =
    document.getElementById("registerEmail").value.trim();

  const password =
    document.getElementById("registerPassword").value;

  authFeedback.textContent = "";

  try {
    const res = await fetch("./api/auth/register.php", {
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
      throw new Error(
        data.message || "Qeydiyyat uğursuz oldu."
      );
    }

    registerForm.reset();

    document.getElementById("authenticatedUI").classList.remove("hidden");

    await loadSettings();

    showView("menu");

  } catch (error) {
    authFeedback.textContent = error.message;
  }
});


document.getElementById("authSwitchBtn").addEventListener("click", () => {
  showAuth(
    authMode === "login"
      ? "register"
      : "login"
  );
});


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
    `./api/football/proxy.php?${query.toString()}`,
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
  const selectedLeagueIds = new Set(
    (settings.selectedLeagues || []).map(id => Number(id))
  );

  const allowedCountryIds = new Set(
    (allowedCountries || []).map(country => Number(country.id))
  );

  const availableLeagues = (settings.leagues || []).filter(league => {
    const leagueId = Number(league.id);
    const countryId = Number(league.country_id);

    return (
      selectedLeagueIds.has(leagueId) &&
      allowedCountryIds.has(countryId)
    );
  });

  if (!availableLeagues.length) {
    throw new Error(
      "Seçilmiş ölkələr üzrə heç bir liqa seçilməyib."
    );
  }

  for (let attempt = 0; attempt < 5; attempt++) {
    const league = randomFrom(availableLeagues);

    if (!league) continue;

    try {
      const teams = await fetchTeamsByLeagueId(league);

      if (!teams.length) {
        continue;
      }

      const club = randomFrom(teams);

      const country = (allowedCountries || []).find(
        c => Number(c.id) === Number(league.country_id)
      );

      return {
        club,
        country,
        league
      };

    } catch (e) {
      console.warn(
        `"${league.name}" liqasından klublar alınmadı:`,
        e
      );
    }
  }

  throw new Error(
    "Seçilmiş liqalardan klub tapılmadı."
  );
}

// ---------- Ekranlar arası keçid ----------
const views = {
  auth: document.getElementById("authView"),
  menu: document.getElementById("menuView"),
  game: document.getElementById("gameView"),
  settings: document.getElementById("settingsView")
};

function showView(name) {
  Object.values(views).forEach(v => {
    v.classList.add("hidden");
  });

  if (!views[name]) {
    console.error(`View tapılmadı: ${name}`);
    return;
  }

  views[name].classList.remove("hidden");
}

// ---------- Xal göstəricisi ----------
function renderScore() {
  // Ümumi istifadəçi xalı
  const scoreValue = document.getElementById("scoreValue");

  if (scoreValue) {
    scoreValue.textContent = Number(score.totalScore || 0);
  }


  // Cari oyun statistikası
  const totalQuestions = document.getElementById("gameTotalQuestions");
  const correct = document.getElementById("gameCorrect");
  const wrong = document.getElementById("gameWrong");
  const skipped = document.getElementById("gameSkipped");
  const gameScore = document.getElementById("gameGameScore");

  if (totalQuestions) {
    totalQuestions.textContent = Number(score.totalQuestions || 0);
  }

  if (correct) {
    correct.textContent = Number(score.correct || 0);
  }

  if (wrong) {
    wrong.textContent = Number(score.wrong || 0);
  }

  if (skipped) {
    skipped.textContent = Number(score.skipped || 0);
  }

  if (gameScore) {
    gameScore.textContent = Number(score.total || 0);
  }
}

async function loadScore() {
  const res = await fetch("./api/score/get.php", {
    credentials: "same-origin"
  });

  if (res.status === 401) {
    showAuth("login");
    return;
  }

  const data = await res.json();

  if (!data.success) {
    throw new Error(data.message || "Xal yüklənmədi.");
  }

  score = {
    total: data.data.game?.game_score || 0,
    correct: data.data.game?.correct || 0,
    wrong: data.data.game?.wrong || 0,
    totalQuestions: data.data.game?.total_questions || 0,
    skipped: data.data.game?.skipped || 0,
    totalScore: data.data.total_score || 0
  };

  renderScore();
}

async function loadSettings() {
  const res = await fetch("./api/settings/get.php", {
    credentials: "same-origin"
  });

  if (res.status === 401) {
    showAuth("login");
    return;
  }

  const data = await res.json();

  if (!data.success) {
    throw new Error(
      data.message || "Tənzimləmələr yüklənmədi."
    );
  }

  settings = data.data;

  settings.clubCountries = settings.clubCountries.map(c => ({
    id: Number(c.id),
    key: c.api_key,
    az: c.name_az,
    flag: c.flag,
    leagueId: null
  }));

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

  settings.selectedClubCountries =
    settings.selectedClubCountries.map(Number);

  settings.selectedNationalTeams =
    settings.selectedNationalTeams.map(Number);

  renderLeagues();
}



async function startGame(gameMode) {
  const res = await fetch("./api/game/start.php", {
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
    showAuth("login");
    return false;
  }

  const data = await res.json();

  if (!data.success) {
    throw new Error(data.message || "Oyun başlatılmadı.");
  }

  gameId = Number(data.data.game_id);

  const scoreValue = document.getElementById("scoreValue");

  if (scoreValue) {
    scoreValue.textContent = Number(data.data.score || 0);
  }

  return true;
}


async function finishGame() {
  if (!gameId) return;

  const res = await fetch("./api/game/finish.php", {
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
    showAuth("login");
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

    if (
      !settings.selectedNationalTeams ||
      !settings.selectedNationalTeams.length
    ) {
      feedback.textContent =
        "Tənzimləmələrdə ən azı bir milli komanda ölkəsi seç.";

      feedback.className = "feedback wrong";
      return;
    }

    if (!settings.clubCountries.length) {
      feedback.textContent =
        "Tənzimləmələrdə ən azı bir klub ölkəsi seç.";

      feedback.className = "feedback wrong";
      return;
    }

    if (!settings.selectedLeagues || !settings.selectedLeagues.length) {
      feedback.textContent =
        "Tənzimləmələrdə ən azı bir liqa seç.";

      feedback.className = "feedback wrong";
      return;
    }

    const selectedNationalTeams = settings.nationalTeams.filter(
      country => settings.selectedNationalTeams.includes(Number(country.id))
    );

    const nation = randomFrom(selectedNationalTeams);

    const {
      club,
      country,
      league
    } = await randomClub(settings.clubCountries);

    current = {
      type: "country-club",
      nation,
      club,
      country,
      league
    };

    document.getElementById("sideAImg").src = `https://flagcdn.com/${nation.flag}.svg`;
    document.getElementById("sideAImg").alt = nation.az;
    document.getElementById("sideAName").textContent = nation.az;
    document.getElementById("sideATag").textContent = "Ölkə";

    document.getElementById("sideBImg").src = `https://r2.thesportsdb.com/images/media/team/badge/${club.badge}.png/medium`;
    document.getElementById("sideBImg").alt = club.name;
    document.getElementById("sideBName").textContent = club.name;
    document.getElementById("sideBTag").textContent = "Klub";
  } else {

    if (!settings.clubCountries.length) {
      feedback.textContent =
        "Tənzimləmələrdə ən azı bir klub ölkəsi seç.";

      feedback.className = "feedback wrong";
      return;
    }

    if (!settings.selectedLeagues || !settings.selectedLeagues.length) {
      feedback.textContent =
        "Tənzimləmələrdə ən azı bir liqa seç.";

      feedback.className = "feedback wrong";
      return;
    }

    let resultA;
    let resultB;

    do {
      resultA = await randomClub(settings.clubCountries);
      resultB = await randomClub(settings.clubCountries);
    } while (
      normalize(resultA.club.name) === normalize(resultB.club.name)
    );

    const clubA = resultA.club;
    const clubB = resultB.club;

    current = {
      type: "club-club",
      clubA,
      clubB,
      leagueA: resultA.league,
      leagueB: resultB.league,
      countryA: resultA.country,
      countryB: resultB.country
    };

    document.getElementById("sideAImg").src = `https://r2.thesportsdb.com/images/media/team/badge/${clubA.badge}.png/medium`;
    document.getElementById("sideAImg").alt = clubA.name;
    document.getElementById("sideAName").textContent = clubA.name;
    document.getElementById("sideATag").textContent = "Klub";

    document.getElementById("sideBImg").src = `https://r2.thesportsdb.com/images/media/team/badge/${clubB.badge}.png/medium`;
    document.getElementById("sideBImg").alt = clubB.name;
    document.getElementById("sideBName").textContent = clubB.name;
    document.getElementById("sideBTag").textContent = "Klub";
  }

  const questionRes = await fetch("./api/game/question.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    credentials: "same-origin",
    body: JSON.stringify({
      game_id: gameId
    })
  });

  if (questionRes.status === 401) {
    showAuth("login");
    return;
  }

  const questionData = await questionRes.json();

  if (!questionData.success) {
    throw new Error(
      questionData.message || "Sual yadda saxlanılmadı."
    );
  }

  score.totalQuestions = Number(
    questionData.data.total_questions || 0
  );

  score.correct = Number(
    questionData.data.correct || 0
  );

  score.wrong = Number(
    questionData.data.wrong || 0
  );

  score.skipped = Number(
    questionData.data.skipped || 0
  );

  score.total = Number(
    questionData.data.game_score || 0
  );

  renderScore();

  startQuestionTimerVisual();

  startTimer(() => finishRound(""));
}

// ---------- Cavabın yoxlanılması ----------
async function verifyAnswer(playerName) {
  if (!playerName.trim()) return { ok: false, reason: "Cavab boş idi." };

  const player = await searchPlayer(playerName.trim());
  if (!player) return { ok: false, reason: "Bu adda oyunçu tapılmadı. Növbəti suala hazırlaş" };

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
    if (!nationOk) return { ok: false, reason: `${player.strPlayer} tapıldı, amma millət uyğun gəlmədi. Növbəti suala hazırlaş.` };
    return { ok: false, reason: `${player.strPlayer} tapıldı, amma bu klubda oynadığı görünmür. Növbəti suala hazırlaş.` };
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
    return { ok: false, reason: `${player.strPlayer} tapıldı, amma hər iki klubla uyğunluq görmədim. Növbəti suala hazırlaş.` };
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
    feedback.textContent = "⏱ Vaxt bitdi. Növbəti suala hazırlaş.";
    feedback.className = "feedback wrong";

    await postAnswer({
      playerAnswer: "",
      correctPlayer: "",
      isCorrect: false,
      points: 0,
      skipped: true
    });

    await startNextQuestionCountdown();

    await buildQuestion();

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

      await startNextQuestionCountdown();

      await buildQuestion();

      return;

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

    await startNextQuestionCountdown();

    await buildQuestion();

    return;

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
  points = 0,
  skipped = false
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
    points: points,
    skipped: skipped ? 1 : 0
  };

  const res = await fetch("./api/game/answer.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    credentials: "same-origin",
    body: JSON.stringify(payload)
  });

  if (res.status === 401) {
    showAuth("login");
    return;
  }

  const data = await res.json();

  if (!data.success) {
    throw new Error(data.message || "Cavab yadda saxlanılmadı.");
  }

  score = {
    total: data.data.game_score,
    correct: data.data.correct,
    wrong: data.data.wrong,
    totalQuestions: data.data.total_questions,
    skipped: data.data.skipped || 0,
    totalScore: data.data.total_score
  };


  // İstifadəçinin bütün oyunlar üzrə ümumi xalı
  const scoreValue = document.getElementById("scoreValue");

  if (scoreValue) {
    scoreValue.textContent = Number(data.data.total_score || 0);
  }

  renderScore();

  return data.data;
}


function renderLeagues() {
  const container = document.getElementById("leagueList");

  container.innerHTML = "";

  const selectedCountryIds = new Set(
    Array.from(
      document.querySelectorAll("#clubCountryList input:checked")
    ).map(input => Number(input.value))
  );

  const selectedLeagueIds = new Set(
    (settings.selectedLeagues || []).map(id => Number(id))
  );

  const leagues = (settings.leagues || []).filter(league =>
    selectedCountryIds.has(Number(league.country_id))
  );

  leagues.forEach(league => {
    const label = document.createElement("label");
    label.className = "checkbox-row";

    const checkbox = document.createElement("input");

    checkbox.type = "checkbox";
    checkbox.value = Number(league.id);
    checkbox.className = "league-checkbox";
    checkbox.checked = selectedLeagueIds.has(Number(league.id));

    const img = document.createElement("img");
    img.className = "setting-icon league-banner";
    img.src = league.banner ? `https://r2.thesportsdb.com/images/media/league/badge/${league.banner}.png/small` : "";
    img.alt = league.name_az || league.name;
    img.loading = "lazy";

    const span = document.createElement("span");
    span.textContent = league.name_az || league.name;

    label.appendChild(checkbox);

    if (league.banner) {
      label.appendChild(img);
    }

    label.appendChild(span);

    container.appendChild(label);
  });
}




// ---------- Tənzimləmələr ekranı ----------
function renderCheckboxList(
  containerId,
  countries,
  selectedIds
) {
  const container = document.getElementById(containerId);

  container.innerHTML = "";

  const selected = new Set(
    selectedIds.map(Number)
  );

  countries.forEach(country => {
    const label = document.createElement("label");
    label.className = "checkbox-row";

    const input = document.createElement("input");

    input.type = "checkbox";
    input.value = country.id;
    input.checked = selected.has(Number(country.id));

    const img = document.createElement("img");
    img.className = "setting-icon country-flag";
    img.src = `https://flagcdn.com/w40/${country.flag}.png`;
    img.alt = country.az;
    img.loading = "lazy";

    const span = document.createElement("span");
    span.textContent = country.az;

    label.appendChild(input);
    label.appendChild(img);
    label.appendChild(span);

    container.appendChild(label);

    if (containerId === "clubCountryList") {
      input.addEventListener("change", () => {
        renderLeagues();
      });
    }
  });
}


function collectChecked(containerId) {
  return Array.from(document.querySelectorAll(`#${containerId} input:checked`)).map(i => i.value);
}

async function openSettings() {
  await loadSettings();

  renderCheckboxList(
    "clubCountryList",
    settings.clubCountries,
    settings.selectedClubCountries
  );

  renderCheckboxList(
    "nationalTeamList",
    settings.nationalTeams,
    settings.selectedNationalTeams
  );

  renderLeagues();

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

function startQuestionTimerVisual() {
  const nextBtn = document.getElementById("nextBtn");

  if (!nextBtn) return;

  nextBtn.disabled = false;

  nextBtn.classList.remove("next-btn-timer");
  nextBtn.classList.remove("next-btn-countdown");

  void nextBtn.offsetWidth;

  nextBtn.classList.add("next-btn-timer");
}



function startNextQuestionCountdown() {
  const nextBtn = document.getElementById("nextBtn");

  if (!nextBtn) {
    return Promise.resolve();
  }

  nextBtn.disabled = true;

  nextBtn.classList.remove("next-btn-timer");
  nextBtn.classList.remove("next-btn-countdown");

  void nextBtn.offsetWidth;

  nextBtn.classList.add("next-btn-countdown");

  return new Promise((resolve) => {
    setTimeout(() => {
      nextBtn.classList.remove("next-btn-countdown");
      nextBtn.disabled = false;

      resolve();
    }, 3000);
  });
}

document.getElementById("answerForm").addEventListener("submit", (e) => {
  e.preventDefault();
  const val = document.getElementById("answerInput").value;
  finishRound(val);
});

document.getElementById("nextBtn").addEventListener("click", async () => {
  const nextBtn = document.getElementById("nextBtn");
  const feedback = document.getElementById("feedback");

  if (nextBtn.disabled) {
    return;
  }

  try {

    if (!answered) {

      answered = true;
      stopTimer();

      document.getElementById("answerInput").disabled = true;
      document.getElementById("submitBtn").disabled = true;

      feedback.textContent = "⏭ Sual buraxıldı. Növbəti suala hazırlaş";
      feedback.className = "feedback wrong";

      await postAnswer({
        playerAnswer: "",
        correctPlayer: "",
        isCorrect: false,
        points: 0,
        skipped: true
      });

      await startNextQuestionCountdown();

      await buildQuestion();

      return;
    }

    await buildQuestion();

  } catch (e) {

    console.error(e);

    nextBtn.disabled = false;

    feedback.textContent =
      "Sual yaradıla bilmədi, yenidən cəhd et.";

    feedback.className = "feedback wrong";
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
document.getElementById("logoutBtn").addEventListener("click", logout);

document.getElementById("saveSettingsBtn").addEventListener("click", async () => {
  const clubCountries = collectChecked("clubCountryList");
  const nationalTeams = collectChecked("nationalTeamList");

  const leagues = Array.from(
    document.querySelectorAll(".league-checkbox:checked")
  ).map(input => Number(input.value));

  const res = await fetch("./api/settings/save.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    credentials: "same-origin",
    body: JSON.stringify({
      clubCountries,
      nationalTeams,
      leagues
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




async function logout() {
  if (gameId) {
    try {
      await finishGame();
    } catch (e) {
      console.error(e);
    }
  }

  await fetch("./api/auth/logout.php", {
    method: "POST",
    credentials: "same-origin"
  });

  gameId = null;
  score = {
    total: 0,
    correct: 0,
    wrong: 0
  };

  document.getElementById("authenticatedUI").classList.add("hidden");

  showAuth("login");
}
