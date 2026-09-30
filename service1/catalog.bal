import service1.service2;

final service2:Client service2Client = check new (service2Url);

// Fetches every record in the catalog service2 currently serves, paging at
// its max limit (100) until `next` is exhausted. Runs the same way whatever
// service2's current mode is — no branching on catalog size.
function fetchAllRecords() returns service2:Record[]|error {
    service2:Record[] allRecords = [];
    int offset = 0;
    boolean hasMore = true;
    while hasMore {
        service2:inline_response_200 page = check service2Client->/catalog.get(offset = offset, 'limit = 100);
        allRecords.push(...page.data);
        string? next = page?.next;
        offset = offset + page.data.length();
        hasMore = next is string && next.length() > 0;
    }
    return allRecords;
}
