import ballerina/http;
import ballerina/log;
import service1.service2;

listener http:Listener ep0 = new (9090);

service / on ep0 {
    // GET /average-score — the only operation this contract documents; no
    // other 4xx/5xx is declared on it. `|error` lets an upstream failure
    // fetching the catalog map to a plain 500, never a documented response.
    resource function get average\-score() returns AverageScore|error {
        service2:Record[] records = check fetchAllRecords();
        int recordCount = records.length();
        int total = 0;
        foreach service2:Record item in records {
            total += item.score;
        }
        // service2 can legitimately serve an empty catalog (mode="empty");
        // an average over zero records is defined as 0, not a crash.
        int average = recordCount > 0 ? total / recordCount : 0;
        log:printInfo("computed average score", recordCount = recordCount);
        return {average: average};
    }

    // Cross-cutting catch-all: any path/method this service does not serve
    // gets a structured 404 body instead of the default plain-text one. The
    // literal `/average-score` resource above always wins the dispatch first.
    resource function 'default [string... path]() returns http:NotFound {
        return <http:NotFound>{body: {code: 404, message: "Resource not found", path: "/" + string:'join("/", ...path)}};
    }
}

public type AverageScore record {|
    # Sum of every record's score divided by the number of records, discarding any remainder
    int average;
|};

type NotFoundError record {|
    int code;
    string message;
    string path;
|};
