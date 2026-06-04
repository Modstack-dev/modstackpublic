import http from "node:http";

const PORT = process.env.PORT || 3000;

// NAME may be undefined / empty — we surface a helpful message when it is.
const RAW_NAME = process.env.NAME;
const HAS_NAME = typeof RAW_NAME === "string" && RAW_NAME.trim() !== "";
const NAME = HAS_NAME ? RAW_NAME : null;
const NO_NAME_MESSAGE =
  "Environment variable name is not defined. In the next version please add a configuration with the environment variable name";

const escapeHtml = (str) =>
  String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");

const greetingHtml = HAS_NAME
  ? `Hello World by ${escapeHtml(NAME)}`
  : "Hello World";

// Resolve the client IP. Behind a k8s ingress / load balancer the socket
// address is the proxy, so prefer the left-most X-Forwarded-For entry.
const getClientIp = (req) => {
  const xff = req.headers["x-forwarded-for"];
  if (xff) {
    return xff.split(",")[0].trim();
  }
  const ip = req.socket.remoteAddress || "";
  // Normalize IPv4-mapped IPv6 addresses (e.g. ::ffff:1.2.3.4).
  return ip.replace(/^::ffff:/, "");
};

const isPrivateIp = (ip) =>
  !ip ||
  ip === "::1" ||
  ip === "127.0.0.1" ||
  /^10\./.test(ip) ||
  /^192\.168\./.test(ip) ||
  /^172\.(1[6-9]|2\d|3[01])\./.test(ip) ||
  /^fe80:/i.test(ip) ||
  /^fc00:/i.test(ip);

// Guesstimate location from IP using the free, key-less ip-api.com service.
// Returns a human-readable string; never throws.
const guessLocation = async (ip) => {
  if (isPrivateIp(ip)) {
    return "a private/local network (no public geolocation available)";
  }
  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 2000);
    const res = await fetch(
      `http://ip-api.com/json/${encodeURIComponent(ip)}?fields=status,message,city,regionName,country`,
      { signal: controller.signal },
    );
    clearTimeout(timeout);
    const data = await res.json();
    if (data.status !== "success") {
      return `unknown (${data.message || "lookup failed"})`;
    }
    return [data.city, data.regionName, data.country].filter(Boolean).join(", ");
  } catch {
    return "unknown (geolocation lookup unavailable)";
  }
};

// Render all incoming request headers as a definition list.
const renderHeaders = (req) =>
  Object.entries(req.headers)
    .map(
      ([key, value]) =>
        `<dt>${escapeHtml(key)}</dt><dd>${escapeHtml(
          Array.isArray(value) ? value.join(", ") : value,
        )}</dd>`,
    )
    .join("\n        ");

const renderPage = (body) => `<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Hello World</title>
    <style>
      body {
        font-family: system-ui, sans-serif;
        display: flex;
        min-height: 100vh;
        margin: 0;
        align-items: center;
        justify-content: center;
        background: #0f172a;
        color: #f8fafc;
      }
      .card { text-align: center; }
      h1 { font-size: 2.5rem; margin-bottom: 0.5rem; }
      dl { display: inline-grid; grid-template-columns: auto auto; gap: 0.25rem 1rem; text-align: left; }
      dt { color: #94a3b8; }
      dd { margin: 0; word-break: break-all; }
      a { color: #38bdf8; }
      h2 { font-size: 1.1rem; color: #94a3b8; margin-top: 2rem; }
      .warn {
        margin: 1rem auto 0;
        max-width: 28rem;
        padding: 0.75rem 1rem;
        border: 1px solid #f59e0b;
        border-radius: 0.5rem;
        background: rgba(245, 158, 11, 0.12);
        color: #fcd34d;
      }
    </style>
  </head>
  <body>
    <div class="card">
      ${body}
    </div>
  </body>
</html>`;

const server = http.createServer(async (req, res) => {
  const path = req.url.split("?")[0];

  if (path === "/healthz") {
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end("ok");
    return;
  }

  if (path === "/advanced") {
    const ip = getClientIp(req);
    const location = await guessLocation(ip);
    const body = `<h1>${greetingHtml}</h1>
      <dl>
        <dt>Your IP</dt><dd>${escapeHtml(ip || "unknown")}</dd>
        <dt>Guessed location</dt><dd>${escapeHtml(location)}</dd>
      </dl>`;
    res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
    res.end(renderPage(body));
    return;
  }

  if (path === "/") {
    const warning = HAS_NAME
      ? ""
      : `<p class="warn">${escapeHtml(NO_NAME_MESSAGE)}</p>`;
    const body = `<h1>${greetingHtml}</h1>
      ${warning}
      <p><a href="/advanced">See advanced details &rarr;</a></p>
      <h2>Request headers</h2>
      <dl>
        ${renderHeaders(req)}
      </dl>`;
    res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
    res.end(renderPage(body));
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
