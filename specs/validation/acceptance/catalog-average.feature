Feature: Average score

  @story-1
  Rule: Service1 returns the average score of the current catalog, as a whole number

    Scenario: Averaging the full catalog
      Given the catalog is in full mode
      When an End User requests the average score from Service1
      Then Service1 returns an average of 35

  @story-2
  Rule: A request to a path Service1 does not serve returns a structured error

    @negative
    Scenario: Requesting an unknown path
      When an End User requests a path Service1 does not serve
      Then Service1 responds with a structured 404 error body
