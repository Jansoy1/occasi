<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5"/>
<title>Dashboard — Occasi</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Inter:wght@400;500;600;700&family=Cinzel:wght@400;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/theme.css">
<style>
.dash-grid{display:grid;grid-template-columns:240px 1fr;gap:24px;max-width:1200px;margin:0 auto;padding:20px}
.sidebar{position:sticky;top:80px;align-self:start;background:#fff;border:1px solid var(--line);border-radius:14px;padding:18px}
.side-name{font-size:14px;font-weight:700;color:var(--ink);word-break:break-word}
.side-email{font-size:11px;color:var(--muted);margin-bottom:14px;word-break:break-word}
.side-nav a{display:block;padding:9px 12px;border-radius:8px;font-size:13px;color:var(--ink2);margin-bottom:3px;cursor:pointer}
.side-nav a:hover{background:#f5edff;color:var(--c2);text-decoration:none}
.side-nav a.active{background:linear-gradient(135deg,rgba(61,78,200,.1),rgba(160,64,216,.1));color:var(--c2);font-weight:700}

.main{min-width:0}
.card{background:#fff;border:1px solid var(--line);border-radius:14px;padding:24px;margin-bottom:16px}
.card h2{font-family:'Playfair Display',serif;font-size:22px;font-weight:700;color:var(--ink);margin-bottom:6px}
.card .sub{font-size:13px;color:var(--muted);margin-bottom:18px}
.section-title{font-size:11px;font-weight:700;letter-spacing:.12em;text-transform:uppercase;color:var(--c2);margin:20px 0 10px;padding-top:14px;border-top:1px dashed var(--line)}
.section-title:first-of-type{margin-top:0;padding-top:0;border-top:none}

/* Empty state */
.empty{text-align:center;padding:40px 20px}
.empty-icon{font-size:54px;margin-bottom:14px}
.empty h2{font-family:'Playfair Display',serif;font-size:24px;color:var(--ink);margin-bottom:8px}
.empty p{font-size:14px;color:var(--ink2);max-width:380px;margin:0 auto 18px;line-height:1.6}

/* Site card */
.site-status{display:inline-flex;align-items:center;gap:5px;font-size:10px;font-weight:700;letter-spacing:.1em;text-transform:uppercase;padding:4px 10px;border-radius:10px;margin-bottom:10px}
.site-status.live{background:linear-gradient(135deg,#22c55e,#16a34a);color:#fff}
.site-status.draft{background:rgba(245,158,11,.15);color:#b45309}
.site-status::before{content:'●';font-size:8px}
.url-box{display:flex;gap:8px;flex-wrap:wrap;align-items:center;margin-bottom:10px}
.url-text{flex:1;min-width:240px;padding:9px 12px;background:#faf6ff;border:1px solid var(--line);border-radius:8px;font-size:12px;color:var(--c2);font-family:monospace;word-break:break-all}

/* Go live card */
.golive{background:linear-gradient(135deg,rgba(34,197,94,.08),rgba(22,163,74,.08));border:2px solid rgba(34,197,94,.3);border-radius:12px;padding:16px;margin:16px 0;text-align:center}
.golive h4{font-size:14px;font-weight:700;color:#16a34a;margin-bottom:5px}
.golive p{font-size:12px;color:var(--ink2);margin-bottom:12px}
.golive button{padding:11px 28px;background:linear-gradient(135deg,#22c55e,#16a34a);color:#fff;border:none;border-radius:24px;font-size:12px;font-weight:700;letter-spacing:.1em;text-transform:uppercase;cursor:pointer;font-family:'Inter',sans-serif}
.golive.is-live h4{color:#b45309}
.golive.is-live{background:linear-gradient(135deg,rgba(245,158,11,.08),rgba(217,119,6,.08));border-color:rgba(245,158,11,.3)}
.golive.is-live button{background:linear-gradient(135deg,#f59e0b,#d97706)}

/* Template picker grid */
.tplgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:12px}
.tplcard{border:1px solid var(--line);border-radius:12px;overflow:hidden;cursor:pointer;transition:all .2s;background:#fff}
.tplcard:hover{transform:translateY(-2px);box-shadow:var(--shadow);border-color:var(--c2)}
.tplcard.selected{border-color:var(--c2);box-shadow:0 0 0 3px rgba(122,62,200,.18)}
.tplprev{height:110px;display:flex;align-items:center;justify-content:center;font-family:'Playfair Display',serif;font-style:italic;font-weight:700;font-size:14px;text-align:center;padding:14px}
.tplinfo{padding:10px 12px}
.tplname{font-size:13px;font-weight:700;color:var(--ink)}
.tpldesc{font-size:11px;color:var(--ink2);margin-top:2px}

/* Sharing area */
.share-box{background:linear-gradient(135deg,rgba(122,62,200,.04),rgba(160,64,216,.04));border:1px solid var(--line-purple);border-radius:12px;padding:18px;margin-top:8px}
.share-label{font-size:11px;font-weight:700;letter-spacing:.12em;text-transform:uppercase;color:var(--c2);margin-bottom:8px}
.code-block{background:#fff;border:1px solid var(--line);border-radius:8px;padding:11px;font-family:monospace;font-size:11px;color:var(--c2);word-break:break-all;margin-bottom:10px}
.share-buttons{display:flex;gap:8px;flex-wrap:wrap}

/* QR display */
#qrDisplay{margin-top:16px;padding:18px;background:#fff;border-radius:12px;text-align:center;border:1px solid var(--line);display:none}
#qrDisplay.show{display:block}
#qrImage{display:block;margin:0 auto 12px;max-width:240px;width:100%;border-radius:6px}
.qr-caption{font-size:11px;color:var(--muted);margin-bottom:10px}

/* Photo uploader */
.photo-slot{margin-bottom:14px;border:1px solid var(--line);border-radius:12px;padding:14px;background:#fafafa}
.photo-slot-label{font-size:12px;color:var(--muted);margin-bottom:10px;font-weight:600;letter-spacing:.04em}
.photo-add-btn{display:flex;align-items:center;justify-content:center;gap:12px;padding:18px;border:2px dashed var(--line);border-radius:10px;cursor:pointer;background:#fff;color:var(--c2);transition:border-color .2s,background .2s;min-height:80px;text-align:left}
.photo-add-btn:hover{border-color:var(--c2);background:#faf6ff}
.photo-filled{display:flex;align-items:center;gap:14px;flex-wrap:wrap}
.photo-filled img{width:140px;height:90px;object-fit:cover;border-radius:8px;border:1px solid var(--line);flex-shrink:0}
.photo-actions{display:flex;flex-direction:column;gap:6px}
.btn-photo-action{padding:8px 16px;font-size:12px;font-weight:600;background:#fff;border:1px solid var(--line);border-radius:8px;cursor:pointer;text-align:center;color:var(--c2);font-family:'Inter',sans-serif}
.btn-photo-action:hover{background:#faf6ff}
.btn-photo-action.remove{color:#dc2626;border-color:#fca5a5}
.btn-photo-action.remove:hover{background:#fef2f2}
.photo-status{font-size:11px;margin-top:8px;min-height:14px;font-family:'Inter',sans-serif}
.photo-status.uploading{color:var(--c2)}
.photo-status.error{color:#dc2626}
.photo-status.success{color:#16a34a}
@media(max-width:480px){
  .photo-filled img{width:100%;height:160px}
  .photo-actions{flex-direction:row;width:100%}
  .photo-actions .btn-photo-action{flex:1}
}

.danger-zone{margin-top:24px;padding:16px;border:1.5px dashed #fca5a5;border-radius:12px;background:#fef2f2}
.danger-zone h4{margin:0 0 6px;font-size:13px;color:#991b1b;font-weight:700}
.danger-zone p{font-size:12px;color:#7f1d1d;margin:0 0 10px;line-height:1.5}
.btn-danger-solid{background:#dc2626;color:#fff;border:none;padding:8px 16px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer}
.btn-danger-solid:hover{background:#b91c1c}
.rsvp-card{
  background:#fff;
  border:1px solid #e6dccf;
  border-radius:22px;
  padding:24px;
  margin-bottom:14px;
  box-shadow:0 12px 30px rgba(0,0,0,.05);
  position:relative;
  overflow:hidden;
}
.rsvp-card::before{
  content:"";
  position:absolute;
  top:0;left:0;right:0;
  height:3px;
  background:linear-gradient(to right,transparent,#8fa89b,transparent);
}
.rsvp-badge{
  display:inline-block;
  font-family:'Inter',sans-serif;
  font-size:10px;
  letter-spacing:.15em;
  text-transform:uppercase;
  color:#5a7d6c;
  padding:5px 12px;
  border:1px solid #d6e2db;
  border-radius:999px;
  background:#eef3f0;
  margin-bottom:18px;
  font-weight:600;
}
.rsvp-name-grid{
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:18px;
  margin-bottom:18px;
}
.rsvp-field-label{
  font-family:'Inter',sans-serif;
  font-size:10px;
  color:#7a7a7a;
  letter-spacing:.12em;
  text-transform:uppercase;
  margin-bottom:4px;
  font-weight:600;
}
.rsvp-field-value{
  font-family:'Playfair Display',Georgia,serif;
  font-size:24px;
  color:#2f2f2f;
  font-weight:500;
  line-height:1.2;
}
.rsvp-meta{
  border-top:1px solid #e6dccf;
  padding-top:14px;
  display:flex;
  align-items:center;
  gap:8px;
  font-family:'Inter',sans-serif;
  font-size:12px;
  color:#7a7a7a;
}
.rsvp-meta::before{
  content:"❦";
  color:#8fa89b;
  font-size:14px;
}
.rsvp-empty{
  padding:50px 30px;
  text-align:center;
  color:#7a7a7a;
  background:#faf7f2;
  border:1px solid #e6dccf;
  border-radius:22px;
  font-family:'Playfair Display',Georgia,serif;
  font-style:italic;
  font-size:16px;
}

.section-page{display:none}
.section-page.active{display:block}

/* Site switcher banner (shown when user has multiple sites) */
.switcher{background:#fff4e6;border:1.5px solid #f59e0b;padding:14px;border-radius:10px;margin-bottom:14px}
.switcher-title{font-size:13px;font-weight:700;color:#b45309;margin-bottom:6px}
.switcher-sub{font-size:12px;color:#92400e;margin-bottom:12px;line-height:1.4}
.switcher-row{display:flex;align-items:center;gap:8px;padding:10px;margin-bottom:6px;border-radius:8px;border:1px solid transparent;background:transparent;flex-wrap:wrap}
.switcher-row.current{background:#fff;border-color:#f59e0b}
.switcher-info{flex:1;min-width:0;font-size:12px;font-family:monospace;word-break:break-all;line-height:1.5}
.switcher-info .viewing{display:inline-block;background:#f59e0b;color:#fff;padding:2px 7px;border-radius:4px;font-family:'Inter',sans-serif;font-size:10px;font-weight:700;letter-spacing:.05em;margin-left:4px}
.switcher-actions{display:flex;gap:6px;flex-shrink:0}
.switcher-actions .btn{font-size:12px;padding:8px 14px;min-height:36px}
.switcher-actions .btn-danger{color:#cc2020;border-color:#cc2020}

@media(max-width:780px){
  .dash-grid{grid-template-columns:1fr;padding:14px}
  .sidebar{position:static}
  .side-nav{display:flex;gap:6px;overflow-x:auto;padding-bottom:4px}
  .side-nav a{flex-shrink:0;white-space:nowrap;font-size:12px}
  /* Stack switcher rows vertically so the View/Delete buttons get full width and are tappable */
  .switcher-row{flex-direction:column;align-items:stretch;gap:10px}
  .switcher-actions{width:100%}
  .switcher-actions .btn{flex:1;min-height:42px;font-size:13px}
  .rsvp-card{padding:20px}
  .rsvp-field-value{font-size:20px}
}
@media(max-width:480px){
  .rsvp-name-grid{grid-template-columns:1fr;gap:14px}
}
</style>
</head>
<body>

<nav class="top-nav">
  <a href="index.html" class="brand-logo"><img src="assets/logo.png" class="logo-img" alt="Occasi"><span class="logo-text">OCCASI</span></a>
  <div class="top-nav-right">
    <a href="#" id="logoutBtn" class="btn btn-ghost btn-sm">Sign out</a>
  </div>
</nav>

<div class="dash-grid">

  <aside class="sidebar">
    <div class="side-name" id="sName">Loading…</div>
    <div class="side-email" id="sEmail">—</div>
    <nav class="side-nav">
      <a class="active" data-section="overview">🏠 Overview</a>
      <a data-section="mysite">🌐 My Site</a>
      <a data-section="responses">📋 RSVPs</a>
    </nav>
  </aside>

  <main class="main">

    <!-- OVERVIEW -->
    <div class="section-page active" id="page-overview">
      <div class="card" id="overviewCard">
        <h2>Welcome</h2>
        <p class="sub">Loading your dashboard…</p>
      </div>
    </div>

    <!-- MY SITE -->
    <div class="section-page" id="page-mysite">

      <!-- Template picker (shown when no site) -->
      <div class="card" id="pickerCard" style="display:none">
        <h2>Choose Your Template</h2>
        <p class="sub">Pick a design to get started. You can change it later.</p>
        <div class="tplgrid" id="tplGrid"></div>
      </div>

      <!-- Editor (shown when site exists) -->
      <div class="card" id="editorCard" style="display:none">
        <h2>Edit Your Site</h2>
        <p class="sub">Customise your details, then save and go live.</p>

        <div class="section-title">Site URL</div>
        <div class="field">
          <label>URL slug (lowercase, no spaces)</label>
          <input id="eSlug" placeholder="john-emma-2026">
          <div style="font-size:11px;color:var(--muted);margin-top:5px">Your invitation will be at: <span id="slugPreview" style="color:var(--c2);font-family:monospace">—</span></div>
        </div>

        <div class="field">
          <label>Template</label>
          <select id="eTemplate"></select>
        </div>

        <div class="section-title">Event Details</div>
        <div class="field-row">
          <div class="field"><label>Partner 1 / Name</label><input id="eP1" placeholder="e.g. John"></div>
          <div class="field"><label>Partner 2 (optional)</label><input id="eP2" placeholder="e.g. Emma"></div>
        </div>
        <div class="field-row">
          <div class="field"><label>Event Date</label><input id="eDate" type="date"></div>
          <div class="field"><label>RSVP Deadline</label><input id="eDeadline" type="date"></div>
        </div>
        <div class="field"><label>Venue</label><input id="eVenue" placeholder="e.g. The Grand Hall, London"></div>
        <div class="field"><label>Invitation Message</label><textarea id="eTagline" rows="3" placeholder="We would be delighted for you to join us…"></textarea></div>

        <div class="section-title">Photos for Slideshow</div>
        <p style="font-size:12px;color:var(--ink2);margin-bottom:12px;line-height:1.6">
          Add up to 3 photos from your phone or computer. Optional — leave any slot blank for a decorative fallback.
          One photo = static hero. Two or three = automatic slideshow on your RSVP page.
        </p>

        <div class="photo-slot" id="photoSlot1">
          <div class="photo-slot-label">Photo 1</div>
          <input type="file" id="eImg1File" accept="image/*" hidden>
          <input type="hidden" id="eImg1">
          <label for="eImg1File" class="photo-add-btn" id="eImg1Add">
            <span style="font-size:22px">📷</span>
            <div>
              <div style="font-weight:600">Add Photo</div>
              <div style="font-size:11px;color:var(--muted);font-weight:400;margin-top:2px">Tap to choose from your device</div>
            </div>
          </label>
          <div class="photo-filled" id="eImg1Filled" style="display:none">
            <img id="eImg1Preview" alt="Photo 1">
            <div class="photo-actions">
              <label for="eImg1File" class="btn-photo-action">Replace</label>
              <button type="button" class="btn-photo-action remove" data-slot="1">Remove</button>
            </div>
          </div>
          <div class="photo-status" id="eImg1Status"></div>
        </div>

        <div class="photo-slot" id="photoSlot2">
          <div class="photo-slot-label">Photo 2 (optional)</div>
          <input type="file" id="eImg2File" accept="image/*" hidden>
          <input type="hidden" id="eImg2">
          <label for="eImg2File" class="photo-add-btn" id="eImg2Add">
            <span style="font-size:22px">📷</span>
            <div>
              <div style="font-weight:600">Add Photo</div>
              <div style="font-size:11px;color:var(--muted);font-weight:400;margin-top:2px">Tap to choose from your device</div>
            </div>
          </label>
          <div class="photo-filled" id="eImg2Filled" style="display:none">
            <img id="eImg2Preview" alt="Photo 2">
            <div class="photo-actions">
              <label for="eImg2File" class="btn-photo-action">Replace</label>
              <button type="button" class="btn-photo-action remove" data-slot="2">Remove</button>
            </div>
          </div>
          <div class="photo-status" id="eImg2Status"></div>
        </div>

        <div class="photo-slot" id="photoSlot3">
          <div class="photo-slot-label">Photo 3 (optional)</div>
          <input type="file" id="eImg3File" accept="image/*" hidden>
          <input type="hidden" id="eImg3">
          <label for="eImg3File" class="photo-add-btn" id="eImg3Add">
            <span style="font-size:22px">📷</span>
            <div>
              <div style="font-weight:600">Add Photo</div>
              <div style="font-size:11px;color:var(--muted);font-weight:400;margin-top:2px">Tap to choose from your device</div>
            </div>
          </label>
          <div class="photo-filled" id="eImg3Filled" style="display:none">
            <img id="eImg3Preview" alt="Photo 3">
            <div class="photo-actions">
              <label for="eImg3File" class="btn-photo-action">Replace</label>
              <button type="button" class="btn-photo-action remove" data-slot="3">Remove</button>
            </div>
          </div>
          <div class="photo-status" id="eImg3Status"></div>
        </div>

        <div class="section-title">Invite Size & Sharing</div>
        <p style="font-size:12px;color:var(--ink2);margin-bottom:12px;line-height:1.6">Set a default size for all invitations. Below, generate custom links &amp; QR codes for specific families.</p>

        <div class="field">
          <label>Default Invite Size</label>
          <select id="eInviteSize">
            <option value="1">1 guest (singles)</option>
            <option value="2" selected>2 guests (couples)</option>
            <option value="3">3 guests</option>
            <option value="4">4 guests (family)</option>
            <option value="5">5 guests</option>
            <option value="6">6 guests</option>
            <option value="8">8 guests</option>
            <option value="10">10 guests</option>
            <option value="12">12 guests</option>
          </select>
        </div>

        <!-- ✨ Custom URL & QR builder ✨ -->
        <div class="share-box">
          <div class="share-label">🎯 Generate Family Link &amp; QR Code</div>
          <p style="font-size:12px;color:var(--ink2);margin-bottom:12px;line-height:1.6">Pick how many guests for this specific family/group. We'll generate a custom URL and a downloadable QR code.</p>
          <div class="field">
            <label>Number of guests for this link</label>
            <input id="qrSize" type="number" min="1" max="20" value="2" style="max-width:120px">
          </div>

          <div class="share-label" style="margin-top:14px">Custom URL</div>
          <div class="code-block" id="customUrl">—</div>

          <div class="share-buttons">
            <button class="btn btn-ghost btn-sm" id="copyBtn" type="button">📋 Copy URL</button>
            <button class="btn btn-grad btn-sm" id="qrBtn" type="button">🔲 Generate QR Code</button>
          </div>

          <div id="qrDisplay">
            <img id="qrImage" src="" alt="QR Code">
            <div class="qr-caption" id="qrCaption">QR for 2 guests</div>
            <button class="btn btn-grad btn-sm" id="dlBtn" type="button">⬇ Download PNG</button>
          </div>
        </div>

        <!-- Go Live -->
        <div class="golive" id="goLive">
          <h4 id="goLiveTitle">🚀 Ready to share with guests?</h4>
          <p id="goLiveDesc">Click "Go Live" to make your site visible to guests.</p>
          <button id="goLiveBtn">Go Live</button>
        </div>

        <div class="msg" id="editMsg"></div>
        <button class="btn btn-grad btn-lg" id="saveBtn" style="width:100%;margin-top:10px">💾 Save Changes</button>

        <div style="text-align:center;margin-top:14px">
          <a href="#" id="changeTplLink" style="font-size:12px;color:var(--muted);text-decoration:underline">Change template</a>
        </div>

        <div class="danger-zone">
          <h4>⚠ Danger Zone</h4>
          <p>Permanently delete this site and all its RSVP responses. This cannot be undone.</p>
          <button class="btn-danger-solid" id="deleteSiteBtn" type="button">🗑 Delete This Site</button>
        </div>
      </div>
    </div>

    <!-- RSVPs -->
    <div class="section-page" id="page-responses">
      <div class="card">
        <h2>RSVP Responses</h2>
        <p class="sub" id="rsvpSubtitle">Loading…</p>
        <div style="margin-bottom:18px;display:flex;gap:8px;flex-wrap:wrap">
          <button class="btn btn-ghost btn-sm" id="refreshBtn">🔄 Refresh</button>
          <button class="btn btn-grad btn-sm" id="exportBtn">⬇ Download CSV</button>
        </div>
        <div id="rsvpList"></div>
      </div>
    </div>

  </main>
</div>

<script src="js/occasi-auth.js"></script>
<script>
/* 5 templates */
var TEMPLATES = [
  { n: "Garden Romance",   d: "Cream paper, sage green, classic elegance.",  bg: "linear-gradient(135deg,#faf7f2,#f3eee6)", fg: "#3d4a30" },
  { n: "Midnight Glamour", d: "Black with gold accents, art-deco feel.",     bg: "linear-gradient(135deg,#0d0a18,#1a1428)", fg: "#d4a574" },
  { n: "Rustic Barn",      d: "Warm browns, hand-written script.",           bg: "#fdf8ec",                                  fg: "#5a4030" },
  { n: "Modern Minimal",   d: "Clean white, asymmetric, bold typography.",   bg: "#fafaf7",                                  fg: "#1a1a1a" },
  { n: "Rose Gold",        d: "Soft pink florals, romantic.",                bg: "linear-gradient(135deg,#fce0d8,#f8c8c0)", fg: "#8a3a2c" }
];

var currentUser = null;
var siteData = null;
var contentData = null;

function onSupabaseReady() {
  bootstrap();
}

async function bootstrap() {
  if (!supabase) return;
  var { data: { user } } = await supabase.auth.getUser();
  if (!user) { window.location.href = "login.html"; return; }
  currentUser = user;

  document.getElementById("sName").textContent = user.user_metadata?.full_name || user.email;
  document.getElementById("sEmail").textContent = user.email;

  await loadUserSite();
  buildTemplateGrid();
  populateTemplateSelect();
}

async function loadUserSite() {
  /* Get ALL the user's sites, newest first */
  var { data: sites, error } = await supabase
    .from("sites")
    .select("*")
    .eq("user_id", currentUser.id)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("loadUserSite error:", error);
    document.getElementById("overviewCard").innerHTML =
      '<h2>Error loading site</h2><p class="sub">' + error.message + '</p>';
    return;
  }

  window._allSites = sites || [];

  if (sites && sites.length > 0) {
    /* Pick which site to show. Priority:
       1. Explicit ?site_id in the URL (user is switching sites)
       2. The site that actually has RSVP responses (the one guests are using)
       3. The most-recently-created LIVE site (guests can only submit to live ones)
       4. The most-recently-created site (fallback when nothing is live yet)
       This fixes the bug where new draft sites would hide RSVPs collected
       on an older live site by silently becoming the dashboard's default. */
    var urlSiteId = new URLSearchParams(location.search).get("site_id");
    siteData = urlSiteId && sites.find(function(s) { return s.id === urlSiteId; });

    if (!siteData && sites.length > 1) {
      /* Look up which sites have RSVPs — pick the one with the most. */
      var siteIds = sites.map(function(s) { return s.id; });
      var { data: rsvpRows } = await supabase
        .from("rsvp_responses").select("site_id").in("site_id", siteIds);
      if (rsvpRows && rsvpRows.length > 0) {
        var counts = {};
        rsvpRows.forEach(function(r) { counts[r.site_id] = (counts[r.site_id] || 0) + 1; });
        var bestId = Object.keys(counts).sort(function(a, b) { return counts[b] - counts[a]; })[0];
        siteData = sites.find(function(s) { return s.id === bestId; });
        console.log("[Occasi] Multiple sites detected — defaulting to the one with RSVPs:", siteData.subdomain, "(" + counts[bestId] + " responses)");
      }
    }

    if (!siteData) {
      /* No RSVPs anywhere yet — prefer the newest LIVE site over the newest draft. */
      var liveSites = sites.filter(function(s) { return s.status === "live"; });
      siteData = liveSites[0] || sites[0];
    }

    var { data: content } = await supabase
      .from("site_content").select("*").eq("site_id", siteData.id).maybeSingle();
    contentData = content || {};
    renderHasSiteState();
  } else {
    siteData = null;
    contentData = null;
    renderEmptyState();
  }
}

function renderEmptyState() {
  document.getElementById("overviewCard").innerHTML =
    '<div class="empty">' +
    '  <div class="empty-icon">✨</div>' +
    '  <h2>Welcome to Occasi!</h2>' +
    '  <p>You don\'t have a site yet. Choose a template to get started.</p>' +
    '  <button class="btn btn-grad btn-lg" onclick="switchSection(\'mysite\')">Choose Template →</button>' +
    '</div>';

  document.getElementById("pickerCard").style.display = "block";
  document.getElementById("editorCard").style.display = "none";
}

function renderHasSiteState() {
  var n1 = contentData.partner_1 || "—";
  var n2 = contentData.partner_2 || "";
  var title = n2 ? n1 + " & " + n2 : n1;
  var url = window.location.origin + "/rsvp.html?site=" + (siteData.subdomain || "");
  var statusClass = siteData.status === "live" ? "live" : "draft";
  var statusLabel = siteData.status === "live" ? "Live" : "Draft";

  /* Site switcher block — shown only if user has multiple sites */
  var sites = window._allSites || [];
  var switcherHtml = "";
  if (sites.length > 1) {
    switcherHtml =
      '<div class="switcher">' +
      '<div class="switcher-title">⚠️ You have ' + sites.length + ' sites in your account</div>' +
      '<div class="switcher-sub">Pick one to manage. Delete duplicates to keep things tidy.</div>' +
      sites.map(function(s) {
        var isCurrent = s.id === siteData.id;
        var statusBadge = s.status === "live" ? "🟢 LIVE" : "📝 draft";
        var viewingBadge = isCurrent ? '<span class="viewing">VIEWING</span>' : '';
        var viewBtn = isCurrent ? '' :
          '<button class="btn btn-ghost btn-sm" onclick="switchToSite(\'' + s.id + '\')">View</button>';
        return '<div class="switcher-row' + (isCurrent ? ' current' : '') + '">' +
                 '<div class="switcher-info">' + escapeHtml(s.subdomain || "(no slug)") + ' · ' + statusBadge + viewingBadge + '</div>' +
                 '<div class="switcher-actions">' +
                   viewBtn +
                   '<button class="btn btn-ghost btn-sm btn-danger" onclick="deleteSite(\'' + s.id + '\',\'' + (s.subdomain || "") + '\')">Delete</button>' +
                 '</div>' +
               '</div>';
      }).join('') +
      '</div>';
  }

  document.getElementById("overviewCard").innerHTML =
    switcherHtml +
    '<span class="site-status ' + statusClass + '">' + statusLabel + '</span>' +
    '<h2>' + escapeHtml(title) + '</h2>' +
    '<p class="sub">' + escapeHtml(siteData.template_name || "—") + ' · Site ID: <code style="font-size:11px">' + siteData.id.slice(0,8) + '…</code></p>' +
    '<div class="url-box">' +
    '  <div class="url-text">' + escapeHtml(url) + '</div>' +
    '  <button class="btn btn-ghost btn-sm" onclick="copyToClipboard(\'' + url.replace(/'/g, "\\'") + '\')">Copy</button>' +
    '  <button class="btn btn-grad btn-sm" onclick="window.open(\'' + url.replace(/'/g, "\\'") + '\',\'_blank\')">View ↗</button>' +
    '</div>' +
    '<div style="display:flex;gap:8px;margin-top:14px;flex-wrap:wrap">' +
    '  <button class="btn btn-grad btn-sm" onclick="switchSection(\'mysite\')">✏️ Edit Site</button>' +
    '  <button class="btn btn-ghost btn-sm" onclick="switchSection(\'responses\')">📋 View RSVPs</button>' +
    '  <button class="btn btn-ghost btn-sm" onclick="window.createAnotherSite()">➕ Create Another Site</button>' +
    '</div>';

  /* Populate editor */
  document.getElementById("pickerCard").style.display = "none";
  document.getElementById("editorCard").style.display = "block";

  document.getElementById("eSlug").value = siteData.subdomain || "";
  document.getElementById("eTemplate").value = siteData.template_name || "Garden Romance";
  document.getElementById("eP1").value = contentData.partner_1 || "";
  document.getElementById("eP2").value = contentData.partner_2 || "";
  document.getElementById("eDate").value = contentData.wedding_date || "";
  document.getElementById("eDeadline").value = contentData.rsvp_deadline || "";
  document.getElementById("eVenue").value = contentData.venue_name || "";
  document.getElementById("eTagline").value = contentData.tagline || "";
  document.getElementById("eInviteSize").value = contentData.invite_size_default || 2;

  /* Photos */
  ["1","2","3"].forEach(function(n) {
    renderPhotoSlot(n, contentData["image_url_" + n] || "");
  });

  /* Sync qrSize to default */
  document.getElementById("qrSize").value = contentData.invite_size_default || 2;

  updateSlugPreview();
  updateCustomUrl();

  /* Go-live state */
  updateGoLiveCard();

  loadResponses();
}

/* Switch to a specific site */
window.switchToSite = function(siteId) {
  var url = new URL(window.location);
  url.searchParams.set("site_id", siteId);
  window.location.href = url.toString();
};

/* Show the template picker so the user can spin up a second site */
window.createAnotherSite = function() {
  switchSection("mysite");
  /* Reveal the picker even though a current site exists */
  document.getElementById("pickerCard").style.display = "block";
  document.getElementById("editorCard").style.display = "none";
  document.getElementById("pickerCard").scrollIntoView({ behavior: "smooth" });
};

/* Delete a site */
window.deleteSite = async function(siteId, slug) {
  if (!confirm("Delete site '" + slug + "'?\n\nThis will permanently delete the site and ALL its RSVP responses. Cannot be undone.")) return;

  var { error } = await supabase.from("sites").delete().eq("id", siteId);
  if (error) return alert("Could not delete: " + error.message);

  /* If we deleted the site we're currently viewing, go back to overview */
  if (siteId === siteData.id) {
    var url = new URL(window.location);
    url.searchParams.delete("site_id");
    window.location.href = url.toString();
  } else {
    await loadUserSite();
  }
};

function updateGoLiveCard() {
  var card = document.getElementById("goLive");
  var btn = document.getElementById("goLiveBtn");
  var title = document.getElementById("goLiveTitle");
  var desc = document.getElementById("goLiveDesc");
  if (siteData.status === "live") {
    card.classList.add("is-live");
    title.textContent = "🟢 Your site is LIVE";
    desc.textContent = "Anyone with the link can RSVP. Click below to take it offline.";
    btn.textContent = "Take Offline";
  } else {
    card.classList.remove("is-live");
    title.textContent = "🚀 Ready to share with guests?";
    desc.textContent = 'Click "Go Live" to make your site visible. Your guests can then RSVP.';
    btn.textContent = "Go Live";
  }
}

/* Template picker */
function buildTemplateGrid() {
  var html = TEMPLATES.map(function(t) {
    return '<div class="tplcard" onclick="pickTemplate(\'' + t.n.replace(/'/g, "\\'") + '\')">' +
           '  <div class="tplprev" style="background:' + t.bg + ';color:' + t.fg + '">' + t.n + '</div>' +
           '  <div class="tplinfo">' +
           '    <div class="tplname">' + t.n + '</div>' +
           '    <div class="tpldesc">' + t.d + '</div>' +
           '  </div>' +
           '</div>';
  }).join('');
  document.getElementById("tplGrid").innerHTML = html;
}

function populateTemplateSelect() {
  document.getElementById("eTemplate").innerHTML = TEMPLATES.map(function(t) {
    return '<option value="' + t.n + '">' + t.n + '</option>';
  }).join('');
}

window.pickTemplate = async function(name) {
  /* If user already has a site, just update its template instead of creating a duplicate */
  if (siteData && siteData.id) {
    if (!confirm("Switch your existing site to '" + name + "'? Your event details will be preserved.")) return;

    var { error } = await supabase.from("sites")
      .update({ template_name: name })
      .eq("id", siteData.id);

    if (error) return alert("Could not switch template: " + error.message);
    await loadUserSite();
    switchSection("mysite");
    return;
  }

  if (!confirm("Use '" + name + "' as your template? You can edit details next.")) return;

  /* Generate default slug from user name */
  var slug = (currentUser.user_metadata?.full_name || currentUser.email.split("@")[0])
    .toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "");
  if (!slug) slug = "site-" + Date.now().toString(36);

  var { data: newSite, error } = await supabase.from("sites").insert({
    user_id: currentUser.id,
    template_name: name,
    subdomain: slug,
    status: "draft"
  }).select().single();

  if (error) {
    /* If slug taken, retry with random suffix */
    if (error.message && error.message.indexOf("duplicate") >= 0) {
      slug = slug + "-" + Math.floor(Math.random() * 1000);
      var { data: retry, error: rerr } = await supabase.from("sites").insert({
        user_id: currentUser.id,
        template_name: name,
        subdomain: slug,
        status: "draft"
      }).select().single();
      if (rerr) return alert("Could not create site: " + rerr.message);
      newSite = retry;
    } else {
      return alert("Could not create site: " + error.message);
    }
  }

  /* Create matching site_content row */
  await supabase.from("site_content").insert({
    site_id: newSite.id,
    invite_size_default: 2
  });

  await loadUserSite();
};

/* Slug live preview */
function updateSlugPreview() {
  var slug = document.getElementById("eSlug").value || "your-slug";
  document.getElementById("slugPreview").textContent =
    window.location.origin + "/rsvp.html?site=" + slug;
  updateCustomUrl();
}

document.getElementById("eSlug").addEventListener("input", function() {
  this.value = this.value.toLowerCase().replace(/[^a-z0-9-]/g, "-").replace(/-+/g, "-");
  updateSlugPreview();
});

/* Custom URL builder — reads qrSize and current slug */
function updateCustomUrl() {
  var slug = document.getElementById("eSlug").value || "your-slug";
  var size = parseInt(document.getElementById("qrSize").value) || 2;
  var url = window.location.origin + "/rsvp.html?site=" + slug + "&size=" + size;
  document.getElementById("customUrl").textContent = url;
  document.getElementById("qrCaption").textContent = "QR for " + size + " guest" + (size !== 1 ? "s" : "");
}

document.getElementById("qrSize").addEventListener("input", updateCustomUrl);

/* Copy URL */
document.getElementById("copyBtn").addEventListener("click", function() {
  var url = document.getElementById("customUrl").textContent;
  copyToClipboard(url);
});

window.copyToClipboard = function(text) {
  navigator.clipboard.writeText(text).then(function() {
    alert("✓ Copied to clipboard!");
  }).catch(function() {
    /* fallback */
    var ta = document.createElement("textarea");
    ta.value = text; document.body.appendChild(ta);
    ta.select(); document.execCommand("copy"); document.body.removeChild(ta);
    alert("✓ Copied!");
  });
};

/* Generate QR code — uses qrserver.com (free public API), returns PNG */
document.getElementById("qrBtn").addEventListener("click", function() {
  var url = document.getElementById("customUrl").textContent;
  if (!url || url === "—") return alert("Please save your site first.");

  /* qrserver.com supports PNG output natively */
  var qrApiUrl = "https://api.qrserver.com/v1/create-qr-code/?size=480x480&margin=10&format=png&data=" +
                 encodeURIComponent(url);

  document.getElementById("qrImage").src = qrApiUrl;
  document.getElementById("qrDisplay").classList.add("show");
});

/* Download QR as PNG */
document.getElementById("dlBtn").addEventListener("click", async function() {
  var img = document.getElementById("qrImage");
  if (!img.src) return;

  try {
    /* Fetch the image as a blob and trigger download */
    var response = await fetch(img.src);
    var blob = await response.blob();
    var blobUrl = URL.createObjectURL(blob);

    var a = document.createElement("a");
    a.href = blobUrl;
    a.download = "occasi-qr-" + (siteData?.subdomain || "site") + "-size" + document.getElementById("qrSize").value + ".png";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(blobUrl);
  } catch (e) {
    console.error("Download failed:", e);
    /* Fallback: open in new tab so user can right-click save */
    window.open(img.src, "_blank");
  }
});

/* Save edits */
/* ============================================================
   Photo uploads — Supabase Storage, bucket "site-photos"
   Path: {site_id}/photo-{slot}-{timestamp}.{ext}
   ============================================================ */
var MAX_PHOTO_SIZE = 10 * 1024 * 1024;  // 10 MB

function pathFromPublicUrl(url) {
  if (!url || typeof url !== "string") return null;
  var marker = "/site-photos/";
  var idx = url.indexOf(marker);
  return idx >= 0 ? url.substring(idx + marker.length) : null;
}

function setPhotoStatus(slot, text, cls) {
  var el = document.getElementById("eImg" + slot + "Status");
  if (!el) return;
  el.textContent = text || "";
  el.className = "photo-status" + (cls ? " " + cls : "");
}

function renderPhotoSlot(slot, url) {
  var add = document.getElementById("eImg" + slot + "Add");
  var filled = document.getElementById("eImg" + slot + "Filled");
  var preview = document.getElementById("eImg" + slot + "Preview");
  var hidden = document.getElementById("eImg" + slot);

  hidden.value = url || "";
  if (url) {
    preview.src = url;
    add.style.display = "none";
    filled.style.display = "flex";
  } else {
    preview.removeAttribute("src");
    add.style.display = "flex";
    filled.style.display = "none";
  }
}

async function uploadPhoto(slot, file) {
  if (!file) return;
  if (!siteData || !siteData.id) {
    setPhotoStatus(slot, "Save your site first before adding photos.", "error");
    return;
  }
  if (siteData.id === "preview") {
    setPhotoStatus(slot, "Cannot upload in preview.", "error");
    return;
  }
  if (!file.type || file.type.indexOf("image/") !== 0) {
    setPhotoStatus(slot, "Please choose an image file.", "error");
    return;
  }
  if (file.size > MAX_PHOTO_SIZE) {
    setPhotoStatus(slot, "Image too large (max 10 MB). Try a smaller photo.", "error");
    return;
  }

  setPhotoStatus(slot, "Uploading…", "uploading");

  /* Delete the previous file in this slot if there was one */
  var oldUrl = document.getElementById("eImg" + slot).value;
  var oldPath = pathFromPublicUrl(oldUrl);

  /* Build new path */
  var ext = (file.name.split(".").pop() || "jpg").toLowerCase().replace(/[^a-z0-9]/g, "");
  if (!ext || ext.length > 5) ext = "jpg";
  var newPath = siteData.id + "/photo-" + slot + "-" + Date.now() + "." + ext;

  var { error: upErr } = await supabase.storage
    .from("site-photos")
    .upload(newPath, file, { cacheControl: "3600", upsert: false, contentType: file.type });

  if (upErr) {
    console.error("[Occasi] photo upload error:", upErr);
    setPhotoStatus(slot, "Upload failed: " + upErr.message, "error");
    return;
  }

  var { data: urlData } = supabase.storage.from("site-photos").getPublicUrl(newPath);
  var publicUrl = urlData.publicUrl;

  /* Persist to site_content immediately so a save isn't required */
  var contentUpdate = {};
  contentUpdate["image_url_" + slot] = publicUrl;
  var { error: saveErr } = await supabase.from("site_content")
    .upsert(Object.assign({ site_id: siteData.id }, contentUpdate), { onConflict: "site_id" });

  if (saveErr) {
    console.error("[Occasi] photo URL save error:", saveErr);
    setPhotoStatus(slot, "Saved file but couldn't update site: " + saveErr.message, "error");
    return;
  }

  /* Best-effort cleanup of the previous file */
  if (oldPath && oldPath !== newPath) {
    supabase.storage.from("site-photos").remove([oldPath])
      .catch(function(e) { console.warn("[Occasi] old photo cleanup failed:", e); });
  }

  /* Update in-memory state + UI */
  if (!contentData) contentData = {};
  contentData["image_url_" + slot] = publicUrl;
  renderPhotoSlot(slot, publicUrl);
  setPhotoStatus(slot, "✓ Saved", "success");
  setTimeout(function() { setPhotoStatus(slot, "", ""); }, 2500);
}

async function removePhoto(slot) {
  if (!siteData || !siteData.id) return;
  if (!confirm("Remove this photo?")) return;

  setPhotoStatus(slot, "Removing…", "uploading");

  var url = document.getElementById("eImg" + slot).value;
  var path = pathFromPublicUrl(url);

  /* Clear in DB */
  var contentUpdate = {};
  contentUpdate["image_url_" + slot] = null;
  var { error: saveErr } = await supabase.from("site_content")
    .upsert(Object.assign({ site_id: siteData.id }, contentUpdate), { onConflict: "site_id" });

  if (saveErr) {
    console.error("[Occasi] remove photo DB error:", saveErr);
    setPhotoStatus(slot, "Could not remove: " + saveErr.message, "error");
    return;
  }

  /* Delete file from storage (best effort) */
  if (path) {
    await supabase.storage.from("site-photos").remove([path]).catch(function(e) {
      console.warn("[Occasi] storage delete failed:", e);
    });
  }

  if (contentData) contentData["image_url_" + slot] = null;
  renderPhotoSlot(slot, null);
  setPhotoStatus(slot, "", "");
}

/* Wire file inputs and remove buttons */
["1","2","3"].forEach(function(slot) {
  var fileInput = document.getElementById("eImg" + slot + "File");
  if (fileInput) {
    fileInput.addEventListener("change", function(e) {
      var file = e.target.files && e.target.files[0];
      if (file) uploadPhoto(slot, file);
      e.target.value = "";  /* reset so picking the same file again still fires change */
    });
  }
});
document.querySelectorAll(".btn-photo-action.remove").forEach(function(btn) {
  btn.addEventListener("click", function() {
    removePhoto(btn.dataset.slot);
  });
});

/* Delete current site button — wraps the existing window.deleteSite */
document.getElementById("deleteSiteBtn").addEventListener("click", function() {
  if (!siteData) return;
  window.deleteSite(siteData.id, siteData.subdomain || "this site");
});

document.getElementById("saveBtn").addEventListener("click", async function() {
  var btn = this;
  var slug = document.getElementById("eSlug").value.trim();
  var template = document.getElementById("eTemplate").value;
  var p1 = document.getElementById("eP1").value.trim();
  var p2 = document.getElementById("eP2").value.trim();
  var date = document.getElementById("eDate").value || null;
  var deadline = document.getElementById("eDeadline").value || null;
  var venue = document.getElementById("eVenue").value.trim();
  var tagline = document.getElementById("eTagline").value.trim();
  var inviteSize = parseInt(document.getElementById("eInviteSize").value) || 2;

  if (!slug) return showMsg("Please set a URL slug.", true);
  if (!p1) return showMsg("Please enter at least one name (Partner 1).", true);

  btn.disabled = true; btn.textContent = "Saving…";

  /* Update site */
  var { error: e1 } = await supabase.from("sites")
    .update({ subdomain: slug, template_name: template })
    .eq("id", siteData.id);

  /* Upsert content */
  var { error: e2 } = await supabase.from("site_content")
    .upsert({
      site_id: siteData.id,
      partner_1: p1,
      partner_2: p2 || null,
      wedding_date: date,
      rsvp_deadline: deadline,
      venue_name: venue || null,
      tagline: tagline || null,
      invite_size_default: inviteSize,
      image_url_1: document.getElementById("eImg1").value.trim() || null,
      image_url_2: document.getElementById("eImg2").value.trim() || null,
      image_url_3: document.getElementById("eImg3").value.trim() || null
    }, { onConflict: "site_id" });

  btn.disabled = false; btn.textContent = "💾 Save Changes";

  if (e1 || e2) {
    var msg = e1?.message || e2?.message || "Save failed";
    if (msg.indexOf("duplicate") >= 0 || msg.indexOf("unique") >= 0) {
      msg = "That URL slug is already taken — please choose another.";
    }
    return showMsg(msg, true);
  }

  showMsg("✓ Saved!", false);
  await loadUserSite();
});

function showMsg(text, isErr) {
  var el = document.getElementById("editMsg");
  el.textContent = text;
  el.className = "msg " + (isErr ? "err" : "ok");
}

/* Go live toggle */
document.getElementById("goLiveBtn").addEventListener("click", async function() {
  var btn = this;
  var newStatus = siteData.status === "live" ? "draft" : "live";

  if (newStatus === "live") {
    if (!contentData.partner_1) {
      alert("Please save your details first (at least Partner 1 / Name).");
      return;
    }
    if (!siteData.subdomain) {
      alert("Please set a URL slug first.");
      return;
    }
  }

  btn.disabled = true;
  var { error } = await supabase.from("sites").update({ status: newStatus }).eq("id", siteData.id);
  btn.disabled = false;

  if (error) return alert("Could not update: " + error.message);

  await loadUserSite();
  if (newStatus === "live") {
    alert("🎉 Your site is now LIVE!\n\nShare your URL with guests to start collecting RSVPs.");
  }
});

/* Change template */
document.getElementById("changeTplLink").addEventListener("click", function(e) {
  e.preventDefault();
  document.getElementById("editorCard").style.display = "none";
  document.getElementById("pickerCard").style.display = "block";
});

/* Load RSVPs */
async function loadResponses() {
  var sub = document.getElementById("rsvpSubtitle");
  var list = document.getElementById("rsvpList");

  if (!siteData || !siteData.id) {
    sub.textContent = "No site yet. Create one first.";
    list.innerHTML = '';
    return;
  }

  var { data, error } = await supabase
    .from("rsvp_responses")
    .select("*")
    .eq("site_id", siteData.id);

  if (error) {
    sub.textContent = "Error loading RSVPs: " + error.message;
    list.innerHTML = '';
    return;
  }

  /* Sort client-side. Try common timestamp column names; if none exist,
     fall back to id order (newer ids sort higher). */
  var responses = (data || []).slice().sort(function(a, b) {
    var ta = a.created_at || a.submitted_at || a.inserted_at || a.created || "";
    var tb = b.created_at || b.submitted_at || b.inserted_at || b.created || "";
    if (ta && tb) return new Date(tb) - new Date(ta);
    return String(b.id || "").localeCompare(String(a.id || ""));
  });
  sub.textContent =
    responses.length + " response" + (responses.length !== 1 ? "s" : "") +
    " · Updated " + new Date().toLocaleTimeString("en-GB");

  if (responses.length === 0) {
    list.innerHTML = '<div class="rsvp-empty">No RSVPs yet — share your URL with guests and they\'ll appear here.</div>';
    window._responses = [];
    return;
  }

  list.innerHTML = responses.map(function(r, i) {
    var ts = r.created_at || r.submitted_at || r.inserted_at || r.created;
    var dt = ts ? new Date(ts) : null;
    var date = (dt && !isNaN(dt))
      ? dt.toLocaleString("en-GB", { day:"numeric", month:"long", year:"numeric", hour:"2-digit", minute:"2-digit" })
      : "Date unavailable";
    var guestNum = responses.length - i;  // newest first → highest number
    return '<div class="rsvp-card">' +
             '<div class="rsvp-badge">Guest ' + guestNum + '</div>' +
             '<div class="rsvp-name-grid">' +
               '<div>' +
                 '<div class="rsvp-field-label">First Name</div>' +
                 '<div class="rsvp-field-value">' + escapeHtml(r.guest_first || "—") + '</div>' +
               '</div>' +
               '<div>' +
                 '<div class="rsvp-field-label">Last Name</div>' +
                 '<div class="rsvp-field-value">' + escapeHtml(r.guest_last || "—") + '</div>' +
               '</div>' +
             '</div>' +
             '<div class="rsvp-meta">Submitted ' + escapeHtml(date) + '</div>' +
           '</div>';
  }).join('');

  window._responses = responses;
}

/* Export CSV */
document.getElementById("exportBtn").addEventListener("click", function() {
  var responses = window._responses || [];
  if (!responses.length) return alert("No responses to export.");

  var csv = "First Name,Last Name,Group Size,Submitted\n" +
    responses.map(function(r) {
      return [r.guest_first || "", r.guest_last || "",
              r.invite_size || 1,
              new Date(r.created_at).toLocaleString("en-GB")]
        .map(function(c) { return '"' + String(c).replace(/"/g, '""') + '"'; })
        .join(",");
    }).join("\n");

  var blob = new Blob([csv], { type: "text/csv" });
  var a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = "rsvps-" + (siteData.subdomain || "site") + ".csv";
  a.click();
});

/* Navigation */
window.switchSection = function(name) {
  document.querySelectorAll(".section-page").forEach(function(p) { p.classList.remove("active"); });
  document.querySelectorAll(".side-nav a").forEach(function(a) { a.classList.remove("active"); });
  document.getElementById("page-" + name).classList.add("active");
  document.querySelector('[data-section="' + name + '"]')?.classList.add("active");
  /* Auto-refresh RSVPs whenever user navigates to that tab */
  if (name === "responses") {
    loadResponses();
  }
};

document.querySelectorAll(".side-nav a").forEach(function(link) {
  link.addEventListener("click", function() {
    switchSection(this.dataset.section);
  });
});

/* Manual refresh button */
document.getElementById("refreshBtn").addEventListener("click", async function() {
  var btn = this;
  btn.disabled = true;
  btn.textContent = "🔄 Refreshing…";
  await loadResponses();
  btn.disabled = false;
  btn.textContent = "🔄 Refresh";
});

/* Sign out */
document.getElementById("logoutBtn").addEventListener("click", async function(e) {
  e.preventDefault();
  await supabase.auth.signOut();
  window.location.href = "index.html";
});

/* Util */
function escapeHtml(s) {
  return String(s || "").replace(/[&<>"']/g, function(c) {
    return { "&":"&amp;", "<":"&lt;", ">":"&gt;", '"':"&quot;", "'":"&#39;" }[c];
  });
}
</script>
</body>
</html>
