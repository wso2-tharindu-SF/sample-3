# sample-3 — PRD

## Problem Statement

Consumers of aggregate scoring data need a single, reliable number that summarizes a catalog of scored records, without having to fetch the raw catalog themselves and compute it. Today that catalog lives behind a separate internal service, and there is no simple endpoint that hands back the summary directly.

## Solution

A two-service system: Service2 holds a catalog of scored records and can be switched, through an internal control, between serving its full catalog and serving an empty one. Service1 fetches whatever catalog Service2 currently holds and returns the average score across it, as a whole number. End Users only ever talk to Service1; Service2 and its mode switch stay internal.

## Actors

- **End User** — calls Service1 to get the current average score. Never talks to Service2 directly and cannot switch its mode.
- **Internal Operator** — uses Service2's internal operations endpoint to switch it between full mode and empty mode. Not reachable by, or exposed to, End Users.

## User Stories

1. As an End User, I want to request the average score of the current catalog from Service1, so that I get the aggregate figure without fetching and computing it myself.
2. As an End User, I want a request to a path Service1 does not serve to return a structured 404 response, so that I get clear, consistent feedback on a bad request.
3. As an Internal Operator, I want to switch Service2 between full mode and empty mode through its internal operations endpoint, so that I can control which catalog data the system is currently serving.

## Product Decisions

- **Fixed catalog data**: Service2's full-mode catalog is exactly this data, reproduced verbatim in both the design and the seed data (see Further Notes for the table): 10 records, each with an id, a name, and a score.
- **Starting state**: Service2 starts in full mode.
- **Mode switch**: Service2's internal operations endpoint switches it between full mode (the fixed catalog above) and empty mode (a catalog with no records). This endpoint is internal only and is never reachable by an End User.
- **Average computation**: Service1 asks Service2 for its current catalog and returns the average score — the sum of every record's score divided by the number of records — as a whole number, discarding any remainder. Against the full catalog this average is 35.
- **One computation, every catalog**: the same computation runs for whichever catalog Service2 currently serves. There is no separate path, and no separate result, tied to any particular catalog.
- **Request logging**: both Service1 and Service2 log how many records they handled for each request they serve. *assumed*
- **Unmatched-path errors**: a request to a path Service1 does not serve returns a structured 404 body.
- **Service1 access**: End Users can reach Service1's average endpoint with no sign-in required — it is a read-only, non-sensitive summary. *assumed*
- **Single documented outcome**: Service1's contract documents exactly one response for its average endpoint — the successful average — plus the structured 404 for paths it does not serve; no other 4xx or 5xx outcome is documented on that endpoint, regardless of cause.
- **No alternative response shape for empty mode**: neither service's contract adds an empty-catalog variant, an alternative response, or an optional field to accommodate an empty catalog. Empty mode is a fault condition for anything downstream of Service2's catalog, not a documented alternative shape.

## Out of Scope

- What Service1 returns, computes, or reports when Service2's catalog is empty — no value, default, or error response is defined for that case in this version.
- Any additional catalog operations beyond serving the current catalog (Service2) and computing its average (Service1).
- Any End User-facing way to view or switch Service2's mode — that control is internal-only, via Service2's operations endpoint.
- Any authentication or authorization scheme beyond keeping Service2's operations endpoint unreachable by End Users. *assumed*

## Open Questions

None at this time — the idea specifies this project's behavior precisely enough to proceed.

## Further Notes

Service2's full-mode catalog, reproduced verbatim from the source idea: