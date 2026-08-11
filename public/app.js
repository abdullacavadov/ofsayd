// ---------- Ölkə kataloqu (klub ligası + bayraq kodu ilə) ----------
const COUNTRIES = [
  { key: "England", az: "İngiltərə", leagueId: "4328", flag: "gb-eng" },
  { key: "Spain", az: "İspaniya", leagueId: "4335", flag: "es" },
  { key: "Italy", az: "İtaliya", leagueId: "4332", flag: "it" },
  { key: "Germany", az: "Almaniya", leagueId: "4331", flag: "de" },
  { key: "France", az: "Fransa", leagueId: "4334", flag: "fr" },
  { key: "Portugal", az: "Portuqaliya", leagueId: "4344", flag: "pt" },
  { key: "Netherlands", az: "Niderland", leagueId: "4337", flag: "nl" },
  { key: "Turkey", az: "Türkiyə", leagueId: "4339", flag: "tr" },
  { key: "Brazil", az: "Braziliya", leagueId: "4351", flag: "br" },
  { key: "Argentina", az: "Argentina", leagueId: "4406", flag: "ar" },
  { key: "Belgium", az: "Belçika", leagueId: "4338", flag: "be" },
  { key: "Scotland", az: "Şotlandiya", leagueId: "4330", flag: "gb-sct" },
  { key: "Russia", az: "Rusiya", leagueId: "4355", flag: "ru" },
  { key: "United States", az: "ABŞ", leagueId: "4346", flag: "us" },
  { key: "Azerbaijan", az: "Azərbaycan", leagueId: null, flag: "az" }
];

const countryByKey = Object.fromEntries(COUNTRIES.map(c => [c.key, c]));

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
    `/api/football/proxy.php?${query.toString()}`,
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

async function randomClub(allowedKeys) {
  const pool = allowedKeys.length ? allowedKeys : COUNTRIES.map(c => c.key);
  // bir neçə cəhd et, çünki bəzi liqalarda komanda tapılmaya bilər
  for (let attempt = 0; attempt < 5; attempt++) {
    const countryKey = randomFrom(pool);
    const country = countryByKey[countryKey];
    if (!country) continue;
    try {
      const teams = await fetchTeamsByLeague(country);
      if (teams.length) return { club: randomFrom(teams), country };
    } catch (e) {
      console.warn(`"${country.key}" üçün klub tapılmadı:`, e);
    }
  }
  throw new Error("Klub tapılmadı — tənzimləmələrdə daha çox ölkə seç.");
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
  const res = await fetch("/api/score/get.php", {
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
  const res = await fetch("/api/settings/get.php", {
    credentials: "same-origin"
  });

  if (res.status === 401) {
    showLogin();
    return;
  }

  const data = await res.json();

  if (!data.success) {
    throw new Error(data.message || "Settings yüklənmədi.");
  }

  settings = data.data;
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
    const nation = countryByKey[randomFrom(settings.nationalTeams)];
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
    await postWrong();
    return;
  }

  feedback.textContent = "Yoxlanılır...";
  feedback.className = "feedback loading";

  try {
    const result = await verifyAnswer(typedName);
    if (result.ok) {
      const bonus = Math.max(0, Math.round(timeLeft * 5));
      const points = 50 + bonus;
      feedback.textContent = `✔ Doğrudur! ${result.player.strPlayer} (+${points} xal)`;
      feedback.className = "feedback correct";
      await postCorrect(points);
    } else {
      feedback.textContent = `✘ ${result.reason}`;
      feedback.className = "feedback wrong";
      await postWrong();
    }
  } catch (e) {
    feedback.textContent = "API-yə çatmaq mümkün olmadı, bir az sonra yenidən cəhd et.";
    feedback.className = "feedback wrong";
  }
}

async function postCorrect(points) {
  score = await fetch("/api/score/correct", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ points })
  }).then(r => r.json());
  renderScore();
}

async function postWrong() {
  score = await fetch("/api/score/wrong", { method: "POST" }).then(r => r.json());
  renderScore();
}

// ---------- Tənzimləmələr ekranı ----------
function renderCheckboxList(containerId, selectedKeys) {
  const container = document.getElementById(containerId);
  container.innerHTML = "";
  COUNTRIES.forEach(c => {
    const label = document.createElement("label");
    label.className = "checkbox-row";
    const input = document.createElement("input");
    input.type = "checkbox";
    input.value = c.key;
    input.checked = selectedKeys.includes(c.key);
    const span = document.createElement("span");
    span.textContent = c.az;
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
    mode = btn.dataset.mode;
    showView("game");
    document.getElementById("feedback").textContent = "Sual hazırlanır...";
    document.getElementById("feedback").className = "feedback loading";
    try {
      await buildQuestion();
    } catch (e) {
      document.getElementById("feedback").textContent = "Sual yaradıla bilmədi, yenidən cəhd et.";
      document.getElementById("feedback").className = "feedback wrong";
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

document.getElementById("quitBtn").addEventListener("click", () => {
  stopTimer();
  showView("menu");
});

document.getElementById("settingsBtn").addEventListener("click", openSettings);
document.getElementById("backFromSettings").addEventListener("click", () => showView("menu"));

document.getElementById("saveSettingsBtn").addEventListener("click", async () => {
  const clubCountries = collectChecked("clubCountryList");
  const nationalTeams = collectChecked("nationalTeamList");
  const res = await fetch("/api/settings/save.php", {
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

  settings = data.data;
  document.getElementById("saveStatus").textContent = "Yadda saxlanıldı ✓";
  setTimeout(() => (document.getElementById("saveStatus").textContent = ""), 2000);
});

document.getElementById("resetScoreBtn").addEventListener("click", async () => {
  if (!confirm("Bütün xallar sıfırlansın?")) return;
  score = await fetch("/api/score/reset", { method: "POST" }).then(r => r.json());
  renderScore();
});

// ---------- Başlanğıc ----------
(async function init() {
  await Promise.all([loadScore(), loadSettings()]);
})();
