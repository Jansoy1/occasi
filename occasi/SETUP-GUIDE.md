# 🚀 Occasi — Complete Setup & How-To Guide

Your full event-site platform: deep wine theme, 60 designs, automated site generation.

---

# PART 1 — Initial Setup (Once)

## 1️⃣ Supabase

1. **supabase.com** → New project (name: `occasi`, region: Europe West)
2. **SQL Editor** → paste `supabase-setup.sql` → Run
3. **Authentication → Settings**:
   - ✅ Enable Email confirmations
   - Site URL: your Cloudflare URL
   - Add redirect URLs for `/dashboard.html` and `/admin.html`
4. **Authentication → Providers**: enable Google (Apple optional)
5. **Settings → API**: copy URL + anon key into `js/occasi-auth.js`

## 2️⃣ Stripe

1. **Developers → API keys** → copy **Publishable key** → paste into `js/occasi-auth.js`
2. **Products → Create 3**:
   - RSVP Only — £9/month
   - Website Only — £25/month
   - Full Bundle — £39/month + 3-day trial
3. Copy each Price ID into `STRIPE_PRICES` in `occasi-auth.js`
4. **Settings → Billing → Customer Portal** → activate
5. Build the Stripe checkout Cloudflare Worker (code below in Part 4)

## 3️⃣ GitHub + Cloudflare Pages

1. Create GitHub repo → push your code
2. Cloudflare Pages → Connect to Git → select repo
3. Build settings:
   - Framework: **None**
   - Build command: *(leave empty)*
   - Output dir: `/`
   - Root: `/`
4. Deploy → live in 30 seconds

---

# PART 2 — How the System Works End-to-End

```
┌──────────────────────────────────────────────────────┐
│  1. Customer signs up + pays via Stripe              │
│     → user row created in Supabase                   │
│     → trial starts if Bundle plan                    │
└──────────────────────────────────────────────────────┘
                        ↓
┌──────────────────────────────────────────────────────┐
│  2. You (admin) generate their site                  │
│     → Admin Panel → Customer Sites                   │
│     → Click "+ Generate Site"                        │
│     → Pick customer, set slug, fill details          │
│     → Site goes live at /rsvp.html?site=their-slug   │
└──────────────────────────────────────────────────────┘
                        ↓
┌──────────────────────────────────────────────────────┐
│  3. Customer logs in to their dashboard              │
│     → Sees their live site URL                       │
│     → Can edit content (names, date, message)        │
│     → Can copy URL or download QR codes              │
└──────────────────────────────────────────────────────┘
                        ↓
┌──────────────────────────────────────────────────────┐
│  4. Guests visit URL → submit RSVP                   │
│     → saved to Supabase (rsvp_responses table)       │
│     → instantly shows in customer's dashboard        │
└──────────────────────────────────────────────────────┘
```

---

# PART 3 — How To Use The System

## 🎯 Generating a Site for a New Customer

1. Sign in to admin (`jansoy55@hotmail.com`)
2. Click **Customer Sites** in sidebar
3. Click **"+ Generate Site"**
4. Fill in the form:
   - **Customer**: pick from dropdown
   - **URL Slug**: e.g. `firstsecond-2026` (this becomes their URL)
   - **Site Type**: RSVP / Website / Bundle
   - **Template**: pick from 60 designs
   - **Names**: Partner 1 (and Partner 2 if applicable)
   - **Event Date** + **RSVP Deadline**
   - **Venue**
   - **Tagline / Message**
   - **Status**: Live (visible) or Building (hidden)
5. Click **Generate Site**

The customer's site is now live at:
```
https://your-domain.com/rsvp.html?site=firstsecond-2026
```

## 📤 Sharing The URL With Guests

Three ways customers can share their RSVP:

1. **Direct URL** — copy from dashboard
2. **With invite size** — add `&size=4` for a family of 4: 
   `…/rsvp.html?site=firstsecond-2026&size=4`
3. **QR code** — generate from any free QR tool using the URL

## 🧪 Test Mode (No Database Needed)

To preview any template **as if it were live** (without a real customer):
```
/rsvp.html?site=preview&template=Garden Romance
```

This loads the template with placeholder data. RSVP submissions in preview mode **don't get saved** — perfect for showing customers what they'll get.

You can submit a fake RSVP in test mode to see how the success screen looks.

---

# PART 4 — Adding a New Template Design

You have **60 designs already built**. Here's how to add a 61st (or modify any of them).

## A. Add New Design to Template Browser

Edit `templates.html`. Find the `DESIGNS` object and add to the relevant category:

```js
weddings: [
  // existing...
  {
    n: "Your New Design",
    d: "Short description shown on cards.",
    bg: "linear-gradient(135deg,#yourcolour1,#yourcolour2)",
    fg: "#yourtextcolour"
  }
]
```

## B. Add a Real Working Theme (RSVP Page)

Edit `rsvp.html`. Find the `/* WEDDINGS */` section in the CSS and add:

