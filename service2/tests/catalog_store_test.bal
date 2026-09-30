import ballerina/test;

@test:Config {}
function testStartsInFullModeWithTenRecords() {
    "full"|"empty" _ = setCatalogMode("full");
    Record[] catalog = currentCatalog();
    test:assertEquals(catalog.length(), 10);
    test:assertEquals(catalog[0], {id: 1, name: "alpha-record", score: 41});
    test:assertEquals(catalog[9], {id: 10, name: "kappa-record", score: 8});
}

@test:Config {}
function testEmptyModeServesNoRecords() {
    "full"|"empty" _ = setCatalogMode("empty");
    Record[] catalog = currentCatalog();
    test:assertEquals(catalog.length(), 0);
    _ = setCatalogMode("full");
}

@test:Config {}
function testPaginateClampsLimitAndReportsNextPage() {
    Record[] catalog = currentCatalog();
    CatalogPage page = paginate(catalog, 1000, 0);
    test:assertEquals(page.count, 10);
    test:assertEquals(page.data.length(), 10);
    test:assertEquals(page.next, ());
    test:assertEquals(page.previous, ());
}

@test:Config {}
function testPaginateSecondPageHasPrevious() {
    Record[] catalog = currentCatalog();
    CatalogPage page = paginate(catalog, 5, 5);
    test:assertEquals(page.count, 10);
    test:assertEquals(page.data.length(), 5);
    test:assertEquals(page.data[0], {id: 6, name: "zeta-record", score: 12});
    test:assertEquals(page.next, ());
    test:assertEquals(page.previous, "/catalog?limit=5&offset=0");
}
