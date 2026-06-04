import http from "node:http";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const PORT = process.env.PORT || 3000;
const __dirname = dirname(fileURLToPath(import.meta.url));

// NAME may be undefined / empty — we surface a "next steps" guide when it is.
const RAW_NAME = process.env.NAME;
const HAS_NAME = typeof RAW_NAME === "string" && RAW_NAME.trim() !== "";
const NAME = HAS_NAME ? RAW_NAME : null;
const NO_NAME_MESSAGE =
  "Environment variable NAME is not defined. Create a new version of this service, add a configuration with the environment variable 'NAME' and redeploy.";

const escapeHtml = (str) =>
  String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");

// Modstack brand assets (pulled from https://modstack.dev), loaded once at
// startup and served from /assets/*. Keeping them as a fixed allow-list avoids
// any path-traversal concerns.
const ASSETS = {
  "/assets/logo.svg": "logo.svg",
  "/assets/home-bg.svg": "home-bg.svg",
  "/assets/favicon.svg": "favicon.svg",
};
const ASSET_CACHE = Object.fromEntries(
  Object.entries(ASSETS).map(([route, file]) => [
    route,
    readFileSync(join(__dirname, "assets", file)),
  ]),
);

// "Next steps" shown when NAME is missing.
const NEXT_STEPS = [
  {
    title: "Create a new version",
    desc: "Cut a new version of this service in Modstack.",
  },
  {
    title: "Add a configuration",
    desc: "Set the environment variable <code>NAME</code> to the value you want to greet.",
  },
  {
    title: "Redeploy",
    desc: "Roll out the new version — the greeting will pick up the value.",
  },
];

const renderSteps = () => `
        <h2 class="section-title">Next steps</h2>
        <ol class="steps">
          ${NEXT_STEPS.map(
            (step, i) => `<li class="step">
            <span class="step__num">${i + 1}</span>
            <span class="step__text">
              <span class="step__title">${step.title}</span>
              <span class="step__desc">${step.desc}</span>
            </span>
          </li>`,
          ).join("\n          ")}
        </ol>`;

// Render a list of [key, value] pairs as key/value rows.
const renderKvRows = (entries) =>
  entries
    .map(
      ([key, value]) => `<div class="kv">
            <span class="kv__key">${escapeHtml(key)}</span>
            <span class="kv__val">${escapeHtml(
              Array.isArray(value) ? value.join(", ") : value,
            )}</span>
          </div>`,
    )
    .join("\n          ");

const renderHeaders = (req) => renderKvRows(Object.entries(req.headers));

// NOTE: this prints every environment variable visible to the container — in a
// real service that can include secrets. Fine for a sample; add an allow-list
// or redaction before exposing anything sensitive.
const renderEnv = () =>
  renderKvRows(
    Object.entries(process.env).sort(([a], [b]) => a.localeCompare(b)),
  );

// Two-tab panel (Headers / Environment variables) — CSS-only, no JS needed.
const renderTabs = (req) => `
      <div class="tabs">
        <input type="radio" name="tab" id="tab-headers" class="tabs__radio" checked />
        <input type="radio" name="tab" id="tab-env" class="tabs__radio" />
        <div class="tabs__nav">
          <label for="tab-headers" class="tabs__tab">Headers</label>
          <label for="tab-env" class="tabs__tab">Environment variables</label>
        </div>
        <div class="tabs__panel tabs__panel--headers">
          <div class="headers">
          ${renderHeaders(req)}
          </div>
        </div>
        <div class="tabs__panel tabs__panel--env">
          <div class="headers">
          ${renderEnv()}
          </div>
        </div>
      </div>`;

