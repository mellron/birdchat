# Interview Cheatsheet — Priyanka Gaikwad (Offshore React Engineer)

## Timeline

| Section                  | Duration |
| ------------------------ | -------- |
| Intros (us + candidate)  | ~5 min   |
| React/JS Basics          | ~10 min  |
| Secure Coding            | ~15 min  |
| Playwright/Testing       | ~10 min  |
| Practical (screen share) | ~20 min  |

---

## React/JS Basics (~10 min)

Questions to probe against their claimed experience:

- **What are the rules of hooks, and why do they exist? What breaks if you call a hook inside a conditional?**
  - _Short:_ Hooks must be called at the top level, in the same order, every render. React tracks hook state by call index, not by name.
  - _Why:_ A conditional hook shifts the index on later renders, so React hands the wrong state to the wrong hook. Good candidates connect the rule to the underlying linked-list implementation rather than reciting "the linter says so."

- **What does the dependency array in `useEffect` actually do? What goes wrong when you leave a dependency out?**
  - _Short:_ It's the comparison list React uses to decide whether to re-run the effect. Omitting a dep captures a stale value from the render the effect was created in.
  - _Why:_ Stale closures are the single most common React bug — an interval or callback that keeps reading the first render's state forever. Listen for whether they reach for `useRef` or a functional state update as the fix.

- **What is the virtual DOM and what problem does it solve? Is it always faster than direct DOM manipulation?**
  - _Short:_ An in-memory tree React diffs to compute a minimal set of real DOM mutations. Not inherently faster — it's a trade of CPU for predictability and a declarative model.
  - _Why:_ Candidates who claim "virtual DOM is faster, full stop" are repeating a slogan. The honest answer is it makes performance *good enough by default* without hand-tuned updates.

- **Explain lifting state up vs. prop drilling vs. Context. When does Context become the wrong tool?**
  - _Short:_ Lift state to the nearest common ancestor; Context avoids threading props through intermediate layers. Context re-renders every consumer when its value changes.
  - _Why:_ Context is not a state manager — putting frequently-changing state in a top-level provider re-renders half the app. Good answers mention splitting contexts or memoizing the provider value.

- **You have a list that re-renders slowly. Walk me through how you'd diagnose it.**
  - _Short:_ Profile first (React DevTools Profiler), find what's re-rendering and why, then apply the narrowest fix: stable keys, `React.memo`, `useMemo`/`useCallback`, or virtualization.
  - _Why:_ Tests whether they measure or guess. Blanket-memoizing everything before profiling is a yellow flag.

- **What is the difference between `useMemo` and `useCallback`? What is the actual cost of using them?**
  - _Short:_ `useMemo` caches a computed value, `useCallback` caches a function identity. Both cost memory and a dependency comparison on every render.
  - _Why:_ Memoization isn't free — checks whether they understand it's a trade-off, not a best practice to apply everywhere.

- **Redux vs. Context vs. local state — how do you decide? What does Redux buy you at this point?**
  - _Short:_ Local state by default; Redux for shared, frequently-updated state that needs devtools, middleware, or time-travel debugging.
  - _Why:_ Their resume lists Redux on Verizon Digital 2.0 — see whether they can defend the choice or just inherited it.

**Resume-specific probes:**

- The resume is Vue-heavy in the most recent work (Vuex, Vue2→Vue3 migration on the Adidas DIM module) while React appears mainly on the older Verizon project. **Ask directly: how much React have you written in the last 12 months?** This role is React-first.
- They list Redux on Verizon Digital 2.0 — ask them to describe the store shape and how async data was fetched (thunks? sagas? RTK Query?).
- Ask what they'd carry over from the Vue 2→3 migration analysis: what actually made a component hard to migrate? Good analytical answer here partly offsets thinner recent React.
- TypeScript is listed but no project describes it in depth — ask what typing a React component's props looks like, and where they've used generics.

---

## Secure Coding / Vulnerability Remediation (~15 min)

**Core mandate: This role's primary task is closing vulnerable items across our front-end codebase.**

General knowledge:

- Walk me through what happens in a stored XSS attack, start to finish. How is it different from reflected XSS?
- Where does React escape output automatically, and name the places where it does *not*.
- When is it legitimate to reach for `dangerouslySetInnerHTML`, and what has to be true before you do?
- A designer wants to render user-authored rich text (bold, links). How do you ship that safely?
- Where should a JWT live in a browser app, and what attack does each option expose you to?
- What does a Content Security Policy do, and why do inline scripts and `unsafe-eval` undermine it?
- What is CORS actually protecting, and why is a permissive `Access-Control-Allow-Origin: *` sometimes fine and sometimes dangerous?
- How would you keep secrets (API keys, config) out of a front-end bundle? What do you do when someone has already committed one?

Vulnerability remediation workflow (key area):

- Describe the last security finding you personally fixed — what was it, how did you find out, what did you change?
- Your build reports 60 npm advisories the morning of a release. What do you do first, and what do you tell the release manager?
- How do you tell a real risk from noise in a dependency scan? What makes an advisory *not* apply to your app?
- A vulnerable package is three levels deep in the dependency tree and unmaintained. What are your options?
- What tooling have you used for this? (npm audit, Snyk, Dependabot, SonarQube, OWASP ZAP, ESLint security plugins)
- Banking work usually comes with security review gates — what did the security process look like at Infosys/Finacle or on the Verizon project? Who signed off, and what did they check?
- How do you verify that a fix actually closed the vulnerability rather than just silencing the scanner?

---

## Playwright/Testing (~10 min)

**Core mandate: This role must help drive automated functional/integration test coverage to 70%.**

