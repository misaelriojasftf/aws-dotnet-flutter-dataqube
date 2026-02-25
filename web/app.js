(function () {
  const config = window.COGNITO_CONFIG;
  const statusEl = document.getElementById("status");
  const messageEl = document.getElementById("message");
  const errorEl = document.getElementById("error");
  const loginBtn = document.getElementById("login-btn");
  const logoutBtn = document.getElementById("logout-btn");
  const uploadBtn = document.getElementById("upload-btn");
  const listBtn = document.getElementById("list-btn");
  const fileInput = document.getElementById("file-input");
  const authOnlyEl = document.getElementById("auth-only");
  const photosGridEl = document.getElementById("photos-grid");

  const sessionKey = "cognito_id_token";
  let s3Client = null;

  if (
    !config ||
    !config.domain ||
    !config.clientId ||
    !config.redirectSignIn ||
    !config.redirectSignOut ||
    !config.region ||
    !config.userPoolId ||
    !config.identityPoolId ||
    !config.s3Bucket
  ) {
    statusEl.textContent = "Estado: falta configurar web/cognito-config.js";
    throw new Error("COGNITO_CONFIG incompleto.");
  }

  function clearMessages() {
    messageEl.textContent = "";
    errorEl.textContent = "";
  }

  function setError(message) {
    errorEl.textContent = message;
  }

  function setMessage(message) {
    messageEl.textContent = message;
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

  function getIdToken() {
    return localStorage.getItem(sessionKey);
  }

  function isLoggedIn() {
    return Boolean(getIdToken());
  }

  function updateStatus() {
    const loggedIn = isLoggedIn();
    statusEl.textContent = loggedIn
      ? "Estado: autenticado"
      : "Estado: no autenticado";
    authOnlyEl.style.display = loggedIn ? "block" : "none";

    if (!loggedIn) {
      photosGridEl.innerHTML = "";
    }
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

  async function initAwsClients() {
    const idToken = getIdToken();
    if (!idToken) {
      s3Client = null;
      return;
    }

    const providerName = `cognito-idp.${config.region}.amazonaws.com/${config.userPoolId}`;

    AWS.config.region = config.region;
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({
      IdentityPoolId: config.identityPoolId,
      Logins: {
        [providerName]: idToken,
      },
    });

    try {
      await AWS.config.credentials.getPromise();
      s3Client = new AWS.S3({
        apiVersion: "2006-03-01",
        params: { Bucket: config.s3Bucket },
      });
    } catch (err) {
      s3Client = null;
      throw err;
    }
  }

  function makeObjectKey(fileName) {
    const basePrefix = config.s3Prefix || "uploads/";
    const normalizedPrefix = basePrefix.endsWith("/")
      ? basePrefix
      : `${basePrefix}/`;
    const safeName = fileName.replace(/[^a-zA-Z0-9._-]/g, "_");
    return `${normalizedPrefix}${Date.now()}_${safeName}`;
  }

  async function uploadPhoto() {
    clearMessages();

    if (!s3Client) {
      setError("No hay cliente S3. Inicia sesion primero.");
      return;
    }

    const file = fileInput.files && fileInput.files[0];
    if (!file) {
      setError("Selecciona una imagen antes de subir.");
      return;
    }

    const key = makeObjectKey(file.name);

    try {
      await s3Client
        .putObject({
          Bucket: config.s3Bucket,
          Key: key,
          Body: file,
          ContentType: file.type || "image/jpeg",
        })
        .promise();

      setMessage(`Foto subida: ${key}`);
      fileInput.value = "";
      await listPhotos();
    } catch (err) {
      setError(`Error subiendo foto: ${err.message || err}`);
    }
  }

  function renderPhotos(items) {
    photosGridEl.innerHTML = "";

    if (!items.length) {
      photosGridEl.innerHTML = "<p>No hay fotos aun.</p>";
      return;
    }

    items.forEach((item) => {
      const signedUrl = s3Client.getSignedUrl("getObject", {
        Bucket: config.s3Bucket,
        Key: item.Key,
        Expires: 300,
      });

      const card = document.createElement("div");
      card.className = "photo-item";
      card.innerHTML = `
        <img src="${signedUrl}" alt="${item.Key}" loading="lazy" />
        <p>${item.Key}</p>
      `;
      photosGridEl.appendChild(card);
    });
  }

  async function listPhotos() {
    clearMessages();

    if (!s3Client) {
      setError("No hay cliente S3. Inicia sesion primero.");
      return;
    }

    const prefix = config.s3Prefix || "uploads/";

    try {
      const response = await s3Client
        .listObjectsV2({
          Bucket: config.s3Bucket,
          Prefix: prefix,
          MaxKeys: 100,
        })
        .promise();

      const items = (response.Contents || [])
        .filter((obj) => obj.Key && obj.Key !== prefix)
        .sort((a, b) => new Date(b.LastModified) - new Date(a.LastModified));

      renderPhotos(items);
      setMessage(`Fotos encontradas: ${items.length}`);
    } catch (err) {
      setError(`Error listando fotos: ${err.message || err}`);
    }
  }

  loginBtn.addEventListener("click", () => {
    window.location.href = buildLoginUrl();
  });

  logoutBtn.addEventListener("click", () => {
    localStorage.removeItem(sessionKey);
    clearMessages();
    updateStatus();
    window.location.href = buildLogoutUrl();
  });

  uploadBtn.addEventListener("click", uploadPhoto);
  listBtn.addEventListener("click", listPhotos);

  async function bootstrap() {
    readTokensFromHash();
    updateStatus();

    if (!isLoggedIn()) {
      return;
    }

    try {
      await initAwsClients();
      await listPhotos();
    } catch (err) {
      setError(
        `Sesion iniciada, pero no se pudieron obtener credenciales AWS: ${
          err.message || err
        }`
      );
    }
  }

  bootstrap();
})();
