<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5"/>
<title>Occasi — Beautiful Event Sites</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Inter:wght@400;500;600;700&family=Cinzel:wght@400;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/theme.css">
<style>
.hero{text-align:center;padding:80px 22px 40px}
.hero-logo{
  display:block;
  width:100px;
  height:100px;
  margin:0 auto 18px;
  filter:drop-shadow(0 6px 20px rgba(122,62,200,.25));
}
.hero-badge{display:inline-block;font-size:11px;font-weight:700;letter-spacing:.15em;text-transform:uppercase;color:var(--c2);margin-bottom:18px;padding:6px 14px;background:rgba(122,62,200,.08);border:1px solid var(--line-purple);border-radius:20px}
.hero h1{font-family:'Playfair Display',serif;font-size:clamp(32px,6vw,52px);font-weight:700;line-height:1.05;margin-bottom:14px;color:var(--ink)}
.hero h1 em{font-style:italic;background:linear-gradient(135deg,var(--c1),var(--c2),var(--c3));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.hero p{font-size:15px;color:var(--ink2);max-width:480px;margin:0 auto 24px;line-height:1.6}
.hero-actions{display:flex;gap:10px;justify-content:center;flex-wrap:wrap}

.preview-row{padding:0 22px 50px;text-align:center}
.preview-row h2{font-family:'Playfair Display',serif;font-size:24px;font-weight:700;margin-bottom:14px}
.preview-pills{display:flex;gap:8px;justify-content:center;flex-wrap:wrap}
.pill{padding:9px 16px;background:#fff;border:1px solid var(--line);border-radius:18px;font-size:12px;color:var(--ink);cursor:pointer;text-decoration:none;font-weight:500;transition:all .2s}
.pill:hover{border-color:var(--c2);color:var(--c2);transform:translateY(-2px);text-decoration:none}

.steps{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;max-width:900px;margin:0 auto;padding:0 22px 50px}
.step{background:#fff;border:1px solid var(--line);border-radius:14px;padding:22px;text-align:center}
.step-icon{font-size:34px;margin-bottom:10px}
.step h3{font-size:15px;font-weight:700;color:var(--ink);margin-bottom:5px}
.step p{font-size:12px;color:var(--ink2);line-height:1.5}

.pricing{padding:50px 22px;background:linear-gradient(180deg,transparent,rgba(122,62,200,.04));border-radius:24px;margin:0 18px 40px}
.pricing-title{text-align:center;margin-bottom:30px}
.pricing-title h2{font-family:'Playfair Display',serif;font-size:32px;font-weight:700;color:var(--ink);margin-bottom:6px}
.pricing-title p{font-size:13px;color:var(--muted)}
.plans{display:grid;grid-template-columns:1fr 1fr;gap:14px;max-width:680px;margin:0 auto}
.plan{background:#fff;border:2px solid var(--line);border-radius:18px;padding:24px;display:flex;flex-direction:column}
.plan.featured{border-color:transparent;background:linear-gradient(#fff,#fff) padding-box,linear-gradient(135deg,var(--c1),var(--c2),var(--c3)) border-box;box-shadow:var(--shadow-glow);position:relative}
.plan.featured::before{content:'POPULAR';position:absolute;top:-1px;right:14px;background:linear-gradient(135deg,var(--c1),var(--c2),var(--c3));color:#fff;font-size:9px;font-weight:700;letter-spacing:.15em;padding:5px 10px;border-radius:0 0 8px 8px}
.plan-icon{font-size:24px;margin-bottom:6px}
.plan-name{font-size:11px;font-weight:700;letter-spacing:.15em;text-transform:uppercase;color:var(--muted)}
.plan-price{font-family:'Playfair Display',serif;font-size:38px;font-weight:700;color:var(--ink);line-height:1;margin:6px 0 4px}
.plan-price small{font-size:13px;color:var(--muted);font-weight:400;font-family:'Inter',sans-serif}
.plan-feats{list-style:none;padding:14px 0;flex:1;margin:0}
.plan-feats li{font-size:12px;color:var(--ink2);padding:5px 0;display:flex;gap:7px}
.plan-feats li::before{content:'✓';color:var(--c2);font-weight:700;flex-shrink:0}
.plan-btn{padding:11px;border-radius:11px;background:linear-gradient(135deg,var(--c1),var(--c2),var(--c3));color:#fff;border:none;font-size:12px;font-weight:700;letter-spacing:.1em;text-transform:uppercase;cursor:pointer;font-family:'Inter',sans-serif}

footer{text-align:center;font-size:12px;color:var(--muted);padding:30px 20px}

@media(max-width:600px){.steps{grid-template-columns:1fr}.plans{grid-template-columns:1fr}}
</style>
</head>
<body>

<div id="loader">
  <img src="assets/logo.png" class="loader-img" alt="Occasi">
  <div class="loader-logo">OCCASI</div>
  <div class="loader-tagline">Beautiful event sites</div>
  <div class="loader-bar"></div>
</div>

<nav class="top-nav">
  <a href="index.html" class="brand-logo"><img src="assets/logo.png" class="logo-img" alt="Occasi"><span class="logo-text">OCCASI</span></a>
  <div class="top-nav-right">
    <a href="login.html" class="btn btn-ghost btn-sm" id="navSignIn">Sign in</a>
    <a href="signup.html" class="btn btn-grad btn-sm" id="navGetStarted">Get Started →</a>
    <a href="dashboard.html" class="btn btn-grad btn-sm" id="navDashboard" style="display:none">My Dashboard →</a>
  </div>
</nav>

<section class="hero">
  <img src="assets/logo.png" alt="Occasi" class="hero-logo">
  <div class="hero-badge">✨ Beautiful event sites</div>
  <h1>Create your<br><em>dream invitation</em></h1>
  <p>Beautiful RSVP forms and wedding websites. Live in minutes, customised in seconds — no design skills needed.</p>
  <div class="hero-actions">
    <a href="signup.html" class="btn btn-grad btn-lg">Get Started →</a>
    <a href="templates.html" class="btn btn-ghost btn-lg">View Templates</a>
  </div>
</section>

<section class="preview-row">
  <h2>Try a live demo</h2>
  <div class="preview-pills">
    <a href="rsvp.html?site=preview&template=Garden+Romance" class="pill" target="_blank">🌿 Garden Romance</a>
    <a href="rsvp.html?site=preview&template=Midnight+Glamour" class="pill" target="_blank">✨ Midnight Glamour</a>
    <a href="rsvp.html?site=preview&template=Rustic+Barn" class="pill" target="_blank">🌾 Rustic Barn</a>
    <a href="rsvp.html?site=preview&template=Modern+Minimal" class="pill" target="_blank">⬛ Modern Minimal</a>
    <a href="rsvp.html?site=preview&template=Rose+Gold" class="pill" target="_blank">🌹 Rose Gold</a>
  </div>
</section>

<section class="steps">
  <div class="step"><div class="step-icon">🎨</div><h3>Pick a design</h3><p>Choose from 5 beautifully crafted templates.</p></div>
  <div class="step"><div class="step-icon">✏️</div><h3>Customise it</h3><p>Add names, dates, venue — make it yours.</p></div>
  <div class="step"><div class="step-icon">🚀</div><h3>Share & track</h3><p>Send to guests. Watch RSVPs roll in live.</p></div>
</section>

<section class="pricing" id="pricing">
  <div class="pricing-title">
    <h2>Simple, honest pricing</h2>
    <p>No setup fees. Cancel anytime.</p>
  </div>
  <div class="plans">
    <div class="plan">
      <div class="plan-icon">📋</div>
      <div class="plan-name">RSVP Only</div>
      <div class="plan-price">£9<small>/mo</small></div>
      <ul class="plan-feats">
        <li>Beautiful RSVP page</li>
        <li>All design templates</li>
        <li>Live response tracking</li>
        <li>Custom invite sizes</li>
        <li>QR codes for families</li>
        <li>CSV download</li>
      </ul>
      <button class="plan-btn" onclick="location.href='signup.html?plan=rsvp'">Get Started</button>
    </div>
    <div class="plan featured">
      <div class="plan-icon">🌐</div>
      <div class="plan-name">Website + RSVP</div>
      <div class="plan-price">£19<small>/mo</small></div>
      <ul class="plan-feats">
        <li>Everything in RSVP plan</li>
        <li>Full event website</li>
        <li>Photo gallery</li>
        <li>Story & schedule pages</li>
        <li>Custom subdomain</li>
        <li>Priority support</li>
      </ul>
      <button class="plan-btn" onclick="location.href='signup.html?plan=website'">Get Started</button>
    </div>
  </div>
</section>

<footer>© 2026 Occasi · Beautiful event sites for every occasion</footer>

<script src="js/occasi-auth.js"></script>
<script>
window.addEventListener("load", function() {
  setTimeout(function() {
    var l = document.getElementById("loader");
    l.classList.add("hidden");
    setTimeout(function() { l.style.display = "none"; }, 700);
  }, 1300);
});

function onSupabaseReady() {
  if (!supabase) return;
  supabase.auth.getUser().then(function(res) {
    if (res?.data?.user) {
      document.getElementById("navSignIn").style.display = "none";
      document.getElementById("navGetStarted").style.display = "none";
      document.getElementById("navDashboard").style.display = "inline-flex";
    }
  });
}
</script>
</body>
</html>
