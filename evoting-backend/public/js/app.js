
const API = 'http://localhost:3000/api';

// ── SESSION ───────────────────────────────────────────────────────────────────
const Session = {
  set(user) { sessionStorage.setItem('user', JSON.stringify(user)); },
  get()     { try { return JSON.parse(sessionStorage.getItem('user')); } catch { return null; } },
  clear()   { sessionStorage.removeItem('user'); sessionStorage.removeItem('selElection'); },
  require() {
    const u = this.get();
    if (!u) { window.location.href = '/'; return null; }
    return u;
  }
};

const SelElection = {
  set(e) { sessionStorage.setItem('selElection', JSON.stringify(e)); },
  get()  { try { return JSON.parse(sessionStorage.getItem('selElection')); } catch { return null; } },
};

// ── API HELPERS ───────────────────────────────────────────────────────────────
async function apiFetch(path, options = {}) {
  const res = await fetch(API + path, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || 'Request failed');
  return data;
}

// ── TOAST ─────────────────────────────────────────────────────────────────────
let _tt;
function showToast(msg, type = 'info') {
  let el = document.getElementById('toast');
  if (!el) {
    el = document.createElement('div');
    el.id = 'toast';
    el.className = 'toast';
    el.innerHTML = '<span class="toast-icon" id="toast-icon"></span><span id="toast-msg"></span>';
    document.body.appendChild(el);
  }
  const icons = { success:'✅', error:'❌', info:'ℹ️', warn:'⚠️' };
  document.getElementById('toast-icon').textContent = icons[type] || 'ℹ️';
  document.getElementById('toast-msg').textContent  = msg;
  el.classList.add('show');
  clearTimeout(_tt);
  _tt = setTimeout(() => el.classList.remove('show'), 3500);
}

// ── NAVBAR ────────────────────────────────────────────────────────────────────
function initNavbar() {
  const user = Session.get();
  if (!user) return;
  const initials = user.name.split(' ').map(w => w[0]).slice(-2).join('').toUpperCase();
  document.querySelectorAll('.nav-avatar').forEach(el   => el.textContent = initials);
  document.querySelectorAll('.nav-user-name').forEach(el => el.textContent = user.name);
}

function logout() {
  Session.clear();
  window.location.href = '/';
}

// ── BADGE ─────────────────────────────────────────────────────────────────────
function badge(status) {
  const map = {
    ACTIVE:'b-active', UPCOMING:'b-upcoming', CLOSED:'b-closed', VERIFIED:'b-verified',
    PENDING:'b-pending', SUSPENDED:'b-suspended',
    CRITICAL:'b-critical', HIGH:'b-high', MEDIUM:'b-medium', LOW:'b-low',
  };
  return `<span class="badge ${map[status] || 'b-closed'}">${status}</span>`;
}

// ── LOADING SPINNER ───────────────────────────────────────────────────────────
function setLoading(id, on) {
  const el = document.getElementById(id);
  if (!el) return;
  if (on) { el.dataset.orig = el.innerHTML; el.innerHTML = '⏳ Loading...'; el.disabled = true; }
  else    { el.innerHTML = el.dataset.orig || el.innerHTML; el.disabled = false; }
}
