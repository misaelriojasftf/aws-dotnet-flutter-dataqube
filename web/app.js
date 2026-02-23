(function () {
  const config = window.COGNITO_CONFIG;
  const statusEl = document.getElementById("status");
  const loginBtn = document.getElementById("login-btn");
  const logoutBtn = document.getElementById("logout-btn");
  const sessionKey = "cognito_id_token";

  if (
    !config ||
    !config.domain ||
    !config.clientId ||
    !config.redirectSignIn ||
    !config.redirectSignOut
  ) {
    statusEl.textContent = "Estado: falta configurar web/cognito-config.js";
    throw new Error("COGNITO_CONFIG incompleto.");
  }

  function toUrl(base, params) {
    const url = new URL(base);
    Object.entries(params).forEach(([key, value]) => {
      url.searchParams.set(key, value);
    });
    return url.toString();
  }

  function readTokensFromHash() {
    const hash = window.location.hash.startsWith("#")
      ? window.location.hash.slice(1)
      : "";
    const params = new URLSearchParams(hash);
    const idToken = params.get("id_token");
    if (idToken) {
      localStorage.setItem(sessionKey, idToken);
      history.replaceState(null, "", window.location.pathname);
    }
  }

  function isLoggedIn() {
    return Boolean(localStorage.getItem(sessionKey));
  }

  function updateStatus() {
    statusEl.textContent = isLoggedIn()
      ? "Estado: autenticado (token en localStorage)"
      : "Estado: no autenticado";
  }

  function buildLoginUrl() {
    const authorizeUrl = `${config.domain}/oauth2/authorize`;
    return toUrl(authorizeUrl, {
      response_type: config.responseType || "token",
      client_id: config.clientId,
      redirect_uri: config.redirectSignIn,
      scope: (config.scopes || ["openid", "email", "profile"]).join(" "),
    });
  }

  function buildLogoutUrl() {
    const logoutUrl = `${config.domain}/logout`;
    return toUrl(logoutUrl, {
      client_id: config.clientId,
      logout_uri: config.redirectSignOut,
    });
  }

  loginBtn.addEventListener("click", () => {
    window.location.href = buildLoginUrl();
  });

  logoutBtn.addEventListener("click", () => {
    localStorage.removeItem(sessionKey);
    window.location.href = buildLogoutUrl();
  });

  readTokensFromHash();
  updateStatus();
})();
