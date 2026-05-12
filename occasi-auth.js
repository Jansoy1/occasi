:root{
  --bg:#fdf9f0;
  --card:#ffffff;
  --c1:#3d4ec8;    /* royal blue */
  --c2:#7a3ec8;    /* purple-blue */
  --c3:#a040d8;    /* vibrant purple */
  --c4:#5a3aa0;    /* deep purple */
  --ink:#2d1b5a;   /* deep blue-ink */
  --ink2:#5a4878;
  --muted:#8a7aa0;
  --line:#e8e0f0;
  --line-purple:#d4c4e8;
  --shadow:0 10px 30px rgba(122,62,200,.12);
  --shadow-glow:0 8px 24px rgba(122,62,200,.15);
}

*{box-sizing:border-box;margin:0;padding:0;-webkit-tap-highlight-color:transparent}
body{
  font-family:'Inter',-apple-system,BlinkMacSystemFont,sans-serif;
  background:var(--bg);
  color:var(--ink);
  line-height:1.5;
  min-height:100vh;
}
a{color:var(--c2);text-decoration:none}
a:hover{text-decoration:underline}

/* Top nav */
.top-nav{
  position:sticky;top:0;z-index:50;
  display:flex;align-items:center;justify-content:space-between;
  padding:14px 22px;
  background:rgba(253,249,240,.92);
  backdrop-filter:blur(16px);
  border-bottom:1px solid var(--line);
}
.brand-logo{
  display:inline-flex;align-items:center;gap:10px;
  font-family:'Playfair Display',serif;
  text-decoration:none;
}
.brand-logo:hover{text-decoration:none}
.logo-img{
  height:38px;width:auto;
  display:block;
  filter:drop-shadow(0 2px 8px rgba(122,62,200,.15));
}
.logo-text{
  font-family:'Cinzel',serif;
  font-weight:700;
  font-size:18px;
  letter-spacing:.18em;
  color:var(--c4);
  background:linear-gradient(135deg,var(--c1),var(--c2),var(--c3));
  -webkit-background-clip:text;
  -webkit-text-fill-color:transparent;
  background-clip:text;
}
.top-nav-right{display:flex;gap:8px;align-items:center}

/* Buttons */
.btn{
  display:inline-flex;align-items:center;justify-content:center;
  padding:10px 22px;
  border-radius:11px;border:none;cursor:pointer;
  font-family:'Inter',sans-serif;
  font-size:13px;font-weight:600;
  letter-spacing:.04em;
  text-decoration:none;
  transition:transform .15s, box-shadow .15s, background .2s;
}
.btn:hover{text-decoration:none;transform:translateY(-1px)}
.btn-sm{padding:8px 14px;font-size:12px}
.btn-lg{padding:13px 30px;font-size:14px}
.btn-grad{
  background:linear-gradient(135deg,var(--c1),var(--c2),var(--c3));
  color:#fff;
  box-shadow:0 4px 14px rgba(122,62,200,.3);
}
.btn-grad:hover{box-shadow:0 8px 22px rgba(122,62,200,.4)}
.btn-ghost{
  background:transparent;
  color:var(--c2);
  border:1.5px solid var(--line-purple);
}
.btn-ghost:hover{background:rgba(122,62,200,.06)}

/* Form */
.field{margin-bottom:14px}
.field label{
  display:block;
  font-size:11px;font-weight:700;letter-spacing:.1em;
  text-transform:uppercase;color:var(--muted);
  margin-bottom:6px;
}
.field input, .field select, .field textarea{
  width:100%;
  padding:11px 14px;
  border:1.5px solid var(--line);
  border-radius:10px;
  background:#fff;
  font-family:'Inter',sans-serif;
  font-size:14px;
  color:var(--ink);
  outline:none;
  transition:border-color .15s;
}
.field input:focus, .field select:focus, .field textarea:focus{
  border-color:var(--c2);
}
.field-row{display:flex;gap:10px;flex-wrap:wrap}
.field-row .field{flex:1;min-width:140px}

/* Messages */
.msg{font-size:12px;line-height:1.5;padding:8px 0;min-height:18px}
.msg.err{color:#cc2020}
.msg.ok{color:#16a34a}

/* Loader */
#loader{
  position:fixed;inset:0;z-index:9999;
  background:var(--bg);
  display:flex;flex-direction:column;align-items:center;justify-content:center;gap:18px;
  transition:opacity .6s ease;
}
#loader.hidden{opacity:0;pointer-events:none}
.loader-img{
  width:88px;height:88px;
  animation:loaderPulse 1.8s ease-in-out infinite;
  filter:drop-shadow(0 4px 18px rgba(122,62,200,.3));
}
@keyframes loaderPulse{
  0%,100%{transform:scale(1);opacity:1}
  50%{transform:scale(.95);opacity:.85}
}
.loader-logo{
  font-family:'Cinzel',serif;
  font-size:clamp(28px,6vw,42px);
  letter-spacing:.18em;
  font-weight:700;
  color:var(--c4);
  background:linear-gradient(135deg,var(--c1),var(--c2),var(--c3));
  -webkit-background-clip:text;
  -webkit-text-fill-color:transparent;
  background-clip:text;
  animation:fadeUp .8s ease both;
}
.loader-tagline{
  font-size:12px;color:var(--muted);
  letter-spacing:.15em;text-transform:uppercase;
  animation:fadeUp .8s ease both;animation-delay:.2s;opacity:0;
  animation-fill-mode:forwards;
}
.loader-bar{
  width:120px;height:2px;background:var(--line);border-radius:2px;overflow:hidden;
  position:relative;margin-top:6px;
}
.loader-bar::after{
  content:'';position:absolute;top:0;left:-40%;width:40%;height:100%;
  background:linear-gradient(90deg,var(--c1),var(--c2),var(--c3));
  animation:loaderSlide 1.2s ease-in-out infinite;
}
@keyframes loaderSlide{to{left:100%}}
@keyframes fadeUp{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}

/* Container */
.container{max-width:1080px;margin:0 auto;padding:24px 18px}
