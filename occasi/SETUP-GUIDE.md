# 🌟 Occasi — Complete Operations Guide

Your platform: cream silk theme, blue→purple logo, focused on RSVPs + event websites.

---

# 🎯 PART 1 — How the business works

## The flow

```
┌─────────────────────────────────────────────────────────┐
│ 1. Customer visits occasi.netlify.app                  │
│    Sees beautiful designs, clicks "Try Demo" to preview │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ 2. Customer signs up — picks plan (£9 RSVP / £19 Web)  │
│    Pays via Stripe → account created in Supabase        │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ 3. Customer lands on dashboard                          │
│    "Welcome! Choose your template"                      │
│    Picks from 5 wedding or 5 engagement designs        │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ 4. Customer fills in their details                      │
│    Names, date, venue, message, URL slug, invite size  │
│    Saves changes                                         │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ 5. Customer clicks "Go Live"                            │
│    Site instantly available at:                         │
│    occasi.com/rsvp.html?site=their-slug                 │
│    You (admin) get email notification                   │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ 6. Customer shares URL with guests                      │
│    Different families can get different invite sizes:   │
│    ?size=2 for couples                                  │
│    ?size=4 for family of 4                              │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ 7. Guests submit RSVPs                                  │
│    Real-time on customer's dashboard                    │
│    Customer downloads CSV when needed                   │
└─────────────────────────────────────────────────────────┘
```

**Your role as admin: minimal.** Customers self-serve everything. You just monitor and intervene if needed.

---

# 💰 PART 2 — Pricing

| Plan | Price | What they get |
|---|---|---|
| **RSVP Only** | £9/month | Beautiful RSVP page, all 10 designs, dashboard, response tracking, CSV export, customisable invite sizes |
| **Website + RSVP** | £19/month | Everything above + full event website, photo gallery, story page, schedule, custom subdomain |

**Free trial:** None right now. Card required at signup. Cancel anytime — no questions asked.

**Why these prices:**
- Covers Stripe fees + Supabase costs even at small scale
- Comparable to competitors (Joy, Greenvelope, Zola)
- Sustainable long-term — won't burn out

---

# 📐 PART 3 — Adding new templates

## A. Each template needs THREE updates:

### Step 1 — Add to `rsvp.html` (the live page)

Open `rsvp.html` and find the CSS section marked "10 TRULY DIFFERENT DESIGNS".

Add a new design block. Each one has:
- A unique **layout** (centered, asymmetric, side-by-side, vertical, etc.)
- Its own **font pairings**
- **Decorative elements** (floral, geometric, hand-drawn, photo, etc.)
- **Body background** + **card background** + **colours**

```css
/* ───── 11. YOUR NEW DESIGN — Description ───── */
body.t-newname{background:linear-gradient(...)}
.t-newname .design-11{...}  /* card layout */
.t-newname .eyebrow{...}    /* small label above names */
.t-newname .names{...}      /* the big name display */
.t-newname .amp{...}         /* the & between names */
.t-newname .tagline{...}    /* invitation message */
.t-newname .date-block{...}
.t-newname .date-eyebrow{...}
.t-newname .date{...}
.t-newname .venue{...}
.t-newname .deadline{...}
.t-newname .rsvp-form{...}
.t-newname .rsvp-submit{...}
```

Then add to the `TEMPLATES` JS object:
```js
"Your New Design": {cls:"t-newname", deco:11, deadline:"Please RSVP by"}
```

And add a case to the `renderLayout` function:
```js
case 11: return '<div class="design-11">YOUR LAYOUT HTML</div>';
```

### Step 2 — Add to `templates.html` (the catalog)

Find the `DESIGNS` object and add to the relevant category:

```js
weddings: [  // or engagements, birthdays, etc.
  // existing designs...
  {
    n: "Your New Design",
    d: "Description shown on the catalog card.",
    bg: "background-css-for-card-preview",
    fg: "text-color",
    previewBg: "actual-card-background",
    previewFg: "actual-text-color"
  }
]
```

### Step 3 — Add to `dashboard.html` (customer template picker)

Find the `DESIGNS` object — same structure as templates.html — and add it there too.

### Step 4 — Push to GitHub

```bash
git add .
git commit -m "Add 'Your New Design' template"
git push
```

Netlify auto-deploys in 30 seconds. Customers can immediately pick it.

---

## B. Adding a whole new CATEGORY (e.g. Birthdays)

1. **Build 5+ designs** following the guidance above (fewer than 5 looks empty)
2. Update `templates.html`:
   ```js
   var DESIGNS = {
     weddings: [...],
     engagements: [...],
     birthdays: [/* your 5 new designs */]
   };
   ```