```css
.t-yournewdesign {
  background: linear-gradient(135deg, #colour1, #colour2);
}
.t-yournewdesign .rsvp-card {
  background: #cardbg;
  color: #textcolour;
  font-family: 'Your Font', serif;
  border: 2px solid #bordercolour;
}
.t-yournewdesign .rsvp-photo {
  background: linear-gradient(135deg, #photo1, #photo2);
}
.t-yournewdesign .rsvp-divider { background: #linecolour; }
.t-yournewdesign .rsvp-submit {
  background: #buttoncolour;
  color: #buttontextcolour;
}
```

Then in the `<script>` section, add to the `TEMPLATE_CLASS` object:
```js
"Your New Design": "t-yournewdesign"
```

## C. Add to Admin Generator List

Edit `admin.html`. Find `ALL_TEMPLATES` and add your design name:

```js
var ALL_TEMPLATES = [
  "Garden Romance", "Midnight Glamour", /* ... */, "Your New Design"
];
```

## D. Push to GitHub

```bash
git add .
git commit -m "Add Your New Design template"
git push
```

Cloudflare auto-deploys in ~30 seconds. Done!

---

# PART 5 — Adding Downloadable Files (Excel, PDFs)

1. **Host the file** somewhere public:
   - Supabase Storage (free 1GB, recommended)
   - Google Drive (set link to "Anyone with link")
   - Dropbox

2. Admin → **Downloads** → "+ Add Download"
3. Fill in name, description, file URL, price
4. Save → instantly appears at `/downloads.html`

---

# PART 6 — Stripe Checkout Worker (Cloudflare)

Copy this code into a new Cloudflare Worker (replace `YOUR_STRIPE_SECRET_KEY`):

```js
export default {
  async fetch(request) {
    if (request.method !== "POST") return new Response("Method not allowed", { status: 405 });
    const { priceId, userId, userEmail, plan, trialDays, successUrl, cancelUrl } = await request.json();
    const params = new URLSearchParams({
      "mode": "subscription",
      "success_url": successUrl,
      "cancel_url": cancelUrl,
      "customer_email": userEmail,
      "client_reference_id": userId,
      "line_items[0][price]": priceId,
      "line_items[0][quantity]": "1",
      "metadata[plan]": plan
    });
    if (trialDays > 0) params.append("subscription_data[trial_period_days]", trialDays.toString());
    const res = await fetch("https://api.stripe.com/v1/checkout/sessions", {
      method: "POST",
      headers: {
        "Authorization": "Bearer YOUR_STRIPE_SECRET_KEY",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: params
    });
    const session = await res.json();
    return new Response(JSON.stringify({ sessionId: session.id }), {
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" }
    });
  }
};
```

Settings → Routes → add: `your-domain.com/api/create-checkout`

---

# PART 7 — Test the Full Flow

1. Visit your live homepage
2. Browse Templates → click any **Try Demo** button
3. The actual RSVP page opens in test mode — you can fill it in and submit
4. Try sign up flow → check email → log in to dashboard
5. Sign in as `jansoy55@hotmail.com` → admin panel
6. **Customer Sites → "+ Generate Site"** → pick the user → fill in details → save
7. Sign in as the customer again → dashboard shows live URL
8. Open the URL → submit a real RSVP
9. Sign in as customer → see RSVP appear in dashboard

---

# 📋 Files In Your Package

| File | What it does |
|---|---|
| `index.html` | Vibrant landing with loader |
| `rsvp.html` | **Live RSVP engine** — loads any customer's site |
| `templates.html` | Browse 60 designs by category |
| `preview.html` | Static design preview |
| `signup.html` | Create account + Stripe checkout |
| `login.html` | Sign in (email/Google/Apple) |
| `dashboard.html` | Customer area with live URL |
| `admin.html` | Manage customers, sites, templates, downloads |
| `downloads.html` | Public Excel/document downloads |
| `reset-password.html` | Password reset |
| `css/theme.css` | Deep wine/burgundy theme |
| `js/occasi-auth.js` | Supabase + Stripe config |
| `supabase-setup.sql` | Database schema |
| `_redirects` | Cloudflare clean URL routing |

---

# 🔄 Changing Admin Email

When you get a real email:
1. `js/occasi-auth.js` → change `ADMIN_EMAIL`
2. `supabase-setup.sql` → find/replace `jansoy55@hotmail.com` (8 places)
3. Run updated policies in Supabase SQL Editor
4. `git push` to GitHub

---

# 💡 Pro Tips

- **Stripe test mode**: use `pk_test_…` keys + test card `4242 4242 4242 4242`
- **Site slugs**: keep them short, lowercase, hyphenated (e.g. `smith-2026`)
- **Mobile testing**: open Chrome DevTools (F12) → device toolbar
- **QR codes**: free generators like qr-code-generator.com
- **Custom domain**: Cloudflare Pages → Custom domains → SSL automatic