> ⚠️ Their resume lists **no testing tools at all** — no Jest, no Playwright, no Cypress. Start from "what testing have you done?" rather than assuming a baseline, and spend the time finding out whether there's a foundation to build on.

Test strategy & coverage:

- What testing have you written yourself, in any framework? Walk me through a test you're proud of.
- On the Verizon and Adidas projects, who wrote the tests — you, a separate QA team, or nobody?
- How would you decide what to test first in a codebase that has almost no tests today?
- What does "70% coverage" mean to you? Is it a useful goal, and where does it mislead?
- How do you test a component that fetches from an API? (mocking, fixtures, MSW, intercepting at the network layer)
- What makes a test valuable versus one that just inflates the coverage number?

Playwright depth (calibrate down if they've never used it):

- Have you used Playwright, Cypress, or Selenium? What did you like or dislike?
- How does an E2E test know the page is ready? What's wrong with `waitForTimeout`?
- A test passes locally and fails one run in five in CI. How do you track that down?
- How would you keep login out of every single test? (storage state, auth setup projects, API-level login)
- How do you keep tests independent so they can run in parallel?
- What would you need from us to get Playwright running in CI for the first time?

**If they have no Playwright experience:** pivot to learning signal — ask how they'd get up to speed in two weeks, and whether they've picked up an unfamiliar tool on the job before (the Vue 2→3 migration analysis is a reasonable example to draw out).

---

## Practical — Code Review (~20 min)

_Candidate shares screen. Present the vulnerable code and ask them to identify/fix the issue._

### Challenge 1: XSS via `dangerouslySetInnerHTML`

```jsx
function CommentList({ comments }) {
  return (
    <ul>
      {comments.map((c) => (
        <li key={c.id}>
          <strong>{c.author}</strong>
          <div dangerouslySetInnerHTML={{ __html: c.body }} />
        </li>
      ))}
    </ul>
  );
}
```

**Vulnerability:** Stored XSS — comment bodies come from other users and are injected as raw HTML. Any `<img onerror=...>` or `<script>`-equivalent payload runs with the victim's session.

**Acceptable solutions:**

Plaintext approach (best if rich text isn't a requirement):

```jsx
<div>{c.body}</div>
```

Sanitized approach (if formatting must be preserved):

```jsx
import DOMPurify from "dompurify";

<div
  dangerouslySetInnerHTML={{
    __html: DOMPurify.sanitize(c.body, {
      ALLOWED_TAGS: ["b", "i", "em", "strong", "a"],
      ALLOWED_ATTR: ["href"],
    }),
  }}
/>;
```

**Follow-ups:** Why isn't escaping on input alone sufficient? Where else could this data be rendered (email, PDF, native app) where React's escaping wouldn't protect you?

---

### Challenge 2: Open Redirect After Login

```jsx
function LoginPage() {
  const handleSuccess = () => {
    const returnTo = new URLSearchParams(window.location.search).get("returnTo");
    window.location.href = returnTo || "/dashboard";
  };
  // ...
}
```

**Vulnerability:** Open redirect. An attacker sends `/login?returnTo=https://evil.example.com/login` — the victim authenticates on the real site and is bounced to a convincing phishing page. Also accepts `javascript:` URLs in some browsers.

**Acceptable solution:**

```jsx
const safeReturnTo = (raw) => {
  if (!raw) return "/dashboard";
  // Only allow same-origin, path-relative destinations.
  const parsed = new URL(raw, window.location.origin);
  return parsed.origin === window.location.origin
    ? parsed.pathname + parsed.search
    : "/dashboard";
};

window.location.href = safeReturnTo(returnTo);
```

Also acceptable: reject anything not matching `/^\/(?!\/)/` (leading slash, but not protocol-relative `//evil.com`), or validate against an allowlist of known routes.

**Follow-ups:** Why does a naive `returnTo.startsWith("/")` check fail? (`//evil.com` is protocol-relative and leaves your origin.) Given their banking background, ask whether they've seen this class of bug in a login flow before.

---

## Notes / Red Flags to Watch For

- **Recency mismatch (biggest concern):** The most recent work (Adidas DIM, Mar–Jun 2026) is Vue/Vuex, not React. React appears on the Verizon project that ended Dec 2025. Confirm how current their React actually is.
- **Zero testing tools on the resume.** No Jest, Playwright, Cypress, or Vitest anywhere. A core mandate of this role is driving coverage to 70% — establish whether there's any foundation here or whether we'd be teaching from zero.
- **Zero security tools on the resume.** No scanners, no remediation experience described. The other core mandate is vuln remediation. Banking/Finacle work implies exposure to security process; find out if it was hands-on or if security was someone else's team.
- **Employment gap:** Verizon assignment ends Dec 2025, Adidas starts Mar 2026 — roughly two months unaccounted for. Worth one neutral question.
- **Short recent engagement:** The Adidas DIM assignment is ~4 months (Mar–Jun 2026). Ask whether that was scoped as a short project or ended early.
- **"4+ years" vs. 2017 graduation:** Nine years since the B.E. but only 4+ years claimed. Ask them to walk the timeline start to finish — there may be an earlier role not on this resume.
- **Dated tooling:** SVN, Notepad++, Eclipse, Oracle 12c suggest long stretches in legacy enterprise environments. Confirm comfort with modern Git workflows, PR review, and CI.
- **Resume is thin on individual ownership.** Bullets are generic ("bug fixing", "developing and customizing screens on requirement"). Push for one specific, hard problem they solved end to end.
- Front-end only is fine — not expected to touch DBs beyond possibly writing automated tests against them.
