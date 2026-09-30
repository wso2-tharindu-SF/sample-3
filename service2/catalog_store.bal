// In-memory catalog store: the fixed full-mode dataset, the current mode,
// and the pagination logic shared by the /catalog resource.

// The fixed 10-record catalog served in full mode (verbatim seed data).
final Record[] fullCatalog = [
    {id: 1, name: "alpha-record", score: 41},
    {id: 2, name: "beta-record", score: 17},
    {id: 3, name: "gamma-record", score: 63},
    {id: 4, name: "delta-record", score: 28},
    {id: 5, name: "epsilon-record", score: 55},
    {id: 6, name: "zeta-record", score: 12},
    {id: 7, name: "eta-record", score: 39},
    {id: 8, name: "theta-record", score: 74},
    {id: 9, name: "iota-record", score: 21},
    {id: 10, name: "kappa-record", score: 8}
];

// Starts in full mode.
"full"|"empty" catalogMode = "full";

// Returns the mode currently in effect.
function getCatalogMode() returns "full"|"empty" {
    return catalogMode;
}

// Switches the mode, taking effect immediately on the next /catalog read.
function setCatalogMode("full"|"empty" newMode) returns "full"|"empty" {
    catalogMode = newMode;
    return catalogMode;
}

// The dataset the current mode serves.
function currentCatalog() returns Record[] {
    if catalogMode == "empty" {
        return [];
    }
    return fullCatalog;
}

// Builds one paginated page of the given items, clamping limit to [1, 100]
// and offset to a non-negative value.
function paginate(Record[] items, int requestedLimit, int requestedOffset) returns CatalogPage {
    int pageLimit = requestedLimit;
    if pageLimit > 100 {
        pageLimit = 100;
    }
    if pageLimit < 1 {
        pageLimit = 1;
    }

    int pageOffset = requestedOffset;
    if pageOffset < 0 {
        pageOffset = 0;
    }

    int total = items.length();
    int endIndex = pageOffset + pageLimit;
    if endIndex > total {
        endIndex = total;
    }

    Record[] pageData = [];
    if pageOffset < total {
        pageData = items.slice(pageOffset, endIndex);
    }

    string? next = ();
    if endIndex < total {
        next = string `/catalog?limit=${pageLimit}&offset=${endIndex}`;
    }

    string? previous = ();
    if pageOffset > 0 {
        int previousOffset = pageOffset - pageLimit;
        if previousOffset < 0 {
            previousOffset = 0;
        }
        previous = string `/catalog?limit=${pageLimit}&offset=${previousOffset}`;
    }

    return {count: total, next: next, previous: previous, data: pageData};
}
