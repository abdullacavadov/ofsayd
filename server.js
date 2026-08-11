const express = require("express");
const fs = require("fs");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;

const DATA_DIR = path.join(__dirname, "data");
const SETTINGS_PATH = path.join(DATA_DIR, "settings.json");
const SCORE_PATH = path.join(DATA_DIR, "score.json");

const DEFAULT_SETTINGS = {
  clubCountries: ["England", "Spain", "Italy", "Germany", "France", "Azerbaijan", "Portugal", "Netherlands"],
  nationalTeams: ["England", "Spain", "Italy", "Germany", "France", "Brazil", "Argentina", "Portugal", "Netherlands", "Azerbaijan", "Turkey", "Belgium"]
};

const DEFAULT_SCORE = { total: 0, correct: 0, wrong: 0 };

function ensureDataFiles() {
  if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });
  if (!fs.existsSync(SETTINGS_PATH)) {
    fs.writeFileSync(SETTINGS_PATH, JSON.stringify(DEFAULT_SETTINGS, null, 2));
  }
  if (!fs.existsSync(SCORE_PATH)) {
    fs.writeFileSync(SCORE_PATH, JSON.stringify(DEFAULT_SCORE, null, 2));
  }
}

function readJSON(filePath, fallback) {
  try {
    return JSON.parse(fs.readFileSync(filePath, "utf-8"));
  } catch (err) {
    return fallback;
  }
}

function writeJSON(filePath, data) {
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
}

ensureDataFiles();

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

// --- Settings ---
app.get("/api/settings", (req, res) => {
  res.json(readJSON(SETTINGS_PATH, DEFAULT_SETTINGS));
});

app.post("/api/settings", (req, res) => {
  const body = req.body || {};
  const clubCountries = Array.isArray(body.clubCountries) ? body.clubCountries : [];
  const nationalTeams = Array.isArray(body.nationalTeams) ? body.nationalTeams : [];
  const settings = { clubCountries, nationalTeams };
  writeJSON(SETTINGS_PATH, settings);
  res.json(settings);
});

// --- Score ---
app.get("/api/score", (req, res) => {
  res.json(readJSON(SCORE_PATH, DEFAULT_SCORE));
});

app.post("/api/score/correct", (req, res) => {
  const points = Number(req.body && req.body.points) || 0;
  const score = readJSON(SCORE_PATH, DEFAULT_SCORE);
  score.total += points;
  score.correct += 1;
  writeJSON(SCORE_PATH, score);
  res.json(score);
});

app.post("/api/score/wrong", (req, res) => {
  const score = readJSON(SCORE_PATH, DEFAULT_SCORE);
  score.wrong += 1;
  writeJSON(SCORE_PATH, score);
  res.json(score);
});

app.post("/api/score/reset", (req, res) => {
  writeJSON(SCORE_PATH, DEFAULT_SCORE);
  res.json(DEFAULT_SCORE);
});

// --- TheSportsDB proxy (CORS problemi yaranmasın deyə server üzərindən keçirik) ---
const SPORTSDB_BASE = "https://www.thesportsdb.com/api/v1/json/123/";

app.get("/api/football/*", async (req, res) => {
  const endpoint = req.params[0]; // e.g. "searchplayers.php"
  const query = req.originalUrl.split("?")[1] || "";
  const targetUrl = `${SPORTSDB_BASE}${endpoint}${query ? "?" + query : ""}`;
  try {
    const upstream = await fetch(targetUrl);
    if (!upstream.ok) {
      return res.status(502).json({ error: "TheSportsDB sorğusu uğursuz oldu" });
    }
    const data = await upstream.json();
    res.json(data);
  } catch (err) {
    res.status(502).json({ error: "Serverdən data çəkilə bilmədi", details: String(err) });
  }
});

app.listen(PORT, () => {
  console.log(`Futbol Bilik Yoxlama server http://localhost:${PORT} ünvanında işləyir`);
});