3. Enable the category tab in templates.html — change the `disabled` class:
   ```html
   <button class="ctab" data-cat="birthdays">🎂 Birthdays</button>  <!-- removed `disabled` -->
   ```
4. Update `index.html` cat list — change `cat soon` to `cat live`:
   ```html
   <a class="cat live" href="templates.html?cat=birthdays">...
   ```
5. Update `dashboard.html` to show this category in the picker tabs.

---

# 🎨 PART 4 — Design philosophy (important!)

The 10 designs are deliberately **very different from each other**. Each new design should be too. **Don't just change colours.**

For each new design, decide:
- **Layout direction:** Centered, asymmetric, vertical timeline, photo-strip, full-bleed, framed?
- **Typography:** Serif/script/sans? Same family or contrasting? Italic display name or upright?
- **Decorative element:** Floral, geometric, photographic, illustrated, watercolor blob, sparkle?
- **Card shape:** Square, arched dome, rounded, bordered, asymmetric?
- **Color story:** Light/dark/medium? Single hue or complementary? Saturated or muted?

If your new design just changes colours from an existing one, **redo it.**

---

# 👥 PART 5 — Admin tasks

You'll need to:

1. **Monitor sign-ups** — Supabase dashboard → Table Editor → users
2. **Watch new sites going live** — set up email alerts via Supabase → Database → Webhooks (later)
3. **Handle support** — customers email `jansoy55@hotmail.com` for issues
4. **Take down inappropriate sites** — admin panel → set status to "offline"
5. **Respond to billing issues** — Stripe dashboard

---

# 🔧 PART 6 — Initial Supabase setup (do once)

If you haven't yet:

1. Run **`supabase-setup.sql`** in Supabase SQL Editor (creates all tables + policies)
2. Authentication → Providers → enable Email + Google
3. Authentication → URL Configuration → Site URL = your Netlify URL
4. Authentication → Settings → for testing, **disable email confirmation** (re-enable for production)

---

# 🚀 PART 7 — Stripe checkout (still TODO)

Currently signup creates the account but doesn't redirect to Stripe.

**To activate payments:**
1. Build a Cloudflare Worker (or Netlify Function) that creates Stripe Checkout Sessions using your secret key
2. The frontend code in `occasi-auth.js` already calls `/api/create-checkout` — that endpoint needs to exist
3. Set up a Stripe webhook to update `users.plan_status` when payments succeed

I (Claude) can help build this step-by-step when you're ready.

---

# 💡 PART 8 — Growth ideas (when ready)

**Increase revenue per customer:**
1. **Save the Date emails** — £5 add-on, you send branded emails to their guest list
2. **QR code packs** — printed QR cards via Moo/Vistaprint API
3. **Anniversary/Memory pages** — auto-generated post-event sites
4. **Gift registry integration** — affiliate commission from Amazon/John Lewis
5. **Custom domain** — £20 setup + £5/month for `their-name.com`

**Increase customers:**
1. **Referral program** — £10 credit per friend who signs up
2. **Vendor partnerships** — photographers/florists feature you in their packages
3. **Influencer collabs** — wedding bloggers get free accounts in exchange for posts
4. **SEO blog** — "How to write wedding vows", "Wedding planning timeline" → drives organic traffic

**Reduce churn:**
1. **Year-round access** — same dashboard reused for anniversary cards, Christmas cards
2. **Priority support tier** — £5/month upgrade for faster help
3. **Annual billing discount** — pay 10 months, get 12

---

# 📂 Files in this build

| File | Purpose |
|---|---|
| `index.html` | Homepage with new pricing |
| `rsvp.html` | **Live RSVP engine** — 10 truly different designs |
| `templates.html` | Browse the 10 designs by category |
| `signup.html` | Account creation (2 plans) |
| `login.html` | Sign in |
| `dashboard.html` | Customer self-service area |
| `admin.html` | Your admin panel |
| `reset-password.html` | Password reset |
| `preview.html` | Static design preview (legacy, less useful now) |
| `css/theme.css` | Cream silk theme |
| `js/occasi-auth.js` | Supabase + Stripe wiring |
| `assets/logo.png` | Your real PNG logo |
| `supabase-setup.sql` | Database schema |

---

# 🙏 Tips for success

- **Quality over quantity.** 10 great designs > 60 mediocre ones.
- **Listen to early customers.** Their feedback shapes v2.
- **Don't undercharge.** £5/month is a path to burnout.
- **Make sharing magical.** QR codes, beautiful URLs, easy CSV exports → customers tell their friends.
- **Build a brand around weddings first.** Once you own one niche, expand.
