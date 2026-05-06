/* ============================================================
   occasi-auth.js — Supabase + Stripe helpers
   
   📌 SETUP CHECKLIST
   
   ─── SUPABASE ───
   1. supabase.com → Create project
   2. Settings → API → copy URL + anon key → paste below
   3. SQL Editor → run supabase-setup.sql
   4. Auth → Providers → enable Google + Apple
   
   ─── STRIPE ───
   1. stripe.com → Developers → API keys → copy Publishable key (pk_live_... or pk_test_...) → paste below
   2. Products → create 3 products with monthly prices:
        ▸ RSVP Only:    £9/mo recurring
        ▸ Website Only: £25/mo recurring
        ▸ Full Bundle:  £39/mo recurring + 3 day free trial
   3. Copy each Price ID (price_...) into STRIPE_PRICES below
   4. Set up Stripe Customer Portal in Dashboard → Settings → Billing → Customer Portal
============================================================ */

const SUPABASE_URL  = "https://gtjsddxkkokebbwofukf.supabase.co";
const SUPABASE_ANON = "sb_publishable_l2HYQzQjKQSAimBikNrelw_atXnlk0E";

const STRIPE_PUBLIC_KEY = "pk_test_51TTfBZFjRcdqjQVRxFHIA0uBspNhc2GJChJM2A58Z4vhFrLKPD67dKrHJfsGzclwMZEbkhmR28NIFanVXvi6bL2I009Y2maFuW";

const STRIPE_PRICES = {
  rsvp:    "price_1TU0gyFjRcdqjQVRhxu98Rsk",
  website: "price_1TU0hRFjRcdqjQVRDzfUN13s",
  bundle:  "price_1TU0hnFjRcdqjQVRHOesjUdq"
};

const ADMIN_EMAIL = "jansoy55@hotmail.com";
const TRIAL_DAYS  = 3;

const PLAN_DETAILS = {
  rsvp:    { name: "RSVP Only",    monthly: 9,  setup: 25, trial: false, icon: "📋" },
  website: { name: "Website Only", monthly: 25, setup: 35, trial: false, icon: "🌐" },
  bundle:  { name: "Full Bundle",  monthly: 39, setup: 45, trial: true,  icon: "✨" }
};

/* Load Supabase + Stripe */
/* Use var (not let) to avoid temporal dead zone collision with the jsdelivr wrapper script
   which also declares `supabase` at the top of the bundled library. */
var supabase, stripe;
/* Multi-CDN fallback list — try each until one loads.
   Each must serve UMD bundle that exposes window.supabase global.
   Different browsers block different CDNs. */
var SUPABASE_CDNS = [
  "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.45.4/dist/umd/supabase.min.js",
  "https://unpkg.com/@supabase/supabase-js@2.45.4/dist/umd/supabase.min.js",
  "https://cdn.statically.io/gh/supabase/supabase-js/v2.45.4/dist/umd/supabase.min.js"
];
var STRIPE_CDN = "https://js.stripe.com/v3/";

var _supabaseDone = false;
var _stripeDone = false;
var _setupCalled = false;

function tryFinalize() {
  if (_setupCalled) return;
  if (!_supabaseDone || !_stripeDone) return;
  _setupCalled = true;

  try {
    if (window.supabase && window.supabase.createClient) {
      supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON);
    } else {
      console.warn("Supabase library did not load — signup will not work. Browser may be blocking the CDN. Try a different browser (Chrome, Safari, Firefox).");
    }
  } catch (e) { console.warn("Supabase init failed:", e); }

  try {
    if (window.Stripe && STRIPE_PUBLIC_KEY && STRIPE_PUBLIC_KEY.indexOf("YOUR_") !== 0) {
      stripe = window.Stripe(STRIPE_PUBLIC_KEY);
    }
  } catch (e) { console.warn("Stripe init failed:", e); }

  if (typeof onSupabaseReady === "function") onSupabaseReady();
}

function loadSupabaseFromCDN(idx) {
  if (idx >= SUPABASE_CDNS.length) {
    console.warn("All Supabase CDNs blocked. Auth features will not work.");
    _supabaseDone = true;
    tryFinalize();
    return;
  }
  var src = SUPABASE_CDNS[idx];
  var s = document.createElement("script");
  s.src = src;
  s.onload = function() {
    if (window.supabase && window.supabase.createClient) {
      _supabaseDone = true;
      tryFinalize();
    } else {
      console.warn("CDN loaded but no global supabase:", src);
      loadSupabaseFromCDN(idx + 1);
    }
  };
  s.onerror = function() {
    console.warn("CDN blocked or failed:", src);
    loadSupabaseFromCDN(idx + 1);
  };
  document.head.appendChild(s);
}

function loadStripe() {
  var s = document.createElement("script");
  s.src = STRIPE_CDN;
  s.onload = function() { _stripeDone = true; tryFinalize(); };
  s.onerror = function() {
    console.warn("Stripe CDN blocked");
    _stripeDone = true;
    tryFinalize();
  };
  document.head.appendChild(s);
}

/* Kick off both loads */
loadSupabaseFromCDN(0);
loadStripe();

async function getUser() {
  if (!supabase) return null;
  const { data: { user } } = await supabase.auth.getUser();
  return user;
}

async function getUserProfile(userId) {
  const { data } = await supabase.from("users").select("*").eq("id", userId).single();
  return data;
}

async function isAdmin(user) {
  return user && user.email === ADMIN_EMAIL;
}

async function requireAuth(redirectTo = "/login.html") {
  const user = await getUser();
  if (!user) { window.location.href = redirectTo; return null; }
  return user;
}

async function requireAdmin() {
  const user = await requireAuth();
  if (!user) return null;
  if (!(await isAdmin(user))) { window.location.href = "/dashboard.html"; return null; }
  return user;
}

async function signOut() {
  await supabase.auth.signOut();
  window.location.href = "/index.html";
}

function isTrialActive(profile) {
  if (!profile || !profile.trial_ends_at) return false;
  return new Date(profile.trial_ends_at) > new Date();
}

function trialDaysLeft(profile) {
  if (!profile || !profile.trial_ends_at) return 0;
  const diff = new Date(profile.trial_ends_at) - new Date();
  return Math.max(0, Math.ceil(diff / 86400000));
}

/* ── Stripe Checkout ── 
   Redirects user to Stripe-hosted checkout page.
   Backend webhook (you'll set this up later) updates Supabase
   when payment succeeds via stripe-webhook function.
*/
async function startCheckout(plan, userId, userEmail) {
  if (!stripe) { alert("Payment system loading. Please try again in a moment."); return; }
  const priceId = STRIPE_PRICES[plan];
  if (!priceId || priceId.startsWith("price_REPLACE")) {
    alert("Stripe products not yet configured. Add your Price IDs to occasi-auth.js");
    return;
  }
  /* In production this hits a serverless function — for now use direct Stripe checkout
     via a Cloudflare Worker or Supabase Edge Function */
  const response = await fetch("/api/create-checkout", {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({
      priceId, userId, userEmail, plan,
      trialDays: PLAN_DETAILS[plan].trial ? TRIAL_DAYS : 0,
      successUrl: window.location.origin + "/dashboard.html?success=1",
      cancelUrl:  window.location.origin + "/signup.html?cancelled=1"
    })
  });
  const { sessionId, error } = await response.json();
  if (error) { alert("Payment error: " + error); return; }
  await stripe.redirectToCheckout({ sessionId });
}
