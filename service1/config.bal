import ballerina/os;

// Platform-injected address of the service2 dependency (design.json
// dependencies[].wiring.envBindings.address = SERVICE2_URL). Defaulted so the
// service starts with no required env vars; the platform overrides it at
// deploy time.
configurable string rawService2Url = os:getEnv("SERVICE2_URL");

final string service2Url = normalizeBaseUrl(rawService2Url.length() > 0 ? rawService2Url : "http://service2:9090");

// Strips a trailing `/` so a path joined onto this base never doubles up with
// the generated client's own leading `/`.
function normalizeBaseUrl(string url) returns string {
    if url.endsWith("/") {
        return url.substring(0, url.length() - 1);
    }
    return url;
}