const renderHome = (req) => {
  const title = HAS_NAME
    ? `Hello World by ${escapeHtml(NAME)}`
    : "Hello, World";
  const subtitle = HAS_NAME
    ? "A sample service running on Modstack."
    : "This sample service is running, but it hasn't been configured yet.";

  const statusBlock = HAS_NAME
    ? `<div class="badge">
          <span class="badge__dot"></span>
          Configured via the <code>NAME</code> environment variable
        </div>`
    : `<div class="notice">
          ${escapeHtml(NO_NAME_MESSAGE)}
        </div>
        ${renderSteps()}`;

  return `<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Hello World — Modstack</title>
    <link rel="icon" type="image/svg+xml" href="/assets/favicon.svg" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      html, body {
        min-height: 100%;
        background: #1b1029;
        color: #fff;
        font-family: "Outfit", system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
        font-weight: 300;
        -webkit-font-smoothing: antialiased;
      }
      body { position: relative; overflow-x: hidden; }
      code {
        font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;
        font-size: 0.85em;
        padding: 1px 6px;
        background: rgba(150, 96, 219, 0.15);
        border: 1px solid rgba(150, 96, 219, 0.35);
        border-radius: 4px;
        color: #cbb6ec;
      }

      /* Hero glow + fade, matching modstack.dev */
      .hero-bg, .hero-fade {
        position: absolute; top: 0; left: 50%; transform: translateX(-50%);
        width: 1440px; max-width: none; z-index: 0; pointer-events: none;
      }
      .hero-bg {
        height: 543px;
        background: url("/assets/home-bg.svg") no-repeat center top;
        background-size: cover;
        opacity: 0.9;
      }
      .hero-fade {
        height: 543px;
        background: linear-gradient(180deg, rgba(27, 16, 41, 0.35) 0%, #1b1029 360px);
      }

      .container {
        position: relative; z-index: 1;
        width: 100%; max-width: 720px;
        margin: 0 auto; padding: 56px 24px 80px;
      }

      .logo { display: block; width: 190px; height: auto; margin: 0 auto 56px; }

      .hero { text-align: center; }
      .title {
        font-weight: 600; font-size: 56px; line-height: 1.1; letter-spacing: -0.01em;
        background: linear-gradient(180deg, #ffffff 45%, #9660db 135%);
        -webkit-background-clip: text; background-clip: text;
        -webkit-text-fill-color: transparent; color: transparent;
      }
      .subtitle { margin-top: 18px; font-size: 18px; color: #afa5bd; line-height: 1.5; }

      .hero-line {
        width: 2px; height: 90px; margin: 28px auto 0; border-radius: 1px;
        background: linear-gradient(to bottom, rgba(150, 96, 219, 0) 0%, #9660db 60%, #fff 100%);
      }

      .badge {
        display: inline-flex; align-items: center; gap: 10px;
        margin: 36px auto 0; padding: 10px 18px;
        background: rgba(150, 96, 219, 0.12);
        border: 1px solid rgba(150, 96, 219, 0.4);
        border-radius: 999px; font-size: 14px; color: #cbb6ec;
      }
      .badge__dot {
        width: 8px; height: 8px; border-radius: 50%;
        background: #9660db; box-shadow: 0 0 10px 1px rgba(150, 96, 219, 0.9);
      }

      .notice {
        margin: 40px auto 0; max-width: 540px; padding: 16px 20px;
        background: rgba(245, 158, 11, 0.08);
        border: 1px solid rgba(245, 158, 11, 0.35);
        border-radius: 10px; color: #fcd34d; font-size: 14px; line-height: 1.55;
      }

      .section-title {
        font-size: 13px; font-weight: 600; text-transform: uppercase;
        letter-spacing: 0.1em; color: #8a7f99; margin: 44px 0 14px;
      }

      .steps { list-style: none; display: flex; flex-direction: column; gap: 12px; }
      .step {
        display: flex; align-items: flex-start; gap: 16px; text-align: left;
        padding: 16px 18px; border-radius: 12px;
        background: #221632; border: 1px solid rgba(150, 96, 219, 0.18);
        transition: border-color .2s, background .2s;
      }
      .step:hover { border-color: rgba(150, 96, 219, 0.55); background: #271a3a; }
      .step__num {
        flex-shrink: 0; display: flex; align-items: center; justify-content: center;
        width: 28px; height: 28px; border-radius: 50%;
        background: linear-gradient(180deg, rgba(150,96,219,0.6) 0%, rgba(68,51,136,0.6) 100%), #9660db;
        box-shadow: 0 -1px 0 0 #ab80e2;
        color: #fff; font-size: 14px; font-weight: 600;
      }
      .step__text { display: flex; flex-direction: column; gap: 3px; }
      .step__title { font-size: 14px; font-weight: 600; color: #fff; }
      .step__desc { font-size: 13px; color: #8a7f99; line-height: 1.5; }

      /* CSS-only tabs */
      .tabs__radio { position: absolute; width: 0; height: 0; opacity: 0; pointer-events: none; }
      .tabs__nav {
        display: flex; gap: 4px;
        border-bottom: 1px solid rgba(150, 96, 219, 0.18); margin-bottom: 16px;
      }
      .tabs__tab {
        padding: 10px 16px; font-size: 13px; font-weight: 600; color: #8a7f99;
        cursor: pointer; border-bottom: 2px solid transparent; margin-bottom: -1px;
        transition: color .2s, border-color .2s;
      }
      .tabs__tab:hover { color: #cbb6ec; }
      #tab-headers:checked ~ .tabs__nav label[for="tab-headers"],
      #tab-env:checked ~ .tabs__nav label[for="tab-env"] {
        color: #fff; border-bottom-color: #9660db;
      }
      .tabs__radio:focus-visible ~ .tabs__nav label { outline: 2px solid #9660db; outline-offset: 2px; }
      .tabs__panel { display: none; }
      #tab-headers:checked ~ .tabs__panel--headers,
      #tab-env:checked ~ .tabs__panel--env { display: block; }

      .headers {
        border: 1px solid rgba(150, 96, 219, 0.18); border-radius: 12px;
        overflow: hidden; background: #221632;
      }
      .kv {
        display: grid; grid-template-columns: minmax(120px, 38%) 1fr; gap: 14px;
        padding: 10px 16px; border-bottom: 1px solid rgba(150, 96, 219, 0.12);
        font-size: 13px;
      }
      .kv:last-child { border-bottom: none; }
      .kv__key { font-weight: 600; color: #cbb6ec; word-break: break-all; }
      .kv__val {
        color: #8a7f99; word-break: break-all;
        font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;
      }

      @media (max-width: 560px) {
        .title { font-size: 40px; }
        .subtitle { font-size: 16px; }
        .container { padding: 40px 18px 64px; }
      }
    </style>
  </head>
  <body>
    <div class="hero-bg"></div>
    <div class="hero-fade"></div>
    <main class="container">
      <img class="logo" src="/assets/logo.svg" alt="Modstack" />
      <div class="hero">
        <h1 class="title">${title}</h1>
        <p class="subtitle">${subtitle}</p>
        <div class="hero-line"></div>
      </div>
      ${statusBlock}
      <h2 class="section-title">Inspect</h2>
      ${renderTabs(req)}
    </main>
  </body>
</html>`;
};

const server = http.createServer((req, res) => {
  const path = req.url.split("?")[0];

  if (path === "/healthz") {
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end("ok");
    return;
  }

  if (ASSET_CACHE[path]) {
    res.writeHead(200, {
      "Content-Type": "image/svg+xml",
      "Cache-Control": "public, max-age=3600",
    });
    res.end(ASSET_CACHE[path]);
    return;
  }

  if (path === "/") {
    res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
    res.end(renderHome(req));
    return;
  }

  res.writeHead(404, { "Content-Type": "text/plain" });
  res.end("Not found");
});

server.listen(PORT, () => {
  console.log(
    `Server listening on http://0.0.0.0:${PORT} (NAME=${HAS_NAME ? NAME : "<not set>"})`,
  );
});
